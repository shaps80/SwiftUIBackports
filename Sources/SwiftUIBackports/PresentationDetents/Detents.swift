import SwiftUI

@available(iOS, deprecated: 15)
public extension Backport where Content: View {

    /// Sets the available detents for the enclosing sheet.
    ///
    /// By default, sheets support the ``PresentationDetent/large`` detent.
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents([.medium, .large])
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter detents: A set of supported detents for the sheet.
    ///   If you provide more that one detent, people can drag the sheet
    ///   to resize it.
    @ViewBuilder
    func presentationDetents(_ detents: Set<Backport<Any>.PresentationDetent>) -> some View {
        if #available(iOS 15, *) {
            content.background(Backport<Any>.Representable(detents: detents, selection: .constant(.large)))
        } else {
            content
        }
    }


    /// Sets the available detents for the enclosing sheet, giving you
    /// programmatic control of the currently selected detent.
    ///
    /// By default, sheets support the ``PresentationDetent/large`` detent.
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///         @State private var settingsDetent = PresentationDetent.medium
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents:(
    ///                         [.medium, .large],
    ///                         selection: $settingsDetent
    ///                      )
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - detents: A set of supported detents for the sheet.
    ///     If you provide more that one detent, people can drag the sheet
    ///     to resize it.
    ///   - selection: A ``Binding`` to the currently selected detent.
    ///     Ensure that the value matches one of the detents that you
    ///     provide for the `detents` parameter.
    @ViewBuilder
    func presentationDetents(_ detents: Set<Backport<Any>.PresentationDetent>, selection: Binding<Backport<Any>.PresentationDetent>) -> some View {
        if #available(iOS 15, *) {
            content.background(Backport<Any>.Representable(detents: detents, selection: selection))
        } else {
            content
        }
    }

}

@available(iOS, deprecated: 15)
public extension Backport where Content == Any {

    /// A type that represents a height where a sheet naturally rests.
    struct PresentationDetent: Hashable {

        fileprivate let id: String

        /// The system detent for a sheet that's approximately half the height of
        /// the screen, and is inactive in compact height.
        public static var medium: PresentationDetent {
            .init(id: "com.apple.UIKit.medium")
        }

        /// The system detent for a sheet at full height.
        public static var large: PresentationDetent {
            .init(id: "com.apple.UIKit.large")
        }

        fileprivate static var none: PresentationDetent {
            return .init(id: "")
        }

    }
}

@available(iOS 15, *)
private extension Backport where Content == Any {
    struct Representable: UIViewControllerRepresentable {
        let detents: Set<Backport<Any>.PresentationDetent>
        let selection: Binding<Backport<Any>.PresentationDetent>

        func makeUIViewController(context: Context) -> Backport.Representable.Controller {
            Controller(detents: detents, selection: selection)
        }

        func updateUIViewController(_ controller: Backport.Representable.Controller, context: Context) {
            controller.update(detents: detents, selection: selection)
        }
    }
}

@available(iOS 15, *)
private extension Backport.Representable {
    final class Controller: UIViewController, UISheetPresentationControllerDelegate {

        var detents: Set<Backport<Any>.PresentationDetent>
        var selection: Binding<Backport<Any>.PresentationDetent>
        weak var _delegate: UISheetPresentationControllerDelegate?

        init(detents: Set<Backport<Any>.PresentationDetent>, selection: Binding<Backport<Any>.PresentationDetent>) {
            self.detents = detents
            self.selection = selection
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)

            if let controller = parent?.sheetPresentationController {
                if controller.delegate !== self {
                    _delegate = controller.delegate
                }

                controller.delegate = self
                controller.prefersScrollingExpandsWhenScrolledToEdge = true
                update(detents: detents, selection: selection)
            }
        }

        func update(detents: Set<Backport<Any>.PresentationDetent>, selection: Binding<Backport<Any>.PresentationDetent>) {
            self.detents = detents
            self.selection = selection

            if let controller = parent?.sheetPresentationController {
                controller.animateChanges {
                    controller.detents = detents.map {
                        switch $0 {
                        case .medium:
                            return .medium()
                        default:
                            return .large()
                        }
                    }
                    
                    controller.selectedDetentIdentifier = .init(selection.wrappedValue.id)
                }
            }
        }

        func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
            if let id = sheetPresentationController.selectedDetentIdentifier?.rawValue {
                selection.wrappedValue = .init(id: id)
            }
        }

    }
}
