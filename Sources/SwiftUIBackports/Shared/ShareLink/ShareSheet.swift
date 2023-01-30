import SwiftUI

extension View {
    @ViewBuilder
    func shareSheet<Data>(item activityItems: Binding<ActivityItem<Data>?>) -> some View where Data: RandomAccessCollection, Data.Element: Shareable {
#if os(macOS)
        background(ShareSheet(item: activityItems))
#elseif os(iOS)
        background(ShareSheet(item: activityItems))
#endif
    }
}

#if os(macOS)

private struct ShareSheet<Data>: NSViewRepresentable where Data: RandomAccessCollection, Data.Element: Shareable {
    @Binding var item: ActivityItem<Data>?

    public func makeNSView(context: Context) -> SourceView {
        SourceView(item: $item)
    }

    public func updateNSView(_ view: SourceView, context: Context) {
        view.item = $item
    }

    final class SourceView: NSView, NSSharingServicePickerDelegate, NSSharingServiceDelegate {
        var picker: NSSharingServicePicker?

        var item: Binding<ActivityItem<Data>?> {
            didSet {
                updateControllerLifecycle(
                    from: oldValue.wrappedValue,
                    to: item.wrappedValue
                )
            }
        }

        init(item: Binding<ActivityItem<Data>?>) {
            self.item = item
            super.init(frame: .zero)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func updateControllerLifecycle(from oldValue: ActivityItem<Data>?, to newValue: ActivityItem<Data>?) {
            switch (oldValue, newValue) {
            case (.none, .some):
                presentController()
            case (.some, .none):
                dismissController()
            case (.some, .some), (.none, .none):
                break
            }
        }

        func presentController() {
            picker = NSSharingServicePicker(items: item.wrappedValue?.data.map { $0 } ?? [])
            picker?.delegate = self
            DispatchQueue.main.async {
                guard self.window != nil else { return }
                self.picker?.show(relativeTo: self.bounds, of: self, preferredEdge: .minY)
            }
        }

        func dismissController() {
            item.wrappedValue = nil
        }

        func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, delegateFor sharingService: NSSharingService) -> NSSharingServiceDelegate? {
            return self
        }

        public func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, didChoose service: NSSharingService?) {
            sharingServicePicker.delegate = nil
            dismissController()
        }

        func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, sharingServicesForItems items: [Any], proposedSharingServices proposedServices: [NSSharingService]) -> [NSSharingService] {
            proposedServices
        }
    }
}

#elseif os(iOS)

private struct ShareSheet<Data>: UIViewControllerRepresentable where Data: RandomAccessCollection, Data.Element: Shareable {
    @Binding var item: ActivityItem<Data>?

    init(item: Binding<ActivityItem<Data>?>) {
        _item = item
    }

    func makeUIViewController(context: Context) -> Representable {
        Representable(item: $item)
    }

    func updateUIViewController(_ controller: Representable, context: Context) {
        controller.item = $item
    }
}

private extension ShareSheet {
    final class Representable: UIViewController, UIAdaptivePresentationControllerDelegate, UISheetPresentationControllerDelegate {
        private weak var controller: UIActivityViewController?

        var item: Binding<ActivityItem<Data>?> {
            didSet {
                updateControllerLifecycle(
                    from: oldValue.wrappedValue,
                    to: item.wrappedValue
                )
            }
        }

        init(item: Binding<ActivityItem<Data>?>) {
            self.item = item
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func updateControllerLifecycle(from oldValue: ActivityItem<Data>?, to newValue: ActivityItem<Data>?) {
            switch (oldValue, newValue) {
            case (.none, .some):
                presentController()
            case (.some, .none):
                dismissController()
            case (.some, .some), (.none, .none):
                break
            }
        }

        private func presentController() {
            let controller = UIActivityViewController(activityItems: item.wrappedValue?.data.map { $0 } ?? [], applicationActivities: nil)
            controller.presentationController?.delegate = self
            controller.popoverPresentationController?.permittedArrowDirections = .any
            controller.popoverPresentationController?.sourceRect = view.bounds
            controller.popoverPresentationController?.sourceView = view
            controller.completionWithItemsHandler = { [weak self] _, _, _, _ in
                self?.item.wrappedValue = nil
                self?.dismiss(animated: true)
            }
            present(controller, animated: true)
            self.controller = controller
        }

        private func dismissController() {
            guard let controller else { return }
            controller.presentingViewController?.dismiss(animated: true)
        }

        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            dismissController()
        }
    }
}
#endif
