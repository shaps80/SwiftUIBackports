import SwiftUI

/// This provides a concrete view that wraps the style, ensuring custom styles
/// still recieve updates to things like Environment and DynamicProperty's
@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
private struct ResolvedTipViewStyle<Style: BackportTipViewStyle>: View {
    var configuration: Style.Configuration
    var style: Style
    var body: some View {
        style.makeBody(configuration: configuration)
    }
}

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
internal extension BackportTipViewStyle {
    func resolve(configuration: Configuration) -> some View {
        ResolvedTipViewStyle(configuration: configuration, style: self)
    }
}
