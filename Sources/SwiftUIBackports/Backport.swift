import SwiftUI
import ObjectiveC

/// Provides a convenient method for backporting API,
/// including types, functions, properties, property wrappers and more.
///
/// To backport a SwiftUI Label for example, you could apply the
/// following extension:
///
///     extension Backport where Content == Any {
///         public struct Label<Title, Icon> { }
///     }
///
/// Now if we want to provide further extensions to our backport type,
/// we need to ensure we retain the `Content == Any` generic requirement:
///
///     extension Backport.Label where Content == Any, Title == Text, Icon == Image {
///         public init<S: StringProtocol>(_ title: S, systemName: String) { }
///     }
///
/// In addition to types, we can also provide backports for properties
/// and methods:
///
///     extension Backport.Label where Content: View {
///         func onChange<Value: Equatable>(of value: Value, perform action: (Value) -> Void) -> some View {
///             // `content` provides access to the extended type
///             content.modifier(OnChangeModifier(value, action))
///         }
///     }
///
public struct Backport<Content> {

    /// The underlying content this backport represents.
    public let content: Content

    /// Initializes a new Backport for the specified content.
    /// - Parameter content: The content (type) that's being backported
    public init(_ content: Content) {
        self.content = content
    }

}

public extension View {
    /// Wraps a SwiftUI `View` that can be extended to provide backport functionality.
    var backport: Backport<Self> { .init(self) }
}

public extension NSObjectProtocol {
    /// Wraps an `NSObject` that can be extended to provide backport functionality.
    ///
    /// Since these types generally have reference semantics, this implementation provides
    /// a mutable `Backport` to allow for usage in more broader contexts.
    ///
    ///     cell.backport.contentConfiguration = Backport.UIHostingConfiguration { }
    ///
    var backport: Backport<Self> {
        get { objc_getAssociatedObject(self, #function) as? Backport<Self> ?? Backport(self) }
        set { objc_setAssociatedObject(self, #function, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}
