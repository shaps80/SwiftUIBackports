#if os(iOS)
import SwiftUI
import PhotosUI

@available(iOS, introduced: 14, deprecated: 16.0)
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

        return photosPicker(
            isPresented: isPresented,
            selection: binding,
            matching: filter,
            preferredItemEncoding: preferredItemEncoding,
            photoLibrary: photoLibrary
        )
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
        wrapped._photoPicker(
            isPresented: isPresented,
            selection: selection,
            filter: filter,
            maxSelectionCount: maxSelectionCount,
            selectionBehavior: selectionBehavior,
            preferredItemEncoding: preferredItemEncoding,
            library: photoLibrary
        )
    }
}

@available(iOS, introduced: 13, deprecated: 14.0)
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
    func photosPicker(
        isPresented: Binding<Bool>,
        selection: Binding<Backport<Any>.PhotosPickerItem?>,
        matching filter: Backport<Any>.PHPickerFilter? = nil,
        preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy = .automatic
    ) -> some View {
        let binding = Binding(
            get: {
                [selection.wrappedValue].compactMap { $0 }
            },
            set: { newValue in
                selection.wrappedValue = newValue.first
            }
        )

        return wrapped._photoPicker(
            isPresented: isPresented,
            selection: binding,
            filter: nil,
            maxSelectionCount: 1,
            selectionBehavior: .default,
            preferredItemEncoding: preferredItemEncoding,
            library: .shared()
        )
    }


    /// Presents a Photos picker that selects a collection of `PhotosPickerItem` from a given photo library.
    ///
    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
    ///
    /// - Parameters:
    ///     - isPresented: The binding to whether the Photos picker should be shown.
    ///     - selection: All items being shown and selected in the Photos picker.
    ///     - maxSelectionCount: The maximum number of items that can be selected. Default is `nil`. Setting it to `nil` means maximum supported by the system.
    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
    ///     - preferredItemEncoding: The encoding disambiguation policy of selected items. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
    func photosPicker(
        isPresented: Binding<Bool>,
        selection: Binding<[Backport<Any>.PhotosPickerItem]>,
        maxSelectionCount: Int? = nil,
        matching filter: Backport<Any>.PHPickerFilter? = nil,
        preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy = .automatic
    ) -> some View {
        wrapped._photoPicker(
            isPresented: isPresented,
            selection: selection,
            filter: filter,
            maxSelectionCount: maxSelectionCount,
            selectionBehavior: .default,
            preferredItemEncoding: preferredItemEncoding,
            library: .shared()
        )
    }
}

#endif
