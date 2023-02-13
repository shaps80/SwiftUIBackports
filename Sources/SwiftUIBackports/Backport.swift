import SwiftUI
@_exported import SwiftBackports

public extension View {
    /// Wraps a SwiftUI `View` that can be extended to provide backport functionality.
    var backport: Backport<Self> { .init(self) }
}

public extension AnyTransition {
    /// Wraps an `AnyTransition` that can be extended to provide backport functionality.
    static var backport: Backport<AnyTransition>{
        Backport(.identity)
    }
}
