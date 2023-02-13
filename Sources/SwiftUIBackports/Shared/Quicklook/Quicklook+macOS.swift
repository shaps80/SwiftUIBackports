import SwiftUI
import SwiftBackports

#if os(macOS)
import QuickLook
import QuickLookUI

final class PreviewController<Items>: NSViewController, QLPreviewPanelDataSource, QLPreviewPanelDelegate where Items: RandomAccessCollection, Items.Element == URL {
    private let panel = QLPreviewPanel.shared()!
    private weak var windowResponder: NSResponder?

    var items: Items

    var selection: Binding<Items.Element?> {
        didSet {
            updateControllerLifecycle(
                from: oldValue.wrappedValue,
                to: selection.wrappedValue
            )
        }
    }

    private func updateControllerLifecycle(from oldValue: Items.Element?, to newValue: Items.Element?) {
        switch (oldValue, newValue) {
        case (.none, .some):
            present()
        case (.some, .some):
            update()
        case (.some, .none):
            dismiss()
        case (.none, .none):
            break
        }
    }

    init(selection: Binding<Items.Element?>, in items: Items) {
        self.selection = selection
        self.items = items
        super.init(nibName: nil, bundle: nil)
        windowResponder = NSApp.mainWindow?.nextResponder
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = .init(frame: .zero)
    }

    var isVisible: Bool {
        QLPreviewPanel.sharedPreviewPanelExists() && panel.isVisible
    }

    private func present() {
        print("Present")

        NSApp.mainWindow?.nextResponder = self

        if isVisible {
            panel.updateController()
            let index = selection.wrappedValue.flatMap { items.firstIndex(of: $0) }
            panel.currentPreviewItemIndex = items.distance(from: items.startIndex, to: index ?? items.startIndex)
        } else {
            panel.makeKeyAndOrderFront(nil)
        }
    }

    private func update() {
        present()
    }

    private func dismiss() {
        selection.wrappedValue = nil
    }

    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        items.isEmpty ? 1 : items.count
    }

    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        if items.isEmpty {
            return selection.wrappedValue as? NSURL
        } else {
            let index = items.index(items.startIndex, offsetBy: index)
            return items[index] as NSURL
        }
    }

    override func acceptsPreviewPanelControl(_ panel: QLPreviewPanel!) -> Bool {
        print("Accept")
        return true
    }

    override func beginPreviewPanelControl(_ panel: QLPreviewPanel!) {
        print("Begin")
        panel.dataSource = self
        panel.reloadData()
    }

    override func endPreviewPanelControl(_ panel: QLPreviewPanel!) {
        print("End")
        panel.dataSource = nil
        dismiss()
    }

}

#endif
