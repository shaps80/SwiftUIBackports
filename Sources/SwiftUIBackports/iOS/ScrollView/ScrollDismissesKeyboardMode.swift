import SwiftUI

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
extension Backport where Wrapped == Any {

    /// The ways that scrollable content can interact with the software keyboard.
    ///
    /// Use this type in a call to the ``View.backport.scrollDismissesKeyboard(_:)``
    /// modifier to specify the dismissal behavior of scrollable views.
    public struct ScrollDismissesKeyboardMode: Hashable, CustomStringConvertible {
        internal enum DismissMode: Hashable {
            case automatic
            case immediately
            case interactively
            case never
        }

        let dismissMode: DismissMode

        #if os(iOS)
        var scrollViewDismissMode: UIScrollView.KeyboardDismissMode {
            switch dismissMode {
            case .automatic: return .none
            case .immediately: return .onDrag
            case .interactively: return .interactive
            case .never: return .none
            }
        }
        #endif

        public var description: String {
            String(describing: dismissMode)
        }

        /// Determine the mode automatically based on the surrounding context.
        ///
        /// By default, a ``TextEditor`` is interactive while a ``List``
        /// of scrollable content always dismiss the keyboard on a scroll
        public static var automatic: Self { .init(dismissMode: .automatic) }

        /// Dismiss the keyboard as soon as scrolling starts.
        public static var immediately: Self { .init(dismissMode: .immediately) }

        /// Enable people to interactively dismiss the keyboard as part of the
        /// scroll operation.
        ///
        /// The software keyboard's position tracks the gesture that drives the
        /// scroll operation if the gesture crosses into the keyboard's area of the
        /// display. People can dismiss the keyboard by scrolling it off the
        /// display, or reverse the direction of the scroll to cancel the dismissal.
        public static var interactively: Self { .init(dismissMode: .interactively) }

        /// Never dismiss the keyboard automatically as a result of scrolling.
        public static var never: Self { .init(dismissMode: .never) }

    }
    
}
