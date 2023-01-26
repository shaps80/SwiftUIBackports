#if os(iOS)

import SwiftUI
import PhotosUI

@available(iOS, introduced: 15, deprecated: 16)
public extension Backport where Wrapped == Any {
    // Available when SwiftUI is imported with PhotosUI
    /// A value that determines how the Photos picker handles user selection.
    struct PhotosPickerSelectionBehavior : Equatable, Hashable {
        internal let rawValue: PHPickerConfiguration.Selection

        /// Uses the default selection behavior.
        public static let `default`: Self = .init(rawValue: .default)

        /// Uses the selection order made by the user. Selected items are numbered.
        public static let ordered: Self = .init(rawValue: .ordered)
    }
}

#endif
