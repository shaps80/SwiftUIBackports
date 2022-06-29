import Combine
import SwiftUI

@available(iOS, deprecated: 14.0)
@available(macOS, deprecated: 11.0)
@available(tvOS, deprecated: 14.0)
@available(watchOS, deprecated: 7.0)
public extension Backport where Content: ObservableObject {

    /// A property wrapper type that instantiates an observable object.
    @propertyWrapper struct StateObject: DynamicProperty {
        private final class Wrapper: ObservableObject {
            private var subject = PassthroughSubject<Void, Never>()

            var value: Content? {
                didSet {
                    cancellable = nil
                    cancellable = value?.objectWillChange
                        .sink { [subject] _ in subject.send() }
                }
            }

            private var cancellable: AnyCancellable?

            var objectWillChange: AnyPublisher<Void, Never> {
                subject.eraseToAnyPublisher()
            }
        }

        @State private var state = Wrapper()

        @ObservedObject private var observedObject = Wrapper()

        private var thunk: () -> Content

        /// The underlying value referenced by the state object.
        ///
        /// The wrapped value property provides primary access to the value's data.
        /// However, you don't access `wrappedValue` directly. Instead, use the
        /// property variable created with the `@StateObject` attribute:
        ///
        ///     @Backport.StateObject var contact = Contact()
        ///
        ///     var body: some View {
        ///         Text(contact.name) // Accesses contact's wrapped value.
        ///     }
        ///
        /// When you change a property of the wrapped value, you can access the new
        /// value immediately. However, SwiftUI updates views displaying the value
        /// asynchronously, so the user interface might not update immediately.
        public var wrappedValue: Content {
            if let object = state.value {
                return object
            } else {
                print("Dynamic property should be told to update before accessing its wrapped value")
                let object = thunk()
                state.value = object
                return object
            }
        }

        /// A projection of the state object that creates bindings to its
        /// properties.
        ///
        /// Use the projected value to pass a binding value down a view hierarchy.
        /// To get the projected value, prefix the property variable with `$`. For
        /// example, you can get a binding to a model's `isEnabled` Boolean so that
        /// a ``SwiftUI/Toggle`` view can control the value:
        ///
        ///     struct MyView: View {
        ///         @Backport.StateObject var model = DataModel()
        ///
        ///         var body: some View {
        ///             Toggle("Enabled", isOn: $model.isEnabled)
        ///         }
        ///     }
        public var projectedValue: ObservedObject<Content>.Wrapper {
            ObservedObject(wrappedValue: wrappedValue).projectedValue
        }

        /// Creates a new state object with an initial wrapped value.
        ///
        /// You don’t call this initializer directly. Instead, declare a property
        /// with the `@StateObject` attribute in a ``SwiftUI/View``,
        /// ``SwiftUI/App``, or ``SwiftUI/Scene``, and provide an initial value:
        ///
        ///     struct MyView: View {
        ///         @Backport.StateObject var model = DataModel()
        ///
        ///         // ...
        ///     }
        ///
        /// SwiftUI creates only one instance of the state object for each
        /// container instance that you declare. In the code above, SwiftUI
        /// creates `model` only the first time it initializes a particular instance
        /// of `MyView`. On the other hand, each different instance of `MyView`
        /// receives a distinct copy of the data model.
        ///
        /// - Parameter thunk: An initial value for the state object.
        public init(wrappedValue thunk: @autoclosure @escaping () -> Content) {
            self.thunk = thunk
        }

        public mutating func update() {
            if state.value == nil {
                state.value = thunk()
            }
            if observedObject.value !== state.value {
                observedObject.value = state.value
            }
        }
    }
    
}

