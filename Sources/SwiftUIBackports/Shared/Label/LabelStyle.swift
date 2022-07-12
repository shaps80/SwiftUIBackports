import SwiftUI

@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, deprecated: 14)
@available(watchOS, deprecated: 7)
/// A type that applies a custom appearance to all labels within a view.
///
/// To configure the current label style for a view hierarchy, use the
/// ``View/labelStyle(_:)`` modifier.
public protocol BackportLabelStyle {

    /// The properties of a label.
    typealias Configuration = Backport<Any>.LabelStyleConfiguration

    /// A view that represents the body of a label.
    associatedtype Body: View

    /// Creates a view that represents the body of a label.
    ///
    /// The system calls this method for each ``Label`` instance in a view
    /// hierarchy where this style is the current label style.
    ///
    /// - Parameter configuration: The properties of the label.
    @ViewBuilder func makeBody(configuration: Configuration) -> Body

}


@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, deprecated: 14.0)
@available(watchOS, deprecated: 7.0)
public extension Backport where Wrapped: View {
    func labelStyle<S: BackportLabelStyle>(_ style: S) -> some View {
        content.environment(\.backportLabelStyle, .init(style))
    }
}

internal struct AnyLabelStyle: BackportLabelStyle {
    let _makeBody: (Backport<Any>.LabelStyleConfiguration) -> AnyView

    init<S: BackportLabelStyle>(_ style: S) {
        _makeBody = { config in
            AnyView(style.makeBody(configuration: config))
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

private struct BackportLabelStyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: AnyLabelStyle? = nil
}

internal extension EnvironmentValues {
    var backportLabelStyle: AnyLabelStyle? {
        get { self[BackportLabelStyleEnvironmentKey.self] }
        set { self[BackportLabelStyleEnvironmentKey.self] = newValue }
    }
}
