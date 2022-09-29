import SwiftUI

@available(iOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
@available(tvOS, unavailable)
public extension Backport.ShareLink where Wrapped == Any {
    init<S: StringProtocol>(_ title: S, items: Data, subject: String? = nil, message: String? = nil)
    where PreviewImage == Never, PreviewIcon == Never, Data.Element == String, Label == DefaultShareLinkLabel {
        self.label = .init(title)
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = { .init($0) }
    }

    init(_ titleKey: LocalizedStringKey, items: Data, subject: String? = nil, message: String? = nil)
    where PreviewImage == Never, PreviewIcon == Never, Data.Element == String, Label == DefaultShareLinkLabel {
        self.label = .init(titleKey)
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = { .init($0) }
    }

    init(_ title: Text, items: Data, subject: String? = nil, message: String? = nil)
    where PreviewImage == Never, PreviewIcon == Never, Data.Element == String, Label == DefaultShareLinkLabel {
        self.label = .init(title)
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = { .init($0) }
    }

    init<S: StringProtocol>(_ title: S, items: Data, subject: String? = nil, message: String? = nil)
    where PreviewImage == Never, PreviewIcon == Never, Data.Element == URL, Label == DefaultShareLinkLabel {
        self.label = .init(title)
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = { .init($0.absoluteString) }
    }

    init(_ titleKey: LocalizedStringKey, items: Data, subject: String? = nil, message: String? = nil)
    where PreviewImage == Never, PreviewIcon == Never, Data.Element == URL, Label == DefaultShareLinkLabel {
        self.label = .init(titleKey)
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = { .init($0.absoluteString) }
    }

    init(_ title: Text, items: Data, subject: String? = nil, message: String? = nil)
    where PreviewImage == Never, PreviewIcon == Never, Data.Element == URL, Label == DefaultShareLinkLabel {
        self.label = .init(title)
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = { .init($0.absoluteString) }
    }
}
