import SwiftUI

public extension Backport where Content: View {

    /// The identifier of the largest detent that is not dimmed.
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
    ///                     .presentationDetents:([.medium, .large])
    ///                     .presentationUndimmed(from: .medium)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter visibility: The preferred visibility of the drag indicator.
    @ViewBuilder
    func presentationUndimmed(from identifier: Backport<Any>.PresentationDetent.Identifier?) -> some View {
        if #available(iOS 15, *) {
            content.background(Backport<Any>.Representable(identifier: identifier))
        } else {
            content
        }
    }

}

@available(iOS 15, *)
private extension Backport where Content == Any {
    struct Representable: UIViewControllerRepresentable {
        let identifier: Backport<Any>.PresentationDetent.Identifier?

        func makeUIViewController(context: Context) -> Backport.Representable.Controller {
            Controller(identifier: identifier)
        }

        func updateUIViewController(_ controller: Backport.Representable.Controller, context: Context) {
            controller.update(identifier: identifier)
        }
    }
}

@available(iOS 15, *)
private extension Backport.Representable {
    final class Controller: UIViewController {

        var identifier: Backport<Any>.PresentationDetent.Identifier?

        init(identifier: Backport<Any>.PresentationDetent.Identifier?) {
            self.identifier = identifier
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            update(identifier: identifier)
        }

        func update(identifier: Backport<Any>.PresentationDetent.Identifier?) {
            self.identifier = identifier

            if let controller = parent?.sheetPresentationController {
                controller.animateChanges {
                    controller.largestUndimmedDetentIdentifier = identifier.flatMap {
                        .init(rawValue: $0.rawValue)
                    }
                }
            }
        }

    }
}
