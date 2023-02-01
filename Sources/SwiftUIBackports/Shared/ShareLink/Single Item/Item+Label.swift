#if os(macOS) || os(iOS)
import SwiftUI

@available(iOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
@available(tvOS, unavailable)
public extension Backport.ShareLink where Wrapped == Any {
    init<S: StringProtocol>(_ title: S, item: String, subject: String? = nil, message: String? = nil)
    where PreviewIcon == Never, PreviewImage == Never, Data == CollectionOfOne<String>, Label == Text {
        self.label = Text(title)
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0) }
    }

    init(_ titleKey: LocalizedStringKey, item: String, subject: String? = nil, message: String? = nil)
    where PreviewIcon == Never, PreviewImage == Never, Data == CollectionOfOne<String>, Label == Text {
        self.label = Text(titleKey)
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0) }
    }

    init(_ title: Text, item: String, subject: String? = nil, message: String? = nil)
    where PreviewIcon == Never, PreviewImage == Never, Data == CollectionOfOne<String>, Label == Text {
        self.label = title
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0) }
    }

    init<S: StringProtocol>(_ title: S, item: URL, subject: String? = nil, message: String? = nil)
    where PreviewIcon == Never, PreviewImage == Never, Data == CollectionOfOne<URL>, Label == Text {
        self.label = Text(title)
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0.absoluteString) }
    }

    init(_ titleKey: LocalizedStringKey, item: URL, subject: String? = nil, message: String? = nil)
    where PreviewIcon == Never, PreviewImage == Never, Data == CollectionOfOne<URL>, Label == Text {
        self.label = Text(titleKey)
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0.absoluteString) }
    }

    init(_ title: Text, item: URL, subject: String? = nil, message: String? = nil)
    where PreviewIcon == Never, PreviewImage == Never, Data == CollectionOfOne<URL>, Label == Text {
        self.label = title
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0.absoluteString) }
    }
}
#endif
