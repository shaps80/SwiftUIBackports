import SwiftUI
import SwiftBackports

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
extension EnvironmentValues {

    /// The visiblity to apply to scroll indicators of any
    /// vertically scrollable content.
    public var backportVerticalScrollIndicatorVisibility: Backport<Any>.ScrollIndicatorVisibility {
        get { self[BackportVerticalIndicatorKey.self] }
        set { self[BackportVerticalIndicatorKey.self] = newValue }
    }

    /// The visibility to apply to scroll indicators of any
    /// horizontally scrollable content.
    public var backportHorizontalScrollIndicatorVisibility: Backport<Any>.ScrollIndicatorVisibility {
        get { self[BackportHorizontalIndicatorKey.self] }
        set { self[BackportHorizontalIndicatorKey.self] = newValue }
    }

    /// The way that scrollable content interacts with the software keyboard.
    ///
    /// The default value is ``Backport.ScrollDismissesKeyboardMode.automatic``. Use the
    /// ``View.backport.scrollDismissesKeyboard(_:)`` modifier to configure this
    /// property.
    public var backportScrollDismissesKeyboardMode: Backport<Any>.ScrollDismissesKeyboardMode {
        get { self[BackportKeyboardDismissKey.self] }
        set { self[BackportKeyboardDismissKey.self] = newValue }
    }

    /// A Boolean value that indicates whether any scroll views associated
    /// with this environment allow scrolling to occur.
    ///
    /// The default value is `true`. Use the ``View.backport.scrollDisabled(_:)``
    /// modifier to configure this property.
    public var backportIsScrollEnabled: Bool {
        get { self[BackportScrollEnabledKey.self] }
        set { self[BackportScrollEnabledKey.self] = newValue }
    }
    
}

private struct BackportVerticalIndicatorKey: EnvironmentKey {
    static var defaultValue: Backport<Any>.ScrollIndicatorVisibility = .automatic
}

private struct BackportHorizontalIndicatorKey: EnvironmentKey {
    static var defaultValue: Backport<Any>.ScrollIndicatorVisibility = .automatic
}

private struct BackportKeyboardDismissKey: EnvironmentKey {
    static var defaultValue: Backport<Any>.ScrollDismissesKeyboardMode = .automatic
}

private struct BackportScrollEnabledKey: EnvironmentKey {
    static var defaultValue: Bool = true
}
