#if os(iOS)
import SwiftUI
import PhotosUI

@available(iOS, deprecated: 16)
public extension Backport where Wrapped == Any {
    /// An item can contain multiple representations. Each representation has a corresponding content type.
    struct PhotosPickerItem: Equatable, Hashable {
        /// A policy that decides the encoding to use given a content type, if multiple encodings are available.
        public struct EncodingDisambiguationPolicy: Equatable, Hashable {
            internal let rawValue: UInt8

            /// Uses the best encoding determined by the system. This may change in future releases.
            public static let automatic: Self = .init(rawValue: 0)

            /// Uses the current encoding to avoid transcoding if possible.
            public static let current: Self = .init(rawValue: 1)

            /// Uses the most compatible encoding if possible, even if transcoding is required.
            public static let compatible: Self = .init(rawValue: 2)

            @available(iOS, introduced: 14)
            public var mode: PHPickerConfiguration.AssetRepresentationMode {
                switch self {
                case .automatic: return .automatic
                case .current: return .current
                case .compatible: return .compatible
                default: return .automatic
                }
            }
        }

        /// The local identifier of the item. It will be `nil` if the Photos picker is created without a photo library.
        public let itemIdentifier: String?

        /// All supported content types of the item, in order of most preferred to least preferred.
        public let supportedContentTypes: [String]

        /// Creates an item without any representation using an identifier.
        ///
        /// - Parameters:
        ///     - itemIdentifier: The local identifier of the item.
        public init(itemIdentifier: String) {
            self.itemIdentifier = itemIdentifier
            supportedContentTypes = []
        }

        /// Loads an object using a representation of the item by matching content types.
        ///
        /// The representation corresponding to the first matching content type of the item will be used.
        /// If multiple encodings are available for the matched content type, the preferred item encoding provided to the Photos picker decides which encoding to use.
        /// An error will be thrown if the object doesn't support any of the supported content types of the item.
        ///
        /// - Parameters:
        ///     - type: The actual type of the object.
        /// - Throws: The encountered error while loading the object.
        /// - Returns: The loaded object, or `nil` if no supported content type is found.
        ///
        /// - Note: Supported types are `Data`, `UIImage` or `Image` exclusively. Attempting to pass any other value here will result in an error.
        public func loadTransferable<T>(type: T.Type) async throws -> T? {
            switch type {
            case is Image.Type:
                fatalError()
            case is UIImage.Type:
                fatalError()
            case is Data.Type:
                fatalError()
            default:
                throw PhotoError<T>()
            }
        }

        private struct PhotoError<T>: LocalizedError {
            var errorDescription: String? {
                "Could not load photo as \(T.self)"
            }
        }
    }
}
#endif
