#if os(iOS)

import SwiftUI
import PhotosUI

@available(iOS, introduced: 13, deprecated: 16)
public extension Backport where Wrapped == Any {
    // Available when SwiftUI is imported with PhotosUI
    /// A control that allows a user to choose photos and/or videos from the photo library.
    ///
    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
    struct PhotosPicker<Label>: View where Label: View {
        @State private var showPicker: Bool = false
        private let label: Label

        public var body: some View {
            Button {
                showPicker = true
            } label: {
                label
            }
            .sheet(isPresented: $showPicker) {
                Text("Photo picker")
            }
        }
    }
}

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
        self.label = label()
    }
}

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
        self.label = Text(title)
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
    public init(
        selection: Binding<[Backport<Any>.PhotosPickerItem]>,
        maxSelectionCount: Int? = nil,
        selectionBehavior: Backport<Any>.PhotosPickerSelectionBehavior = .default,
        matching filter: Backport<Any>.PHPickerFilter? = nil,
        preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy = .automatic,
        photoLibrary: PHPhotoLibrary = .shared(),
        @ViewBuilder label: () -> Label
    ) {
        self.label = label()
    }
}

extension Backport.PhotosPicker where Wrapped == Any, Label == Text {
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
    public init<S>(
        _ title: S,
        selection: Binding<Backport<Any>.PhotosPickerItem?>,
        maxSelectionCount: Int? = nil,
        matching filter: Backport<Any>.PHPickerFilter? = nil,
        preferredItemEncoding: Backport<Any>.PhotosPickerItem.EncodingDisambiguationPolicy = .automatic,
        photoLibrary: PHPhotoLibrary = .shared()
    ) where S: StringProtocol {
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
        self.label = Text(title)
    }
}

#endif
