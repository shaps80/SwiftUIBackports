#if os(iOS)
import SwiftUI
import PhotosUI

@available(iOS, introduced: 14, deprecated: 16)
public extension Backport where Wrapped == Any {
    // Available when SwiftUI is imported with PhotosUI
    /// A control that allows a user to choose photos and/or videos from the photo library.
    ///
    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
    struct PhotosPicker<Label>: View where Label: View {
        @State private var isPresented: Bool = false
        @Binding var selection: [Backport<Any>.PhotosPickerItem]

        private let filter: Backport<Any>.PHPickerFilter?
        private let maxSelection: Int?
        private let selectionBehavior: Backport<Any>.PhotosPickerSelectionBehavior
        private let encoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy
        private let library: PHPh otoLibrary
        private let label: Label

        public var body: some View {
            Button {
                isPresented = true
            } label: {
                label
            }
            ._photoPicker(
                isPresented: $isPresented,
                selection: $selection,
                filter: filter,
                maxSelectionCount: maxSelection,
                selectionBehavior: selectionBehavior,
                preferredItemEncoding: encoding,
                library: library
            )
        }
    }
}

@available(iOS 14, *)
public extension Backport.PhotosPicker where Wrapped == Any {
    /// Creates a Photos picker that selects a `PhotosPickerItem` from a given photo library.
    ///
    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
    ///
    /// - Parameters:
    ///     - selection: The item being shown and selected in the Photos picker.
    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
    ///     - preferredItemEncoding: The encoding disambiguation policy of the selected item. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
    ///     - photoLibrary: The photo library to choose from.
    ///     - label: The view that describes the action of choosing an item from the photo library.
    init(
        selection: Binding<Backport<Any>.PhotosPickerItem?>,
        maxSelectionCount: Int? = nil,
        matching filter: Backport<Any>.PHPickerFilter? = nil,
        preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy = .automatic,
        photoLibrary: PHPhotoLibrary = .shared(),
        @ViewBuilder label: () -> Label
    ) {
        _selection = .init(
            get: {
                [selection.wrappedValue].compactMap { $0 }
            },
            set: { newValue in
                selection.wrappedValue = newValue.first
            }
        )
        self.filter = filter
        self.maxSelection = maxSelectionCount
        self.selectionBehavior = .default
        self.encoding = preferredItemEncoding
        self.library = photoLibrary
        self.label = label()
    }
}

@available(iOS 14, *)
public extension Backport.PhotosPicker where Wrapped == Any, Label == Text {
    /// Creates a Photos picker with its label generated from a localized string key that selects a `PhotosPickerItem`.
    ///
    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
    ///
    /// - Parameters:
    ///     - titleKey: A localized string key that describes the purpose of showing the picker.
    ///     - selection: The item being shown and selected in the Photos picker.
    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
    ///     - preferredItemEncoding: The encoding disambiguation policy of the selected item. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
    init(
        _ title: String,
        selection: Binding<Backport<Any>.PhotosPickerItem?>,
        maxSelectionCount: Int? = nil,
        matching filter: Backport<Any>.PHPickerFilter? = nil,
        preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy = .automatic,
        photoLibrary: PHPhotoLibrary = .shared()
    ) {
        _selection = .init(
            get: {
                [selection.wrappedValue].compactMap { $0 }
            },
            set: { newValue in
                selection.wrappedValue = newValue.first
            }
        )
        self.filter = filter
        self.maxSelection = maxSelectionCount
        self.selectionBehavior = .default
        self.encoding = preferredItemEncoding
        self.library = photoLibrary
        label = Text(title)
    }
}

