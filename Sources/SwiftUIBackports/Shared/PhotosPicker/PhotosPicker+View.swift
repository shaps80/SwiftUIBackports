#if os(iOS)
import SwiftUI
import PhotosUI

@available(iOS, deprecated: 16.0)
public extension Backport where Wrapped: View {
    /// Presents a Photos picker that selects a `PhotosPickerItem` from a given photo library.
    ///
    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
    ///
    /// - Parameters:
    ///     - isPresented: The binding to whether the Photos picker should be shown.
    ///     - selection: The item being shown and selected in the Photos picker.
    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
    ///     - preferredItemEncoding: The encoding disambiguation policy of the selected item. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
    ///     - photoLibrary: The photo library to choose from.
    func photosPicker(
        isPresented: Binding<Bool>,
        selection: Binding<Backport<Any>.PhotosPickerItem?>,
        matching filter: Backport<Any>.PHPickerFilter? = nil,
        preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy = .automatic,
        photoLibrary: PHPhotoLibrary = .shared()
    ) -> some View {
        let binding = Binding(
            get: {
                [selection.wrappedValue].compactMap { $0 }
            },
            set: { newValue in
                selection.wrappedValue = newValue.first
            }
        )

        return content.sheet(isPresented: isPresented) {
            PhotosPickerView(
                selection: binding,
                filter: filter,
                maxSelection: 1,
                selectionBehavior: .default,
                encoding: preferredItemEncoding,
                library: photoLibrary
            )
        }
    }


    /// Presents a Photos picker that selects a collection of `PhotosPickerItem` from a given photo library.
    ///
    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
    ///
    /// - Parameters:
    ///     - isPresented: The binding to whether the Photos picker should be shown.
    ///     - selection: All items being shown and selected in the Photos picker.
    ///     - maxSelectionCount: The maximum number of items that can be selected. Default is `nil`. Setting it to `nil` means maximum supported by the system.
    ///     - selectionBehavior: The selection behavior of the Photos picker. Default is `.default`.
    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
    ///     - preferredItemEncoding: The encoding disambiguation policy of selected items. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
    ///     - photoLibrary: The photo library to choose from.
    func photosPicker(
        isPresented: Binding<Bool>,
        selection: Binding<[Backport<Any>.PhotosPickerItem]>,
        maxSelectionCount: Int? = nil,
        selectionBehavior: Backport<Any>.PhotosPickerSelectionBehavior = .default,
        matching filter: Backport<Any>.PHPickerFilter? = nil,
        preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy = .automatic,
        photoLibrary: PHPhotoLibrary = .shared()
    ) -> some View {
        content.sheet(isPresented: isPresented) {
            PhotosPickerView(
                selection: selection,
                filter: filter,
                maxSelection: maxSelectionCount,
                selectionBehavior: selectionBehavior,
                encoding: preferredItemEncoding,
                library: photoLibrary
            )
        }
    }
}

#endif
