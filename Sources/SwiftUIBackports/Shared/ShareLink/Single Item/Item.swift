import SwiftUI

@available(iOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
@available(tvOS, unavailable)
public extension Backport.ShareLink where Wrapped == Any {
    init(item: String, subject: String? = nil, message: String? = nil)
    where Data == CollectionOfOne<String>, PreviewImage == Never, PreviewIcon == Never, Label == DefaultShareLinkLabel {
        self.label = .init()
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0) }
    }

    init(item: URL, subject: String? = nil, message: String? = nil)
    where Data == CollectionOfOne<URL>, PreviewImage == Never, PreviewIcon == Never, Label == DefaultShareLinkLabel {
        self.label = .init()
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0.absoluteString) }
    }

    init(item: String, subject: String? = nil, message: String? = nil, @ViewBuilder label: () -> Label)
    where PreviewIcon == Never, PreviewImage == Never, Data == CollectionOfOne<String> {
        self.label = label()
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0) }
    }

    init(item: URL, subject: String? = nil, message: String? = nil, @ViewBuilder label: () -> Label)
    where PreviewIcon == Never, PreviewImage == Never, Data == CollectionOfOne<URL> {
        self.label = label()
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0.absoluteString) }
    }
}