@available(iOS 15, *)
public extension Backport.PhotosPicker where Wrapped == Any {
    /// Creates a Photos picker that selects a collection of `PhotosPickerItem` from a given photo library.
    ///
    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
    ///
    /// - Parameters:
    ///     - selection: All items being shown and selected in the Photos picker.
    ///     - maxSelectionCount: The maximum number of items that can be selected. Default is `nil`. Setting it to `nil` means maximum supported by the system.
    ///     - selectionBehavior: The selection behavior of the Photos picker. Default is `.default`.
    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
    ///     - preferredItemEncoding: The encoding disambiguation policy of selected items. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
    ///     - photoLibrary: The photo library to choose from.
    ///     - label: The view that describes the action of choosing items from the photo library.
    init(
        selection: Binding<[Backport<Any>.PhotosPickerItem]>,
        maxSelectionCount: Int? = nil,
        selectionBehavior: Backport<Any>.PhotosPickerSelectionBehavior = .default,
        matching filter: Backport<Any>.PHPickerFilter? = nil,
        preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy = .automatic,
        photoLibrary: PHPhotoLibrary = .shared(),
        @ViewBuilder label: () -> Label
    ) {
        _selection = selection
        self.filter = filter
        self.maxSelection = maxSelectionCount
        self.selectionBehavior = selectionBehavior
        self.encoding = preferredItemEncoding
        self.library = photoLibrary
        self.label = label()
    }
}

@available(iOS 14, *)
public extension Backport.PhotosPicker where Wrapped == Any, Label == Text {
    /// Creates a Photos picker with its label generated from a string that selects a `PhotosPickerItem` from a given photo library.
    ///
    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
    ///
    /// - Parameters:
    ///     - title: A string that describes the purpose of showing the picker.
    ///     - selection: The item being shown and selected in the Photos picker.
    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
    ///     - preferredItemEncoding: The encoding disambiguation policy of the selected item. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
    ///     - photoLibrary: The photo library to choose from.
    init<S>(
        _ title: S,
        selection: Binding<Backport<Any>.PhotosPickerItem?>,
        maxSelectionCount: Int? = nil,
        matching filter: Backport<Any>.PHPickerFilter? = nil,
        preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy = .automatic,
        photoLibrary: PHPhotoLibrary = .shared()
    ) where S: StringProtocol {
        _selection = .init(
            get: {
                [selection.wrappedValue].compactMap { $0 }
            },
            set: { newValue in
                selection.wrappedValue = newValue.first
            }
        )
        self.filter = filter
        self.maxSelection = maxSelectionCount
        self.selectionBehavior = .default
        self.encoding = preferredItemEncoding
        self.library = photoLibrary
        self.label = Text(title)
    }
}

@available(iOS 15, *)
public extension Backport.PhotosPicker where Wrapped == Any, Label == Text {
    /// Creates a Photos picker with its label generated from a string that selects a collection of `PhotosPickerItem` from a given photo library.
    ///
    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
    ///
    /// - Parameters:
    ///     - title: A string that describes the purpose of showing the picker.
    ///     - selection: All items being shown and selected in the Photos picker.
    ///     - maxSelectionCount: The maximum number of items that can be selected. Default is `nil`. Setting it to `nil` means maximum supported by the system.
    ///     - selectionBehavior: The selection behavior of the Photos picker. Default is `.default`.
    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
    ///     - preferredItemEncoding: The encoding disambiguation policy of selected items. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
    ///     - photoLibrary: The photo library to choose from.
    init<S>(
        _ title: S,
        selection: Binding<[Backport<Any>.PhotosPickerItem]>,
        maxSelectionCount: Int? = nil,
        selectionBehavior: Backport<Any>.PhotosPickerSelectionBehavior = .default,
        matching filter: Backport<Any>.PHPickerFilter? = nil,
        preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy = .automatic,
        photoLibrary: PHPhotoLibrary = .shared()
    ) where S: StringProtocol {
        _selection = selection
        self.filter = filter
        self.maxSelection = maxSelectionCount
        self.selectionBehavior = selectionBehavior
        self.encoding = preferredItemEncoding
        self.library = photoLibrary
        self.label = Text(title)
    }
}
#endif
