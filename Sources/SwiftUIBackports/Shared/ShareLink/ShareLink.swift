#if os(macOS) || os(iOS)
import SwiftUI
#if canImport(LinkPresentation)
import LinkPresentation
#endif

@available(iOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
@available(tvOS, unavailable)
public extension Backport where Wrapped == Any {
    struct ShareLink<Data, PreviewImage, PreviewIcon, Label>: View where Data: RandomAccessCollection, Data.Element: Shareable, Label: View {
        @State private var activity: ActivityItem<Data>?

        let label: Label
        let data: Data
        let subject: String?
        let message: String?
        let preview: (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>

        public var body: some View {
            Button {
                activity = ActivityItem(data: data)
            } label: {
                label
            }
            .shareSheet(item: $activity)
        }
    }
}

//final class TransferableActivityProvider<Data: Shareable, Image: View, Icon: View>: UIActivityItemProvider {
//    let title: String?
//    let subject: String?
//    let message: String?
//    let image: Image?
//    let icon: Icon?
//    let data: Data
//
//    init(data: Data, title: String?, subject: String?, message: String?, image: Image?, icon: Icon?) {
//        self.title = title
//        self.subject = subject
//        self.message = message
//        self.image = image
//        self.icon = icon
//        self.data = data
//
//        let url = URL(fileURLWithPath: NSTemporaryDirectory())
//            .appendingPathComponent("tmp")
//            .appendingPathExtension(data.pathExtension)
//
//        super.init(placeholderItem: url)
//    }
//
//    override var item: Any {
//        data.itemProvider as Any
//    }
//
//    override func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
//        let metadata = LPLinkMetadata()
//        metadata.title = title
////        let icon = ImageRenderer(content: activity.icon)
////        metadata.iconProvider = NSItemProvider(object: UIImage())
////        metadata.imageProvider = NSItemProvider(object: UIImage())
//        return metadata
//    }
//
//    override func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String { subject ?? "" }
//
//}
#endif
