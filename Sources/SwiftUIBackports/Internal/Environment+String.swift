import SwiftUI
import SwiftBackports

private extension EnvironmentValues {

    func containsValue(forKey key: String) -> Bool {
        return value(forKey: key) != nil
    }

    func value<T>(forKey key: String, from mirror: Mirror, as: T.Type) -> T? {
        // Found a match
        if let value = mirror.descendant("value", "some") {
            if let typedValue = value as? T {
                print("Found value")
                return typedValue
            } else {
                print("Value for key '\(key)' in the environment is of type '\(type(of: value))', but we expected '\(String(describing: T.self))'.")
            }
        } else {
            print("Found key '\(key)' in the environment, but it doesn't have the expected structure. The type hierarchy may have changed in your SwiftUI version.")
        }

        return nil
    }

    /// Extracts a value from the environment by the name of its associated EnvironmentKey.
    /// Can be used to grab private environment values such as foregroundColor ("ForegroundColorKey").
    func value<T>(forKey key: String, as: T.Type) -> T? {
        if let mirror = value(forKey: key) as? Mirror {
            return value(forKey: key, from: mirror, as: T.self)
        } else if let value = value(forKey: key) as? T {
            return value
        } else {
            return nil
        }
    }

    func value(forKey key: String) -> Any? {
        func keyFromTypeName(typeName: String) -> String? {
            let expectedPrefix = "TypedElement<EnvironmentPropertyKey<"
            guard typeName.hasPrefix(expectedPrefix) else {
                print("Wrong prefix")
                return nil
            }
            let rest = typeName.dropFirst(expectedPrefix.count)
            let expectedSuffix = ">>"
            guard rest.hasSuffix(expectedSuffix) else {
                print("Wrong suffix")
                return nil
            }
            let middle = rest.dropLast(expectedSuffix.count)
            return String(middle)
        }

        /// `environmentMember` has type (for example) `TypedElement<EnvironmentPropertyKey<ForegroundColorKey>>`
        /// TypedElement.value contains the value of the key.
        func extract(startingAt environmentNode: Any) -> Any? {
            let mirror = Mirror(reflecting: environmentNode)

            let typeName = String(describing: type(of: environmentNode))
            if let nodeKey = keyFromTypeName(typeName: typeName) {
                if key == nodeKey {
                    return mirror
                }
            }

            // Environment values are stored in a doubly linked list. The "before" and "after" keys point
            // to the next environment member.
            if let linkedListMirror = mirror.superclassMirror,
               let nextNode = linkedListMirror.descendant("after", "some") {
                return extract(startingAt: nextNode)
            }

            return nil
        }

        let mirror = Mirror(reflecting: self)

        if let firstEnvironmentValue = mirror.descendant("_plist", "elements", "some") {
            if let node = extract(startingAt: firstEnvironmentValue) {
                return node
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

}

@propertyWrapper
internal struct StringlyTypedEnvironment<Value> {
    final class Store<StoredValue>: ObservableObject {
        var value: StoredValue? = nil
    }

    @Environment(\.self) private var env
    @ObservedObject private var store = Store<Value>()

    var key: String

    init(key: String) {
        self.key = key
    }

    private(set) var wrappedValue: Value? {
        get { store.value }
        nonmutating set { store.value = newValue }
    }
}

extension StringlyTypedEnvironment: DynamicProperty {
    func update() {
        wrappedValue = env.value(forKey: key, as: Value.self)
    }
}

@propertyWrapper
internal struct EnvironmentContains: DynamicProperty {
    final class Store: ObservableObject {
        var contains: Bool = false
    }

    @Environment(\.self) private var env

    var key: String
    @ObservedObject private var store = Store()

    init(key: String) {
        self.key = key
    }

    var wrappedValue: Bool {
        get { store.contains }
        nonmutating set { store.contains = newValue }
    }

    func update() {
        wrappedValue = env.containsValue(forKey: key)
    }
}
