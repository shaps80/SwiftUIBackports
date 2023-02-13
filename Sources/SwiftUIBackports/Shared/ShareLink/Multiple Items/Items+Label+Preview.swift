//import SwiftUI
//import SwiftBackports
//
//@available(iOS, deprecated: 16)
//@available(macOS, deprecated: 13)
//@available(watchOS, deprecated: 9)
//@available(tvOS, unavailable)
//public extension Backport.ShareLink where Wrapped == Any {
//    init<S: StringProtocol>(_ title: S, items: Data, subject: String? = nil, message: String? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>)
//    where Data.Element: Shareable, Label == DefaultShareLinkLabel
//    {
//        self.label = .init(title)
//        self.data = items
//        self.subject = subject
//        self.message = message
//        self.preview = preview
//    }
//
//    init(_ titleKey: LocalizedStringKey, items: Data, subject: String? = nil, message: String? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>)
//    where Data.Element: Shareable, Label == DefaultShareLinkLabel
//    {
//        self.label = .init(titleKey)
//        self.data = items
//        self.subject = subject
//        self.message = message
//        self.preview = preview
//    }
//
//    init(_ title: Text, items: Data, subject: String? = nil, message: String? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>)
//    where Data.Element: Shareable, Label == DefaultShareLinkLabel
//    {
//        self.label = .init(title)
//        self.data = items
//        self.subject = subject
//        self.message = message
//        self.preview = preview
//    }
//}
