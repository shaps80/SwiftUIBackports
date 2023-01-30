//#if os(iOS)
//import SwiftUI
//import PhotosUI
//
//internal extension View {
//    @ViewBuilder
//    func _photoPicker(
//        isPresented: Binding<Bool>,
//        selection: Binding<[Backport<Any>.PhotosPickerItem]>,
//        filter: Backport<Any>.PHPickerFilter?,
//        maxSelectionCount: Int?,
//        selectionBehavior: Backport<Any>.PhotosPickerSelectionBehavior,
//        preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy,
//        library: PHPhotoLibrary
//    ) -> some View {
//        if #available(iOS 14, *) {
//            backport.background {
//                PhotosViewController(
//                    isPresented: isPresented,
//                    selection: selection,
//                    filter: filter,
//                    maxSelectionCount: maxSelectionCount,
//                    selectionBehavior: selectionBehavior,
//                    preferredItemEncoding: preferredItemEncoding,
//                    library: library
//                )
//            }
//        } else {
//            backport.background {
//                LegacyPhotosViewController(isPresented: isPresented, selection: selection, filter: filter)
//            }
//        }
//    }
//}
//
//@available(iOS 14, *)
//private struct PhotosViewController: UIViewControllerRepresentable {
//    @Binding var isPresented: Bool
//    @Binding var selection: [Backport<Any>.PhotosPickerItem]
//
//    let options: PHFetchOptions
//
//    init(isPresented: Binding<Bool>, selection: Binding<[Backport<Any>.PhotosPickerItem]>, filter: Backport<Any>.PHPickerFilter?, maxSelectionCount: Int?, selectionBehavior: Backport<Any>.PhotosPickerSelectionBehavior, preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy, library: PHPhotoLibrary) {
//        _isPresented = isPresented
//        _selection = selection
//
//        options = PHFetchOptions()
//        options.predicate = filter?.predicate
//
//        if #available(iOS 15, *) {
//            configuration.selection = selectionBehavior.behaviour
//        }
//
//        self.configuration = configuration
//    }
//
//    func makeUIViewController(context: Context) -> Representable {
//        Representable(
//            isPresented: $isPresented,
//            selection: $selection,
//            configuration: configuration
//        )
//    }
//
//
//    func updateUIViewController(_ controller: Representable, context: Context) {
//        controller.selection = $selection
//        controller.configuration = configuration
//    }
//}
//
//@available(iOS 14, *)
//private extension PhotosViewController {
//    final class Representable: UIViewController, PHPickerViewControllerDelegate, UIAdaptivePresentationControllerDelegate {
//        private weak var controller: PHPickerViewController?
//
//        var isPresented: Binding<Bool> {
//            didSet {
//                updateControllerLifecycle(
//                    from: oldValue.wrappedValue,
//                    to: isPresented.wrappedValue
//                )
//            }
//        }
//
//        var selection: Binding<[Backport<Any>.PhotosPickerItem]>
//        var configuration: PHPickerConfiguration
//
//        init(isPresented: Binding<Bool>, selection: Binding<[Backport<Any>.PhotosPickerItem]>, configuration: PHPickerConfiguration) {
//            self.isPresented = isPresented
//            self.selection = selection
//            self.configuration = configuration
//
//            super.init(nibName: nil, bundle: nil)
//        }
//
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//
//        private func updateControllerLifecycle(from oldValue: Bool, to newValue: Bool) {
//            switch (oldValue, newValue) {
//            case (false, true):
//                presentController()
//            case (true, false):
//                dismissController()
//            case (true, true), (false, false):
//                break
//            }
//        }
//
//        private func presentController() {
//            let controller = PHPickerViewController(configuration: configuration)
//            controller.presentationController?.delegate = self
//            controller.delegate = self
//            present(controller, animated: true)
//            self.controller = controller
//        }
//
//        private func dismissController() {
//            isPresented.wrappedValue = false
//            guard let controller else { return }
//            controller.presentedViewController?.dismiss(animated: true)
//        }
//
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            print(results)
//            dismissController()
//        }
//
//        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
//            dismissController()
//        }
//    }
//}
//
//@available(iOS 13, *)
//private struct LegacyPhotosViewController: UIViewControllerRepresentable {
//    @Binding var isPresented: Bool
//    @Binding var selection: [Backport<Any>.PhotosPickerItem]
//
//    let filter: Backport<Any>.PHPickerFilter?
//
//    func makeUIViewController(context: Context) -> Representable {
//        Representable(
//            isPresented: $isPresented,
//            selection: $selection,
//            filter: filter
//        )
//    }
//
//
//    func updateUIViewController(_ controller: Representable, context: Context) {
//        controller.selection = $selection
//        controller.filter = filter
//    }
//}
//
//@available(iOS 13, *)
//private extension LegacyPhotosViewController {
//    final class Representable: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAdaptivePresentationControllerDelegate {
//        private weak var controller: UIImagePickerController?
//
//        var isPresented: Binding<Bool> {
//            didSet {
//                updateControllerLifecycle(
//                    from: oldValue.wrappedValue,
//                    to: isPresented.wrappedValue
//                )
//            }
//        }
//
//        var selection: Binding<[Backport<Any>.PhotosPickerItem]>
//        var filter: Backport<Any>.PHPickerFilter?
//
//        init(isPresented: Binding<Bool>, selection: Binding<[Backport<Any>.PhotosPickerItem]>, filter: Backport<Any>.PHPickerFilter?) {
//            self.isPresented = isPresented
//            self.selection = selection
//            self.filter = filter
//
//            super.init(nibName: nil, bundle: nil)
//        }
//
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//
//        private func updateControllerLifecycle(from oldValue: Bool, to newValue: Bool) {
//            switch (oldValue, newValue) {
//            case (false, true):
//                presentController()
//            case (true, false):
//                dismissController()
//            case (true, true), (false, false):
//                break
//            }
//        }
//
//        private func presentController() {
//            let controller = UIImagePickerController()
//
//            if let filter {
//                controller.mediaTypes = filter.mediaTypes
//            } else if let types = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
//                controller.mediaTypes = types
//            }
//
//            controller.allowsEditing = false
//            controller.sourceType = .photoLibrary
//            controller.videoQuality = .typeHigh
//            controller.presentationController?.delegate = self
//            controller.delegate = self
//
//            present(controller, animated: true)
//            self.controller = controller
//        }
//
//        private func dismissController() {
//            isPresented.wrappedValue = false
//            guard let controller else { return }
//            controller.presentedViewController?.dismiss(animated: true)
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//            print("TBD")
//            print(info)
//            dismissController()
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            dismissController()
//        }
//
//        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
//            dismissController()
//        }
//    }
//}
//#endif
