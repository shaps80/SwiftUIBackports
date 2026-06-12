import SwiftUI
import SwiftBackports

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DropConfiguration instead")
@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropConfiguration instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DropConfiguration instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public extension Backport<Any> {
    /// A drop configuration.
    struct DropConfiguration {
        /// The operation to perform for the drop.
        public private(set) var operation: Backport<Any>.DropOperation

        #if os(macOS)
        /// The number of items accepted by the drop target.
        @available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropConfiguration.acceptedItemCount instead")
        @available(iOS, unavailable)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
        @available(visionOS, unavailable)
        public var acceptedItemCount: Int?
        #endif

        /// Creates a drop configuration.
        ///
        /// - Parameter operation: The operation to perform for the drop.
        public init(operation: Backport<Any>.DropOperation) {
            self.operation = operation
            #if os(macOS)
            self.acceptedItemCount = nil
            #endif
        }
    }
}
