import SwiftUI
import SwiftBackports

#if os(iOS)
import QuickLook

final class PreviewController<Items>: UIViewController, UIAdaptivePresentationControllerDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource where Items: RandomAccessCollection, Items.Element == URL {
    var items: Items

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
        case (.some, .some):
            updateController()
        case (.some, .none):
            dismissController()
        case (.none, .none):
            break
        }
    }

    private func presentController() {
        let controller = QLPreviewController(nibName: nil, bundle: nil)
        controller.dataSource = self
        controller.delegate = self
        self.present(controller, animated: true)
        self.updateController()
    }

    private func updateController() {
        let controller = presentedViewController as? QLPreviewController
        controller?.reloadData()
        let index = selection.wrappedValue.flatMap { items.firstIndex(of: $0) }
        controller?.currentPreviewItemIndex = items.distance(from: items.startIndex, to: index ?? items.startIndex)
    }

    private func dismissController() {
        DispatchQueue.main.async {
            self.selection.wrappedValue = nil
        }
    }

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        items.isEmpty ? 1 : items.count
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        if items.isEmpty {
            return (selection.wrappedValue ?? URL(fileURLWithPath: "")) as NSURL
        } else {
            let index = items.index(items.startIndex, offsetBy: index)
            return items[index] as NSURL
        }
    }

    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        dismissController()
    }
}
#endif
