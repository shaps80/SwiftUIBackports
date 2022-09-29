import SwiftUI

public struct ShareLink<Data, PreviewImage, PreviewIcon, Label>: View where Data: RandomAccessCollection, Label: View {
    @State private var showSheet: Bool = false

    let label: Label
    let data: Data
    let subject: String?
    let message: String?
    let preview: (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>

    public var body: some View {
        Button {
            showSheet = true
        } label: {
            label
        }
        .activitySheet(isPresented: $showSheet)
    }
}

// Sharing an item
public extension ShareLink {
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

// Sharing an item with a preview
public extension ShareLink {
    init<I: Transferable>(item: I, subject: String? = nil, message: String? = nil, preview: SharePreview<PreviewImage, PreviewIcon>)
    where Data == CollectionOfOne<I>, Label == DefaultShareLinkLabel {
        self.label = .init()
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { _ in preview }
    }
    
    init<I: Transferable>(item: I, subject: String? = nil, message: String? = nil, preview: SharePreview<PreviewImage, PreviewIcon>, @ViewBuilder label: () -> Label)
    where Data == CollectionOfOne<I> {
        self.label = label()
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { _ in preview }
    }
}

// Sharing an item with a label
public extension ShareLink {
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

// Sharing an item with a label and preview
public extension ShareLink {
    init<S: StringProtocol, I: Transferable>(_ title: S, item: I, subject: String? = nil, message: String? = nil, preview: SharePreview<PreviewImage, PreviewIcon>)
    where Data == CollectionOfOne<I>, Label == DefaultShareLinkLabel {
        self.label = .init(title)
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { _ in preview }
    }
    
    init<I: Transferable>(_ titleKey: LocalizedStringKey, item: I, subject: String? = nil, message: String? = nil, preview: SharePreview<PreviewImage, PreviewIcon>)
    where Data == CollectionOfOne<I>, Label == DefaultShareLinkLabel {
        self.label = .init(titleKey)
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { _ in preview }
    }
    
    init<I: Transferable>(_ title: Text, item: I, subject: String? = nil, message: String? = nil, preview: SharePreview<PreviewImage, PreviewIcon>)
    where Data == CollectionOfOne<I>, Label == DefaultShareLinkLabel {
        self.label = .init(title)
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { _ in preview }
    }
}

// Sharing items
public extension ShareLink {
    init(items: Data, subject: String? = nil, message: String? = nil)
    where PreviewImage == Never, PreviewIcon == Never, Data.Element == String, Label == DefaultShareLinkLabel {
        self.label = .init()
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = { .init($0) }
    }
    
    init(items: Data, subject: String? = nil, message: String? = nil)
    where PreviewImage == Never, PreviewIcon == Never, Data.Element == URL, Label == DefaultShareLinkLabel {
        self.label = .init()
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = { .init($0.absoluteString) }
    }
    
    init(items: Data, subject: String? = nil, message: String? = nil, @ViewBuilder label: () -> Label)
    where PreviewImage == Never, PreviewIcon == Never, Data.Element == String {
        self.label = label()
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = { .init($0) }
    }
    
    init(items: Data, subject: String? = nil, message: String? = nil, @ViewBuilder label: () -> Label)
    where PreviewImage == Never, PreviewIcon == Never, Data.Element == URL {
        self.label = label()
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = { .init($0.absoluteString) }
    }
}

// Sharing items with a preview
public extension ShareLink {
    init(items: Data, subject: String? = nil, message: String? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>)
    where Data.Element: Transferable, Label == DefaultShareLinkLabel {
        self.label = .init()
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = preview
    }

    init(items: Data, subject: String? = nil, message: String? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>, @ViewBuilder label: () -> Label)
    where Data.Element: Transferable {
        self.label = label()
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = preview
    }
}

// Sharing items with a label
public extension ShareLink {
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

// Sharing items with a label and preview
public extension ShareLink {
    init<S: StringProtocol>(_ title: S, items: Data, subject: String? = nil, message: String? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>)
    where Data.Element: Transferable, Label == DefaultShareLinkLabel
    {
        self.label = .init(title)
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = preview
    }
    
    init(_ titleKey: LocalizedStringKey, items: Data, subject: String? = nil, message: String? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>)
    where Data.Element: Transferable, Label == DefaultShareLinkLabel
    {
        self.label = .init(titleKey)
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = preview
    }
    
    init(_ title: Text, items: Data, subject: String? = nil, message: String? = nil, preview: @escaping (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>)
    where Data.Element: Transferable, Label == DefaultShareLinkLabel
    {
        self.label = .init(title)
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = preview
    }
}

public protocol Transferable { }
extension String: Transferable { }
extension URL: Transferable { }
extension Image: Transferable { }
