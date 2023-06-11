import SwiftUI
import SwiftBackports
import SwiftUIBackportsC

@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
public extension Backport where Wrapped: View {
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
    ///   If you provide more than one detent, people can drag the sheet
    ///   to resize it.
    @ViewBuilder
    @available(iOS, introduced: 15, deprecated: 16, message: "Presentation detents are only supported in iOS 15+")
    func presentationDetents(_ detents: Set<Backport<Any>.PresentationDetent>) -> some View {
        #if os(iOS)
        wrapped.background(Backport<Any>.Representable(detents: detents, largestUndimmed: nil, selection: nil))
        #else
        wrapped
        #endif
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
    @available(iOS, introduced: 15, deprecated: 16, message: "Presentation detents are only supported in iOS 15+")
    func presentationDetents(_ detents: Set<Backport<Any>.PresentationDetent>, largestUndimmed: Backport<Any>.PresentationDetent? = nil, selection: Binding<Backport<Any>.PresentationDetent>) -> some View {
        #if os(iOS)
        wrapped.background(Backport<Any>.Representable(detents: detents, largestUndimmed: largestUndimmed, selection: selection))
        #else
        wrapped
        #endif
    }
}

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
public extension Backport<Any> {

    /// A type that represents a height where a sheet naturally rests.
    enum PresentationDetent: Hashable, Comparable {

        case medium, large, height(_ constant: CGFloat)

        @available(iOS 15.0, *)
        init?(id: UISheetPresentationController.Detent.Identifier) {
                switch id {
                case .medium:
                    self = .medium

                case .large:
                    self = .large

                default:
                    if let number = NumberFormatter().number(from: id.rawValue) {
                        let value = CGFloat(truncating: number)
                        self = .height(value)
                    } else {
                        return nil
                    }
                }
            }

        @available(iOS 15.0, *)
        public var id: UISheetPresentationController.Detent.Identifier {
            switch self {
            case .medium:
                return .medium

            case .large:
                return .large

            case let .height(value):
                return .init(value.description)
            }
        }

        @available(iOS 15.0, *)
        var system: UISheetPresentationController.Detent {
            switch self {
            case .medium:
                return .medium()

            case .large:
                return .large()

            case let .height(constant):
                if #available(iOS 16.0, *) {
                    return .custom(identifier: id, resolver: {_ in constant})
                } else {
                    return ._detent(withIdentifier: id.rawValue, constant: constant)
                }
            }
        }

        public static func < (lhs: PresentationDetent, rhs: PresentationDetent) -> Bool {
            func approxHeight(_ detent: PresentationDetent) -> CGFloat {
                switch detent {
                case .medium: return UIScreen.main.bounds.height * 0.5
                case .large: return UIScreen.main.bounds.height
                case .height(let height): return height
                }
            }
            return approxHeight(lhs) < approxHeight(rhs)
        }
    }
}

#if os(iOS)
@available(iOS 15, *)
private extension Backport<Any> {
    struct Representable: UIViewControllerRepresentable {
        let detents: Set<Backport<Any>.PresentationDetent>
        let largestUndimmed: Backport<Any>.PresentationDetent?
        let selection: Binding<Backport<Any>.PresentationDetent>?

        func makeUIViewController(context: Context) -> Backport.Representable.Controller {
            Controller(detents: detents, largestUndimmed: largestUndimmed, selection: selection)
        }

        func updateUIViewController(_ controller: Backport.Representable.Controller, context: Context) {
            controller.update(detents: detents, largestUndimmed: largestUndimmed, selection: selection)
        }
    }
}

@available(iOS 15, *)
private extension Backport.Representable {
    final class Controller: UIViewController, UISheetPresentationControllerDelegate {

        var detents: Set<Backport<Any>.PresentationDetent>
        var selection: Binding<Backport<Any>.PresentationDetent>?
        var largestUndimmed: Backport<Any>.PresentationDetent?
        weak var _delegate: UISheetPresentationControllerDelegate?

        init(detents: Set<Backport<Any>.PresentationDetent>, largestUndimmed: Backport<Any>.PresentationDetent? = nil, selection: Binding<Backport<Any>.PresentationDetent>?) {
            self.detents = detents
            self.selection = selection
            self.largestUndimmed = largestUndimmed
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
                    controller.delegate = self
                }
            }
            update(detents: detents, largestUndimmed: largestUndimmed, selection: selection)
        }

        override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
            super.willTransition(to: newCollection, with: coordinator)
            update(detents: detents, largestUndimmed: largestUndimmed, selection: selection)
        }

        func update(detents: Set<Backport<Any>.PresentationDetent>, largestUndimmed: Backport<Any>.PresentationDetent?, selection: Binding<Backport<Any>.PresentationDetent>?) {
            self.detents = detents
            self.selection = selection
            self.largestUndimmed = largestUndimmed

            if let controller = parent?.sheetPresentationController {
                DispatchQueue.main.async {
                    controller.animateChanges {
                        controller.detents = detents.sorted().map {
                            $0.system
                        }

                        controller.largestUndimmedDetentIdentifier = largestUndimmed?.id

                        if let selection = selection {
                            controller.selectedDetentIdentifier = .init(selection.wrappedValue.id.rawValue)
                        }

                        controller.prefersScrollingExpandsWhenScrolledToEdge = true
                    }
                }
            }
        }

        func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
            guard
                let selection = selection,
                let id = sheetPresentationController.selectedDetentIdentifier,
                let newSection = Backport<Any>.PresentationDetent(id: id),
                selection.wrappedValue != newSection
            else { return }
            selection.wrappedValue = newSection
        }

        override func responds(to aSelector: Selector!) -> Bool {
            if super.responds(to: aSelector) { return true }
            if _delegate?.responds(to: aSelector) ?? false { return true }
            return false
        }

        override func forwardingTarget(for aSelector: Selector!) -> Any? {
            if super.responds(to: aSelector) { return self }
            return _delegate
        }
    }
}
#endif
