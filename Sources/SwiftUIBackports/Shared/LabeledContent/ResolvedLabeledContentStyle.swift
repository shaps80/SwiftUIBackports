import SwiftUI

/// This provides a concrete view that wraps the style, ensuring custom styles
/// still recieve updates to things like Environment and DynamicProperty's
private struct ResolvedLabeledContentStyle<Style: BackportLabeledContentStyle>: View {
    var configuration: Style.Configuration
    var style: Style
    var body: some View {
        style.makeBody(configuration: configuration)
    }
}

internal extension BackportLabeledContentStyle {
    func resolve(configuration: Configuration) -> some View {
        ResolvedLabeledContentStyle(configuration: configuration, style: self)
    }
}
