import SwiftUI

extension Backport where Wrapped: View {
    public func labeledContentStyle<S>(_ style: S) -> some View where S: BackportLabeledContentStyle {
        content.environment(\.backportLabeledContentStyle, .init(style))
    }
}

public protocol BackportLabeledContentStyle {
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

internal extension EnvironmentValues {
    var backportLabeledContentStyle: AnyLabeledContentStyle {
        get { self[BackportLabeledContentStyleEnvironmentKey.self] }
        set { self[BackportLabeledContentStyleEnvironmentKey.self] = newValue }
    }
}
