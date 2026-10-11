import SwiftBackports

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
        // Plain `State` storage instead of `@State`: with Swift 6.4 (Xcode 27) the default
        // value symbol of the wrapped property is not emitted for the initializers in
        // the other files, which fails at link time.
        private var activity = State<ActivityItem<Data>?>(initialValue: nil)

        let label: Label
        let data: Data
        let subject: String?
        let message: String?
        let preview: (Data.Element) -> SharePreview<PreviewImage, PreviewIcon>

        public var body: some View {
            Button {
                activity.wrappedValue = ActivityItem(data: data)
            } label: {
                label
            }
            .shareSheet(item: activity.projectedValue)
        }
    }
}
#endif
