#if os(iOS)
import SwiftUI
import PhotosUI
import SwiftBackports

@available(iOS, introduced: 13, deprecated: 16)
public extension Backport where Wrapped == Any {
    /// A user selected asset from `PHPickerViewController`.
    struct PHPickerResult: Equatable, Hashable {
        /// Representations of the selected asset.
        public let itemProvider: NSItemProvider

        /// The local identifier of the selected asset.
        public let assetIdentifier: String?

        internal init(assetIdentifier: String?, itemProvider: NSItemProvider) {
            self.assetIdentifier = assetIdentifier
            self.itemProvider = itemProvider
        }
    }
}
#endif
