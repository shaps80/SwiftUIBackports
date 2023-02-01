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
            sheet(isPresented: isPresented) {
                PhotosViewController(
                    isPresented: isPresented,
                    selection: selection,
                    filter: filter,
                    maxSelectionCount: maxSelectionCount,
                    selectionBehavior: selectionBehavior,
                    preferredItemEncoding: preferredItemEncoding,
                    library: library
                )
                .ignoresSafeArea()
            }
        } else {
            sheet(isPresented: isPresented) {
                LegacyPhotosViewController(
                    isPresented: isPresented,
                    selection: selection,
                    filter: filter,
                    preferredItemEncoding: preferredItemEncoding
                )
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

@available(iOS 14, *)
private struct PhotosViewController: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selection: [Backport<Any>.PhotosPickerItem]
    let configuration: PHPickerConfiguration

    init(isPresented: Binding<Bool>, selection: Binding<[Backport<Any>.PhotosPickerItem]>, filter: Backport<Any>.PHPickerFilter?, maxSelectionCount: Int?, selectionBehavior: Backport<Any>.PhotosPickerSelectionBehavior, preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy, library: PHPhotoLibrary) {
        _isPresented = isPresented
        _selection = selection

        var configuration = PHPickerConfiguration(photoLibrary: library)
        configuration.preferredAssetRepresentationMode = preferredItemEncoding.mode
        configuration.selectionLimit = maxSelectionCount ?? 0
        configuration.filter = filter?.photosFilter

        if #available(iOS 15, *) {
            configuration.selection = selectionBehavior.behaviour
        }

        self.configuration = configuration
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented, selection: $selection, configuration: configuration)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        context.coordinator.controller
    }

    func updateUIViewController(_ controller: UIViewController, context: Context) {
        context.coordinator.isPresented = $isPresented
        context.coordinator.selection = $selection
        context.coordinator.configuration = configuration
    }
}

@available(iOS 14, *)
private extension PhotosViewController {
    final class Coordinator: NSObject, PHPickerViewControllerDelegate, UIAdaptivePresentationControllerDelegate {
        var isPresented: Binding<Bool>
        var selection: Binding<[Backport<Any>.PhotosPickerItem]>
        var configuration: PHPickerConfiguration

        lazy var controller: PHPickerViewController = {
            let controller = PHPickerViewController(configuration: configuration)
            controller.presentationController?.delegate = self
            controller.delegate = self
            return controller
        }()

        init(isPresented: Binding<Bool>, selection: Binding<[Backport<Any>.PhotosPickerItem]>, configuration: PHPickerConfiguration) {
            self.isPresented = isPresented
            self.selection = selection
            self.configuration = configuration
            super.init()
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            isPresented.wrappedValue = false
        }

        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            isPresented.wrappedValue = false
        }
    }
}

@available(iOS 13, *)
private struct LegacyPhotosViewController: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selection: [Backport<Any>.PhotosPickerItem]
    let filter: Backport<Any>.PHPickerFilter?
    var preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy

    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented, selection: $selection, filter: filter, preferredItemEncoding: preferredItemEncoding)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        context.coordinator.controller
    }


    func updateUIViewController(_ controller: UIViewController, context: Context) {
        context.coordinator.isPresented = $isPresented
        context.coordinator.selection = $selection
        context.coordinator.filter = filter
        context.coordinator.preferredItemEncoding = preferredItemEncoding
    }
}

private extension LegacyPhotosViewController {
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAdaptivePresentationControllerDelegate {
        var isPresented: Binding<Bool>
        var selection: Binding<[Backport<Any>.PhotosPickerItem]>
        var filter: Backport<Any>.PHPickerFilter?
        var preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy

        lazy var controller: UIImagePickerController = {
            let controller = UIImagePickerController()

            if let filter {
                controller.mediaTypes = filter.mediaTypes.map { String($0) }
            } else if let types = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                controller.mediaTypes = types
            }

            controller.allowsEditing = false
            controller.sourceType = .photoLibrary
            controller.videoQuality = .typeHigh
            controller.presentationController?.delegate = self
            controller.delegate = self

            switch preferredItemEncoding {
            case .compatible:
                controller.imageExportPreset = .compatible
                controller.videoExportPreset = AVAssetExportPresetHighestQuality
            case .current:
                controller.imageExportPreset = .current
                controller.videoExportPreset = AVAssetExportPresetPassthrough
            default:
                controller.imageExportPreset = .compatible
                controller.videoExportPreset = AVAssetExportPresetHEVCHighestQuality
            }

            return controller
        }()

        init(isPresented: Binding<Bool>, selection: Binding<[Backport<Any>.PhotosPickerItem]>, filter: Backport<Any>.PHPickerFilter?, preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy) {
            self.isPresented = isPresented
            self.selection = selection
            self.filter = filter
            self.preferredItemEncoding = preferredItemEncoding
            super.init()
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            isPresented.wrappedValue = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isPresented.wrappedValue = false
        }
    }
}
#endif
