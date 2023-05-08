import SwiftUI

#if os(iOS)
@available(iOS, deprecated: 15)
public extension Backport where Wrapped == Any {
    /// A property wrapper type that can read and write a value that SwiftUI updates
    /// as the placement of focus within the scene changes.
    ///
    /// Use this property wrapper in conjunction with ``View/backport.focused(_:equals:)``
    /// and ``View/backport.focused(_:)`` to
    /// describe views whose appearance and contents relate to the location of
    /// focus in the scene. When focus enters the modified view, the wrapped value
    /// of this property updates to match a given prototype value. Similarly, when
    /// focus leaves, the wrapped value of this property resets to `nil`
    /// or `false`. Setting the property's value programmatically has the reverse
    /// effect, causing focus to move to the view associated with the
    /// updated value.
    ///
    /// In the following example of a simple login screen, when the user presses the
    /// Sign In button and one of the fields is still empty, focus moves to that
    /// field. Otherwise, the sign-in process proceeds.
    ///
    ///     struct LoginForm {
    ///         enum Field: Hashable {
    ///             case username
    ///             case password
    ///         }
    ///
    ///         @State private var username = ""
    ///         @State private var password = ""
    ///         @Backport.FocusState private var focusedField: Field?
    ///
    ///         var body: some View {
    ///             Form {
    ///                 TextField("Username", text: $username)
    ///                     .backport.focused($focusedField, equals: .username)
    ///
    ///                 SecureField("Password", text: $password)
    ///                     .backport.focused($focusedField, equals: .password)
    ///
    ///                 Button("Sign In") {
    ///                     if username.isEmpty {
    ///                         focusedField = .username
    ///                     } else if password.isEmpty {
    ///                         focusedField = .password
    ///                     } else {
    ///                         handleLogin(username, password)
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// To allow for cases where focus is completely absent from a view tree, the
    /// wrapped value must be either an optional or a Boolean. Set the focus binding
    /// to `false` or `nil` as appropriate to remove focus from all bound fields.
    /// You can also use this to remove focus from a ``TextField`` and thereby
    /// dismiss the keyboard.
    ///
    @propertyWrapper
    struct FocusState<Value>: DynamicProperty where Value: Hashable {
        @State private var value: Value

        public var projectedValue: Binding<Value> {
            Binding(
                get: { wrappedValue },
                set: { wrappedValue = $0 }
            )
        }

        public var wrappedValue: Value {
            get { value }
            nonmutating set { value = newValue }
        }

        public init() where Value == Bool {
            _value = .init(initialValue: false)
        }

        public init<T>() where Value == T?, T: Hashable {
            _value = .init(initialValue: nil)
        }
    }
}
#endif
