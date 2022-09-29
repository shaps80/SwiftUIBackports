import SwiftUI

@available(iOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
@available(tvOS, unavailable)
public extension Backport.ShareLink where Wrapped == Any {
    init(items: Data, subject: String? = nil, message: String? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>)
    where Data.Element: BackportTransferable, Label == DefaultShareLinkLabel {
        self.label = .init()
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = preview
    }

    init(items: Data, subject: String? = nil, message: String? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>, @ViewBuilder label: () -> Label)
    where Data.Element: BackportTransferable {
        self.label = label()
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = preview
    }
}
