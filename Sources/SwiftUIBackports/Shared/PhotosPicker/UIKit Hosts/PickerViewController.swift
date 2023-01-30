#if os(iOS)
import SwiftUI
import PhotosUI

internal extension View {
    @ViewBuilder
    func _photoPicker(
        isPresented: Binding<Bool>,
        selection: Binding<[Backport<Any>.PhotosPickerItem]>,
        filter: Backport<Any>.PHPickerFilter?,
        maxSelectionCount: Int?,
        selectionBehavior: Backport<Any>.PhotosPickerSelectionBehavior,
        preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy,
        library: PHPhotoLibrary
    ) -> some View {
        if #available(iOS 14, *) {
//            var config = PHPickerConfiguration(photoLibrary: library)
//            config.preferredAssetRepresentationMode = preferredItemEncoding.mode
//            config.selectionLimit = maxSelectionCount ?? 0
//            //        config.filter = filter.filter
//
//            if #available(iOS 15, *) {
//                config.selection = selectionBehavior.behaviour
//            }
//
//            PickerViewController(
//                isPresented: isPresented,
//                selection: selection,
//                configuration: config
//            )
        } else {
            EmptyView()
        }
    }
}

@available(iOS 14, *)
private struct PickerViewController: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selection: [Backport<Any>.PhotosPickerItem]

    let configuration: PHPickerConfiguration

    func makeUIViewController(context: Context) -> Representable {
        Representable(
            isPresented: $isPresented,
            selection: $selection,
            configuration: configuration
        )
    }


    func updateUIViewController(_ controller: Representable, context: Context) {
        controller.selection = $selection
        controller.configuration = configuration
    }
}

@available(iOS 14, *)
private extension PickerViewController {
    final class Representable: UIViewController, PHPickerViewControllerDelegate, UIAdaptivePresentationControllerDelegate {
        private weak var controller: PHPickerViewController?

        var isPresented: Binding<Bool> {
            didSet {
                updateControllerLifecycle(
                    from: oldValue.wrappedValue,
                    to: isPresented.wrappedValue
                )
            }
        }

        var selection: Binding<[Backport<Any>.PhotosPickerItem]>
        var configuration: PHPickerConfiguration

        init(isPresented: Binding<Bool>, selection: Binding<[Backport<Any>.PhotosPickerItem]>, configuration: PHPickerConfiguration) {
            self.isPresented = isPresented
            self.selection = selection
            self.configuration = configuration

            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func updateControllerLifecycle(from oldValue: Bool, to newValue: Bool) {
            switch (oldValue, newValue) {
            case (false, true):
                presentController()
            case (true, false):
                dismissController()
            case (true, true), (false, false):
                break
            }
        }

        private func presentController() {
            let controller = PHPickerViewController(configuration: configuration)
            controller.presentationController?.delegate = self
            controller.delegate = self
            present(controller, animated: true)
            self.controller = controller
        }

        private func dismissController() {
            guard let controller else { return }
            controller.presentedViewController?.dismiss(animated: true)
        }

        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            dismissController()
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            print(results)
            #warning("TBD")
        }
    }
}
#endif
