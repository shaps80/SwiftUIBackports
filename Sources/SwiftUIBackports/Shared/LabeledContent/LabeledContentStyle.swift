import SwiftUI
import SwiftBackports

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
extension Backport where Wrapped: View {
    /// Sets a style for labeled content.
    public func labeledContentStyle<S>(_ style: S) -> some View where S: BackportLabeledContentStyle {
        wrapped.environment(\.backportLabeledContentStyle, .init(style))
    }
}

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
public protocol BackportLabeledContentStyle: DynamicProperty {
    typealias Configuration = Backport<Any>.LabeledContentStyleConfiguration
    associatedtype Body: View
    @ViewBuilder func makeBody(configuration: Configuration) -> Body
}

internal struct AnyLabeledContentStyle: BackportLabeledContentStyle {
    typealias Configuration = Backport<Any>.LabeledContentStyleConfiguration
    let _makeBody: (Configuration) -> AnyView
    
    init<S: BackportLabeledContentStyle>(_ style: S) {
        _makeBody = { config in
            AnyView(style.makeBody(configuration: config))
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

private struct BackportLabeledContentStyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: AnyLabeledContentStyle = .init(.automatic)
}

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
internal extension EnvironmentValues {
    var backportLabeledContentStyle: AnyLabeledContentStyle {
        get { self[BackportLabeledContentStyleEnvironmentKey.self] }
        set { self[BackportLabeledContentStyleEnvironmentKey.self] = newValue }
    }
}
