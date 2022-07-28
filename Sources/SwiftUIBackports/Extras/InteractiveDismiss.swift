import SwiftUI

#if os(iOS) || os(tvOS)
public extension View {

    /// Provides fine-grained control over the dismissal.
    /// - Parameters:
    ///   - isModal: If `true`, the user will not be able to interactively dismiss
    ///   - onAttempt: A closure that will be called when an interactive dismiss attempt occurs.
    ///   You can use this as an opportunity to present an ActionSheet to prompt the user.
    func presentation(isModal: Bool = true, _ onAttempt: (() -> Void)? = nil) -> some View {
        background(Backport.Representable(isModal: isModal, onAttempt: onAttempt))
    }

}

private extension Backport where Wrapped == Any {
    struct Representable: UIViewControllerRepresentable {
        let isModal: Bool
        let onAttempt: (() -> Void)?

        func makeUIViewController(context: Context) -> Backport.Representable.Controller {
            Controller(isModal: isModal, onAttempt: onAttempt)
        }

        func updateUIViewController(_ controller: Backport.Representable.Controller, context: Context) {
            controller.update(isModal: isModal, onAttempt: onAttempt)
        }
    }
}

private extension Backport.Representable {
    final class Controller: UIViewController, UIAdaptivePresentationControllerDelegate {
        var isModal: Bool
        var onAttempt: (() -> Void)?
        weak var _delegate: UIAdaptivePresentationControllerDelegate?

        init(isModal: Bool, onAttempt: (() -> Void)?) {
            self.isModal = isModal
            self.onAttempt = onAttempt
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            if let controller = parent?.presentationController {
                if controller.delegate !== self {
                    _delegate = controller.delegate
                    controller.delegate = self
                }
            }
            update(isModal: isModal, onAttempt: onAttempt)
        }

        func update(isModal: Bool, onAttempt: (() -> Void)?) {
            self.isModal = isModal
            self.onAttempt = onAttempt

            parent?.isModalInPresentation = isModal
        }

        func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
            onAttempt?()
        }

        func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            parent?.isModalInPresentation == false
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
