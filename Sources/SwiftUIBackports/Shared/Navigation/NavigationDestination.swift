import SwiftUI

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(watchOS, deprecated: 9)
@available(macOS, deprecated: 13)
public extension Backport where Content: View {

    /// Associates a destination view with a presented data type for use within
    /// a navigation stack.
    ///
    /// Add this view modifer to a view inside a ``NavigationStack`` to
    /// describe the view that the stack displays when presenting
    /// a particular kind of data. Use a ``NavigationLink`` to present
    /// the data. For example, you can present a `ColorDetail` view for
    /// each presentation of a ``Color`` instance:
    ///
    ///     NavigationStack {
    ///         List {
    ///             NavigationLink("Mint", value: Color.mint)
    ///             NavigationLink("Pink", value: Color.pink)
    ///             NavigationLink("Teal", value: Color.teal)
    ///         }
    ///         .navigationDestination(for: Color.self) { color in
    ///             ColorDetail(color: color)
    ///         }
    ///         .navigationTitle("Colors")
    ///     }
    ///
    /// You can add more than one navigation destination modifier to the stack
    /// if it needs to present more than one kind of data.
    ///
    /// - Parameters:
    ///   - data: The type of data that this destination matches.
    ///   - destination: A view builder that defines a view to display
    ///     when the stack's navigation state contains a value of
    ///     type `data`. The closure takes one argument, which is the value
    ///     of the data to present.
    func navigationDestination<D: Hashable, C: View>(for data: D.Type, @ViewBuilder destination: @escaping (D) -> C) -> some View {
        content
            .environment(\.navigationDestinations, [
                .init(type: D.self): .init { destination($0 as! D) }
            ])
    }

}

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(watchOS, deprecated: 9)
@available(macOS, deprecated: 13)
public extension Backport where Content == Any {
    struct NavigationLink<Label, Destination>: View where Label: View, Destination: View {
        @Environment(\.navigationDestinations) private var destinations

        private let valueType: AnyMetaType
        private let value: Any?
        private let label: Label
        private let destination: () -> Destination

        public init<P>(value: P?, @ViewBuilder label: () -> Label) where Destination == Never {
            self.value = value
            self.valueType = .init(type: P.self)
            self.destination = { fatalError() }
            self.label = label()
        }

        public var body: some View {
            SwiftUI.NavigationLink {
                if let value = value {
                    destinations[valueType.type]?.content(value)
                }
            } label: {
                label
            }
            .disabled(value == nil)
        }
    }
}

private struct NavigationDestinationsEnvironmentKey: EnvironmentKey {
    static var defaultValue: [AnyMetaType: DestinationView] = [:]
}

private extension EnvironmentValues {
    var navigationDestinations: [AnyMetaType: DestinationView] {
        get { self[NavigationDestinationsEnvironmentKey.self] }
        set {
            var current = self[NavigationDestinationsEnvironmentKey.self]
            newValue.forEach { current[$0] = $1 }
            self[NavigationDestinationsEnvironmentKey.self] = current
        }
    }
}

private struct AnyMetaType {
    let type: Any.Type
}

extension AnyMetaType: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.type == rhs.type
    }
}

extension AnyMetaType: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }
}

private extension Dictionary {
    subscript(_ key: Any.Type) -> Value? where Key == AnyMetaType {
        get { self[.init(type: key)] }
        _modify { yield &self[.init(type: key)] }
    }
}

private struct DestinationView: View {
    let content: (Any) -> AnyView
    var body: Never { fatalError() }
    init<Content: View>(content: @escaping (Any) -> Content) {
        self.content = { AnyView(content($0)) }
    }
}
