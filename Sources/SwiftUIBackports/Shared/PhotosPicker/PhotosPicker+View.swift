//#if os(iOS)
//import SwiftUI
//import PhotosUI
//
//@available(iOS, deprecated: 16.0)
//extension Backport where Wrapped: View {
//    /// Presents a Photos picker that selects a `PhotosPickerItem`.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - isPresented: The binding to whether the Photos picker should be shown.
//    ///     - selection: The item being shown and selected in the Photos picker.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of the selected item. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    public func photosPicker(
//        isPresented: Binding<Bool>,
//        selection: Binding<PhotosPickerItem?>,
//        matching filter: PHPickerFilter? = nil,
//        preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic
//    ) -> some View {
//        
//    }
//
//
//    /// Presents a Photos picker that selects a collection of `PhotosPickerItem`.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - isPresented: The binding to whether the Photos picker should be shown.
//    ///     - selection: All items being shown and selected in the Photos picker.
//    ///     - maxSelectionCount: The maximum number of items that can be selected. Default is `nil`. Setting it to `nil` means maximum supported by the system.
//    ///     - selectionBehavior: The selection behavior of the Photos picker. Default is `.default`.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of selected items. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    public func photosPicker(
//        isPresented: Binding<Bool>,
//        selection: Binding<[PhotosPickerItem]>,
//        maxSelectionCount: Int? = nil,
//        selectionBehavior: PhotosPickerSelectionBehavior = .default,
//        matching filter: PHPickerFilter? = nil,
//        preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic
//    ) -> some View {
//
//    }
//
//
//    /// Presents a Photos picker that selects a `PhotosPickerItem` from a given photo library.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - isPresented: The binding to whether the Photos picker should be shown.
//    ///     - selection: The item being shown and selected in the Photos picker.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of the selected item. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    ///     - photoLibrary: The photo library to choose from.
//    public func photosPicker(
//        isPresented: Binding<Bool>,
//        selection: Binding<PhotosPickerItem?>,
//        matching filter: PHPickerFilter? = nil,
//        preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic,
//        photoLibrary: PHPhotoLibrary
//    ) -> some View {
//
//    }
//
//
//    /// Presents a Photos picker that selects a collection of `PhotosPickerItem` from a given photo library.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - isPresented: The binding to whether the Photos picker should be shown.
//    ///     - selection: All items being shown and selected in the Photos picker.
//    ///     - maxSelectionCount: The maximum number of items that can be selected. Default is `nil`. Setting it to `nil` means maximum supported by the system.
//    ///     - selectionBehavior: The selection behavior of the Photos picker. Default is `.default`.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of selected items. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    ///     - photoLibrary: The photo library to choose from.
//    public func photosPicker(
//        isPresented: Binding<Bool>,
//        selection: Binding<[PhotosPickerItem]>,
//        maxSelectionCount: Int? = nil,
//        selectionBehavior: PhotosPickerSelectionBehavior = .default,
//        matching filter: PHPickerFilter? = nil,
//        preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic,
//        photoLibrary: PHPhotoLibrary
//    ) -> some View {
//
//    }
//
//}
//
//#endif
