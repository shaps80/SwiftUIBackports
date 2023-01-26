//import SwiftUI
//import UniformTypeIdentifiers
//
//// Available when SwiftUI is imported with PhotosUI
///// A control that allows a user to choose photos and/or videos from the photo library.
/////
///// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
//@available(tvOS, unavailable)
//public struct PhotosPicker<Label> : View where Label : View {
//
//    /// Creates a Photos picker that selects a `PhotosPickerItem`.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - selection: The item being shown and selected in the Photos picker.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of the selected item. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    ///     - label: The view that describes the action of choosing an item from the photo library.
//    public init(selection: Binding<PhotosPickerItem?>, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic, @ViewBuilder label: () -> Label)
//
//    /// Creates a Photos picker that selects a collection of `PhotosPickerItem`.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - selection: All items being shown and selected in the Photos picker.
//    ///     - maxSelectionCount: The maximum number of items that can be selected. Default is `nil`. Setting it to `nil` means maximum supported by the system.
//    ///     - selectionBehavior: The selection behavior of the Photos picker. Default is `.default`.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of selected items. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    ///     - label: The view that describes the action of choosing items from the photo library.
//    public init(selection: Binding<[PhotosPickerItem]>, maxSelectionCount: Int? = nil, selectionBehavior: PhotosPickerSelectionBehavior = .default, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic, @ViewBuilder label: () -> Label)
//
//    /// Creates a Photos picker that selects a `PhotosPickerItem` from a given photo library.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - selection: The item being shown and selected in the Photos picker.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of the selected item. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    ///     - photoLibrary: The photo library to choose from.
//    ///     - label: The view that describes the action of choosing an item from the photo library.
//    @available(watchOS, unavailable)
//    public init(selection: Binding<PhotosPickerItem?>, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic, photoLibrary: PHPhotoLibrary, @ViewBuilder label: () -> Label)
//
//    /// Creates a Photos picker that selects a collection of `PhotosPickerItem` from a given photo library.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - selection: All items being shown and selected in the Photos picker.
//    ///     - maxSelectionCount: The maximum number of items that can be selected. Default is `nil`. Setting it to `nil` means maximum supported by the system.
//    ///     - selectionBehavior: The selection behavior of the Photos picker. Default is `.default`.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of selected items. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    ///     - photoLibrary: The photo library to choose from.
//    ///     - label: The view that describes the action of choosing items from the photo library.
//    @available(watchOS, unavailable)
//    public init(selection: Binding<[PhotosPickerItem]>, maxSelectionCount: Int? = nil, selectionBehavior: PhotosPickerSelectionBehavior = .default, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic, photoLibrary: PHPhotoLibrary, @ViewBuilder label: () -> Label)
//
//    /// The content and behavior of the view.
//    ///
//    /// When you implement a custom view, you must implement a computed
//    /// `body` property to provide the content for your view. Return a view
//    /// that's composed of built-in views that SwiftUI provides, plus other
//    /// composite views that you've already defined:
//    ///
//    ///     struct MyView: View {
//    ///         var body: some View {
//    ///             Text("Hello, World!")
//    ///         }
//    ///     }
//    ///
//    /// For more information about composing views and a view hierarchy,
//    /// see <doc:Declaring-a-Custom-View>.
//    @MainActor public var body: some View { get }
//
//    /// The type of view representing the body of this view.
//    ///
//    /// When you create a custom view, Swift infers this type from your
//    /// implementation of the required ``View/body-swift.property`` property.
//    public typealias Body = some View
//}
//
//// Available when SwiftUI is imported with PhotosUI
//@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
//@available(tvOS, unavailable)
//extension PhotosPicker where Label == Text {
//
//    /// Creates a Photos picker with its label generated from a localized string key that selects a `PhotosPickerItem`.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - titleKey: A localized string key that describes the purpose of showing the picker.
//    ///     - selection: The item being shown and selected in the Photos picker.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of the selected item. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    public init(_ titleKey: LocalizedStringKey, selection: Binding<PhotosPickerItem?>, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic)
//
//    /// Creates a Photos picker with its label generated from a string that selects a `PhotosPickerItem`.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - title: A string that describes the purpose of showing the picker.
//    ///     - selection: The item being shown and selected in the Photos picker.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of the selected item. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    public init<S>(_ title: S, selection: Binding<PhotosPickerItem?>, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic) where S : StringProtocol
//
//    /// Creates a Photos picker with its label generated from a localized string key that selects a collection of `PhotosPickerItem`.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - titleKey: A localized string key that describes the purpose of showing the picker.
//    ///     - selection: All items being shown and selected in the Photos picker.
//    ///     - maxSelectionCount: The maximum number of items that can be selected. Default is `nil`. Setting it to `nil` means maximum supported by the system.
//    ///     - selectionBehavior: The selection behavior of the Photos picker. Default is `.default`.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of selected items. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    public init(_ titleKey: LocalizedStringKey, selection: Binding<[PhotosPickerItem]>, maxSelectionCount: Int? = nil, selectionBehavior: PhotosPickerSelectionBehavior = .default, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic)
//
//    /// Creates a Photos picker with its label generated from a string that selects a collection of `PhotosPickerItem`.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - title: A string that describes the purpose of showing the picker.
//    ///     - selection: All items being shown and selected in the Photos picker.
//    ///     - maxSelectionCount: The maximum number of items that can be selected. Default is `nil`. Setting it to `nil` means maximum supported by the system.
//    ///     - selectionBehavior: The selection behavior of the Photos picker. Default is `.default`.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of selected items. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    public init<S>(_ title: S, selection: Binding<[PhotosPickerItem]>, maxSelectionCount: Int? = nil, selectionBehavior: PhotosPickerSelectionBehavior = .default, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic) where S : StringProtocol
//
//    /// Creates a Photos picker with its label generated from a localized string key that selects a `PhotosPickerItem` from a given photo library.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - titleKey: A localized string key that describes the purpose of showing the picker.
//    ///     - selection: The item being shown and selected in the Photos picker.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of the selected item. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    ///     - photoLibrary: The photo library to choose from.
//    @available(watchOS, unavailable)
//    public init(_ titleKey: LocalizedStringKey, selection: Binding<PhotosPickerItem?>, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic, photoLibrary: PHPhotoLibrary)
//
//    /// Creates a Photos picker with its label generated from a string that selects a `PhotosPickerItem` from a given photo library.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - title: A string that describes the purpose of showing the picker.
//    ///     - selection: The item being shown and selected in the Photos picker.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of the selected item. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    ///     - photoLibrary: The photo library to choose from.
//    @available(watchOS, unavailable)
//    public init<S>(_ title: S, selection: Binding<PhotosPickerItem?>, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic, photoLibrary: PHPhotoLibrary) where S : StringProtocol
//
//    /// Creates a Photos picker with its label generated from a localized string key that selects a collection of `PhotosPickerItem` from a given photo library.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - titleKey: A localized string key that describes the purpose of showing the picker.
//    ///     - selection: All items being shown and selected in the Photos picker.
//    ///     - maxSelectionCount: The maximum number of items that can be selected. Default is `nil`. Setting it to `nil` means maximum supported by the system.
//    ///     - selectionBehavior: The selection behavior of the Photos picker. Default is `.default`.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of selected items. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    ///     - photoLibrary: The photo library to choose from.
//    @available(watchOS, unavailable)
//    public init(_ titleKey: LocalizedStringKey, selection: Binding<[PhotosPickerItem]>, maxSelectionCount: Int? = nil, selectionBehavior: PhotosPickerSelectionBehavior = .default, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic, photoLibrary: PHPhotoLibrary)
//
//    /// Creates a Photos picker with its label generated from a string that selects a collection of `PhotosPickerItem` from a given photo library.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - title: A string that describes the purpose of showing the picker.
//    ///     - selection: All items being shown and selected in the Photos picker.
//    ///     - maxSelectionCount: The maximum number of items that can be selected. Default is `nil`. Setting it to `nil` means maximum supported by the system.
//    ///     - selectionBehavior: The selection behavior of the Photos picker. Default is `.default`.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of selected items. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    ///     - photoLibrary: The photo library to choose from.
//    @available(watchOS, unavailable)
//    public init<S>(_ title: S, selection: Binding<[PhotosPickerItem]>, maxSelectionCount: Int? = nil, selectionBehavior: PhotosPickerSelectionBehavior = .default, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic, photoLibrary: PHPhotoLibrary) where S : StringProtocol
//}
//
//// Available when SwiftUI is imported with PhotosUI
///// An item that can be provided to or provided by the Photos picker.
/////
///// An item can contain multiple representations. Each representation has a corresponding content type.
//@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
//@available(tvOS, unavailable)
//public struct PhotosPickerItem : Equatable, Hashable {
//
//    /// A policy that decides the encoding to use given a content type, if multiple encodings are available.
//    public struct EncodingDisambiguationPolicy : Equatable, Hashable {
//
//        /// Uses the best encoding determined by the system. This may change in future releases.
//        public static let automatic: PhotosPickerItem.EncodingDisambiguationPolicy
//
//        /// Uses the current encoding to avoid transcoding if possible.
//        public static let current: PhotosPickerItem.EncodingDisambiguationPolicy
//
//        /// Uses the most compatible encoding if possible, even if transcoding is required.
//        public static let compatible: PhotosPickerItem.EncodingDisambiguationPolicy
//
//        /// Returns a Boolean value indicating whether two values are equal.
//        ///
//        /// Equality is the inverse of inequality. For any values `a` and `b`,
//        /// `a == b` implies that `a != b` is `false`.
//        ///
//        /// - Parameters:
//        ///   - lhs: A value to compare.
//        ///   - rhs: Another value to compare.
//        public static func == (a: PhotosPickerItem.EncodingDisambiguationPolicy, b: PhotosPickerItem.EncodingDisambiguationPolicy) -> Bool
//
//        /// Hashes the essential components of this value by feeding them into the
//        /// given hasher.
//        ///
//        /// Implement this method to conform to the `Hashable` protocol. The
//        /// components used for hashing must be the same as the components compared
//        /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
//        /// with each of these components.
//        ///
//        /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
//        ///   compile-time error in the future.
//        ///
//        /// - Parameter hasher: The hasher to use when combining the components
//        ///   of this instance.
//        public func hash(into hasher: inout Hasher)
//
//        /// The hash value.
//        ///
//        /// Hash values are not guaranteed to be equal across different executions of
//        /// your program. Do not save hash values to use during a future execution.
//        ///
//        /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
//        ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
//        public var hashValue: Int { get }
//    }
//
//    /// The local identifier of the item. It will be `nil` if the Photos picker is created without a photo library.
//    @available(watchOS, unavailable)
//    public var itemIdentifier: String? { get }
//
//    /// All supported content types of the item, in order of most preferred to least preferred.
//    public var supportedContentTypes: [UTType] { get }
//
//    /// Loads a `Transferable` object using a representation of the item by matching content types.
//    ///
//    /// The representation corresponding to the first matching content type of the item will be used.
//    /// If multiple encodings are available for the matched content type, the preferred item encoding provided to the Photos picker decides which encoding to use.
//    /// An error will be returned if the `Transferable` object doesn't support any of the supported content types of the item.
//    ///
//    /// - Parameters:
//    ///     - type: The actual type of the `Transferable` object.
//    ///     - completionHandler: The closure to be called when the `Transferable` object is loaded (`nil` if no supported content type is found) or an error is encountered.
//    public func loadTransferable<T>(type: T.Type, completionHandler: @escaping (Result<T?, Error>) -> Void) -> Progress where T : Transferable
//
//    /// Loads a `Transferable` object using a representation of the item by matching content types.
//    ///
//    /// The representation corresponding to the first matching content type of the item will be used.
//    /// If multiple encodings are available for the matched content type, the preferred item encoding provided to the Photos picker decides which encoding to use.
//    /// An error will be thrown if the `Transferable` object doesn't support any of the supported content types of the item.
//    ///
//    /// - Parameters:
//    ///     - type: The actual type of the `Transferable` object.
//    /// - Throws: The encountered error while loading the `Transferable` object.
//    /// - Returns: The loaded `Transferable` object, or `nil` if no supported content type is found.
//    public func loadTransferable<T>(type: T.Type) async throws -> T? where T : Transferable
//
//    /// Creates an item without any representation using an identifier.
//    ///
//    /// - Parameters:
//    ///     - itemIdentifier: The local identifier of the item.
//    @available(watchOS, unavailable)
//    public init(itemIdentifier: String)
//
//    /// Returns a Boolean value indicating whether two values are equal.
//    ///
//    /// Equality is the inverse of inequality. For any values `a` and `b`,
//    /// `a == b` implies that `a != b` is `false`.
//    ///
//    /// - Parameters:
//    ///   - lhs: A value to compare.
//    ///   - rhs: Another value to compare.
//    public static func == (a: PhotosPickerItem, b: PhotosPickerItem) -> Bool
//
//    /// Hashes the essential components of this value by feeding them into the
//    /// given hasher.
//    ///
//    /// Implement this method to conform to the `Hashable` protocol. The
//    /// components used for hashing must be the same as the components compared
//    /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
//    /// with each of these components.
//    ///
//    /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
//    ///   compile-time error in the future.
//    ///
//    /// - Parameter hasher: The hasher to use when combining the components
//    ///   of this instance.
//    public func hash(into hasher: inout Hasher)
//
//    /// The hash value.
//    ///
//    /// Hash values are not guaranteed to be equal across different executions of
//    /// your program. Do not save hash values to use during a future execution.
//    ///
//    /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
//    ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
//    public var hashValue: Int { get }
//}
//
//// Available when SwiftUI is imported with PhotosUI
///// A value that determines how the Photos picker handles user selection.
//@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
//@available(tvOS, unavailable)
//public struct PhotosPickerSelectionBehavior : Equatable, Hashable {
//
//    /// Uses the default selection behavior.
//    public static let `default`: PhotosPickerSelectionBehavior
//
//    /// Uses the selection order made by the user. Selected items are numbered.
//    public static let ordered: PhotosPickerSelectionBehavior
//
//    /// Returns a Boolean value indicating whether two values are equal.
//    ///
//    /// Equality is the inverse of inequality. For any values `a` and `b`,
//    /// `a == b` implies that `a != b` is `false`.
//    ///
//    /// - Parameters:
//    ///   - lhs: A value to compare.
//    ///   - rhs: Another value to compare.
//    public static func == (a: PhotosPickerSelectionBehavior, b: PhotosPickerSelectionBehavior) -> Bool
//
//    /// Hashes the essential components of this value by feeding them into the
//    /// given hasher.
//    ///
//    /// Implement this method to conform to the `Hashable` protocol. The
//    /// components used for hashing must be the same as the components compared
//    /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
//    /// with each of these components.
//    ///
//    /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
//    ///   compile-time error in the future.
//    ///
//    /// - Parameter hasher: The hasher to use when combining the components
//    ///   of this instance.
//    public func hash(into hasher: inout Hasher)
//
//    /// The hash value.
//    ///
//    /// Hash values are not guaranteed to be equal across different executions of
//    /// your program. Do not save hash values to use during a future execution.
//    ///
//    /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
//    ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
//    public var hashValue: Int { get }
//}
//
//// Available when SwiftUI is imported with PhotosUI
//@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
//@available(tvOS, unavailable)
//extension View {
//
//    /// Presents a Photos picker that selects a `PhotosPickerItem`.
//    ///
//    /// The user explicitly grants access only to items they choose, so photo library access authorization is not needed.
//    ///
//    /// - Parameters:
//    ///     - isPresented: The binding to whether the Photos picker should be shown.
//    ///     - selection: The item being shown and selected in the Photos picker.
//    ///     - filter: Types of items that can be shown. Default is `nil`. Setting it to `nil` means all supported types can be shown.
//    ///     - preferredItemEncoding: The encoding disambiguation policy of the selected item. Default is `.automatic`. Setting it to `.automatic` means the best encoding determined by the system will be used.
//    public func photosPicker(isPresented: Binding<Bool>, selection: Binding<PhotosPickerItem?>, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic) -> some View
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
//    public func photosPicker(isPresented: Binding<Bool>, selection: Binding<[PhotosPickerItem]>, maxSelectionCount: Int? = nil, selectionBehavior: PhotosPickerSelectionBehavior = .default, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic) -> some View
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
//    @available(watchOS, unavailable)
//    public func photosPicker(isPresented: Binding<Bool>, selection: Binding<PhotosPickerItem?>, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic, photoLibrary: PHPhotoLibrary) -> some View
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
//    @available(watchOS, unavailable)
//    public func photosPicker(isPresented: Binding<Bool>, selection: Binding<[PhotosPickerItem]>, maxSelectionCount: Int? = nil, selectionBehavior: PhotosPickerSelectionBehavior = .default, matching filter: PHPickerFilter? = nil, preferredItemEncoding: PhotosPickerItem.EncodingDisambiguationPolicy = .automatic, photoLibrary: PHPhotoLibrary) -> some View
//
//}
