import SwiftUI

@available(tvOS, deprecated: 13)
@available(macOS, deprecated: 10.15)
@available(watchOS, deprecated: 6)
public extension View {

    /// Sets whether this presentation should act as a `modal`, preventing interactive dismissals
    /// - Parameter isModal: If `true` the user will not be able to interactively dismiss
    @ViewBuilder
    @available(iOS, deprecated: 13, renamed: "backport.interactiveDismissDisabled(_:)")
    func presentation(isModal: Bool) -> some View {
        if #available(iOS 15, *) {
            backport.interactiveDismissDisabled(isModal)
        } else {
            self
        }
    }

    /// Provides fine-grained control over the dismissal.
    /// - Parameters:
    ///   - isModal: If `true`, the user will not be able to interactively dismiss
    ///   - onAttempt: A closure that will be called when an interactive dismiss attempt occurs.
    ///   You can use this as an opportunity to present an ActionSheet to prompt the user.
    @ViewBuilder
    @available(iOS, deprecated: 13, renamed: "backport.interactiveDismissDisabled(_:onAttempt:)")
    func presentation(isModal: Bool = true, _ onAttempt: @escaping () -> Void) -> some View {
        if #available(iOS 15, *) {
            backport.interactiveDismissDisabled(isModal, onAttempt: onAttempt)
        } else {
            self
        }
    }

}
