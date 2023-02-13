#if os(iOS)
import SwiftUI
import PhotosUI
import SwiftBackports

@available(iOS, deprecated: 16)
public extension Backport where Wrapped == Any {
    // Available when SwiftUI is imported with PhotosUI
    /// A value that determines how the Photos picker handles user selection.
    enum PhotosPickerSelectionBehavior: Equatable, Hashable {
        /// Uses the default selection behavior.
        case `default`
        /// Uses the selection order made by the user. Selected items are numbered.
        case ordered

        @available(iOS 15, *)
        init(behaviour: PHPickerConfiguration.Selection) {
            switch behaviour {
            case .`default`: self = .`default`
            case .ordered: self = .ordered
            default: self = .`default`
            }
        }

        @available(iOS 15, *)
        var behaviour: PHPickerConfiguration.Selection {
            switch self {
            case .ordered: return .ordered
            default: return .`default`
            }
        }
    }
}
#endif
