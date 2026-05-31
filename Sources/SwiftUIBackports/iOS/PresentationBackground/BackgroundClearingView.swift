import SwiftUI

#if os(iOS)

@available(iOS 15, *)
final class BackgroundClearingView: UIView {
    init() {
        super.init(frame: .zero)
        isHidden = true
        isUserInteractionEnabled = false
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        clearHostBackground()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        clearHostBackground()
    }

    func clearHostBackground() {
        // Walk the responder chain to find the first enclosing UIHostingController.
        // The host controller's view carries the system-provided background that
        // we want to replace; SwiftUI lays our own `.background` modifier *behind*
        // the content but *in front* of the host's view, so clearing the host's
        // background is what makes the supplied style visible.
        var controller: UIViewController? = parentController
        while let candidate = controller {
            // `UIHostingController` is generic (`UIHostingController<Content>`) and
            // Swift generics are invariant, so there is no `is` / `as?` form that
            // matches "any specialisation" of it: `is UIHostingController` fails
            // to compile (the Content parameter cannot be inferred), and
            // `as? UIHostingController<Any>` / `as? UIHostingController<AnyView>`
            // only match that exact specialisation. There is also no public
            // non-generic base class or protocol to test against. Name-based
            // identification via the Objective-C class name is the standard
            // workaround used by UIKit-bridge libraries in the SwiftUI ecosystem.
            if NSStringFromClass(type(of: candidate)).contains("UIHostingController") {
                // Only clear when the host is actually being presented as a modal,
                // so we never accidentally make the application's root host
                // transparent.
                if candidate.presentingViewController != nil {
                    candidate.view.backgroundColor = .clear
                    candidate.view.isOpaque = false
                }
                return
            }
            controller = candidate.parent
        }
    }
}

#endif
