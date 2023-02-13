//import SwiftUI
//import SwiftBackports
//
//@available(iOS, deprecated: 16)
//@available(macOS, deprecated: 13)
//@available(watchOS, deprecated: 9)
//@available(tvOS, unavailable)
//public extension Backport.ShareLink where Wrapped == Any {
//    init<S: StringProtocol, I: Shareable>(_ title: S, item: I, subject: String? = nil, message: String? = nil, preview: SharePreview<PreviewImage, PreviewIcon>)
//    where Data == CollectionOfOne<I>, Label == DefaultShareLinkLabel {
//        self.label = .init(title)
//        self.data = .init(item)
//        self.subject = subject
//        self.message = message
//        self.preview = { _ in preview }
//    }
//
//    init<I: Shareable>(_ titleKey: LocalizedStringKey, item: I, subject: String? = nil, message: String? = nil, preview: SharePreview<PreviewImage, PreviewIcon>)
//    where Data == CollectionOfOne<I>, Label == DefaultShareLinkLabel {
//        self.label = .init(titleKey)
//        self.data = .init(item)
//        self.subject = subject
//        self.message = message
//        self.preview = { _ in preview }
//    }
//
//    init<I: Shareable>(_ title: Text, item: I, subject: String? = nil, message: String? = nil, preview: SharePreview<PreviewImage, PreviewIcon>)
//    where Data == CollectionOfOne<I>, Label == DefaultShareLinkLabel {
//        self.label = .init(title)
//        self.data = .init(item)
//        self.subject = subject
//        self.message = message
//        self.preview = { _ in preview }
//    }
//}
