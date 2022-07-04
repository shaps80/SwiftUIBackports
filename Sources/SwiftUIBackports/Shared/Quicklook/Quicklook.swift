import SwiftUI
import QuickLook

@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Backport where Content: View {

    /// Presents a Quick Look preview of the URLs you provide.
    ///
    /// The Quick Look preview appears when you set the binding to a non-`nil` item.
    /// When you set the item back to `nil`, Quick Look dismisses the preview.
    /// If the value of the selection binding isn’t contained in the items collection, Quick Look treats it the same as a `nil` selection.
    ///
    /// Quick Look updates the value of the selection binding to match the URL of the file the user is previewing.
    /// Upon dismissal by the user, Quick Look automatically sets the item binding to `nil`.
    ///
    /// - Parameters:
    ///     - selection: A <doc://com.apple.documentation/documentation/SwiftUI/Binding> to an element that’s part of the items collection. This is the URL that you currently want to preview.
    ///     - items: A collection of URLs to preview.
    ///
    /// - Returns: A view that presents the preview of the contents of the URL.
    public func quickLookPreview<Items>(_ selection: Binding<Items.Element?>, in items: Items) -> some View where Items: RandomAccessCollection, Items.Element == URL {
        content.background(QuicklookSheet(selection: selection, items: items))
    }


    /// Presents a Quick Look preview of the contents of a single URL.
    ///
    /// The Quick Look preview appears when you set the binding to a non-`nil` item.
    /// When you set the item back to `nil`, Quick Look dismisses the preview.
    ///
    /// Upon dismissal by the user, Quick Look automatically sets the item binding to `nil`.
    /// Quick Look displays the preview when a non-`nil` item is set.
    /// Set `item` to `nil` to dismiss the preview.
    ///
    /// - Parameters:
    ///     - item: A <doc://com.apple.documentation/documentation/SwiftUI/Binding> to a URL that should be previewed.
    ///
    /// - Returns: A view that presents the preview of the contents of the URL.
    public func quickLookPreview(_ item: Binding<URL?>) -> some View {
        content.background(QuicklookSheet(selection: item, items: [item.wrappedValue].compactMap { $0 }))
    }

}

#if os(macOS)

private struct QuicklookSheet<Items>: NSViewRepresentable where Items: RandomAccessCollection, Items.Element == URL {
    let selection: Binding<Items.Element?>
    let items: Items

    func makeNSView(context: Context) -> QLPreviewView {
        let preview = QLPreviewView(frame: .zero, style: .normal)
        preview?.autostarts = true
        return preview ?? .init()
    }

    func updateNSView(_ view: QLPreviewView, context: Context) {
        view.previewItem = PreviewUrl(url: selection.wrappedValue)
    }
}


#elseif os(iOS)

private struct QuicklookSheet<Items>: UIViewControllerRepresentable where Items: RandomAccessCollection, Items.Element == URL {
    let selection: Binding<Items.Element?>
    let items: Items

    func makeUIViewController(context: Context) -> Representable {
        Representable(selection: selection, in: items)
    }

    func updateUIViewController(_ controller: Representable, context: Context) {
        controller.items = items
        controller.selection = selection
    }

    final class Representable: UIViewController, UIAdaptivePresentationControllerDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
        var items: Items {
            didSet { updateController() }
        }

        var selection: Binding<Items.Element?> {
            didSet {
                updateControllerLifecycle(
                    from: oldValue.wrappedValue,
                    to: selection.wrappedValue
                )
            }
        }

        init(selection: Binding<Items.Element?>, in items: Items) {
            self.selection = selection
            self.items = items
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func updateControllerLifecycle(from oldValue: Items.Element?, to newValue: Items.Element?) {
            switch (oldValue, newValue) {
            case (.none, .some):
                presentController()
            case (.some, .none):
                dismissController()
            case (.some, .some):
                updateController()
            case (.none, .none):
                break
            }
        }

        private func presentController() {
            let controller = QLPreviewController()
            controller.dataSource = self
            controller.delegate = self
            present(controller, animated: true)
        }

        private func updateController() {
            (presentedViewController as? QLPreviewController)?.reloadData()
        }

        private func dismissController() {
            DispatchQueue.main.async {
                self.selection.wrappedValue = nil
            }
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            items.count
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            let index = items.index(items.startIndex, offsetBy: index)
            return items[index] as NSURL
        }

        func previewControllerDidDismiss(_ controller: QLPreviewController) {
            dismissController()
        }
    }
}

#endif

final class PreviewUrl: NSObject, QLPreviewItem {
    let url: URL?
    init(url: URL?) { self.url = url }
    var previewItemURL: URL? { url }
    var previewItemTitle: String? { url?.lastPathComponent ?? "" }
}
