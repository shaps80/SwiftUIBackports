//import SwiftUI
//import SwiftBackports
//
//@available(iOS, deprecated: 16)
//@available(macOS, deprecated: 13)
//@available(watchOS, deprecated: 9)
//@available(tvOS, unavailable)
//public extension Backport.ShareLink where Wrapped == Any {
//    init<I: Shareable>(item: I, subject: String? = nil, message: String? = nil, preview: SharePreview<PreviewImage, PreviewIcon>)
//    where Data == CollectionOfOne<I>, Label == DefaultShareLinkLabel {
//        self.label = .init()
//        self.data = .init(item)
//        self.subject = subject
//        self.message = message
//        self.preview = { _ in preview }
//    }
//
//    init<I: Shareable>(item: I, subject: String? = nil, message: String? = nil, preview: SharePreview<PreviewImage, PreviewIcon>, @ViewBuilder label: () -> Label)
//    where Data == CollectionOfOne<I> {
//        self.label = label()
//        self.data = .init(item)
//        self.subject = subject
//        self.message = message
//        self.preview = { _ in preview }
//    }
//}
