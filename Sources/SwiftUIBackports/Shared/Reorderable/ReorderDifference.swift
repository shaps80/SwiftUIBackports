import SwiftUI
import SwiftBackports

@available(iOS, deprecated: 27, message: "Use SwiftUI.ReorderableSingleCollectionIdentifier instead")
@available(tvOS, deprecated: 27, message: "Use SwiftUI.ReorderableSingleCollectionIdentifier instead")
@available(macOS, deprecated: 27, message: "Use SwiftUI.ReorderableSingleCollectionIdentifier instead")
@available(watchOS, deprecated: 27, message: "Use SwiftUI.ReorderableSingleCollectionIdentifier instead")
@available(visionOS, deprecated: 27, message: "Use SwiftUI.ReorderableSingleCollectionIdentifier instead")
public extension Backport<Any> {
    /// An identifier for a single collection involved in a reorder operation.
    struct ReorderableSingleCollectionIdentifier: Hashable, Sendable { }
}

@available(iOS, deprecated: 27, message: "Use SwiftUI.ReorderDifference instead")
@available(tvOS, deprecated: 27, message: "Use SwiftUI.ReorderDifference instead")
@available(macOS, deprecated: 27, message: "Use SwiftUI.ReorderDifference instead")
@available(watchOS, deprecated: 27, message: "Use SwiftUI.ReorderDifference instead")
@available(visionOS, deprecated: 27, message: "Use SwiftUI.ReorderDifference instead")
public extension Backport<Any> {
    /// A description of a reorder operation.
    struct ReorderDifference<ItemID, CollectionID> {
        /// The destination of a reorder operation.
        public struct Destination {
            /// A position in the destination collection.
            @frozen public enum Position {
                /// A position before the item with the specified identifier.
                case before(ItemID)

                /// A position at the end of the collection.
                case end
            }

            /// The destination collection identifier.
            public var collectionID: CollectionID

            /// The destination position in the collection.
            public var position: Position

            /// Creates a reorder destination.
            ///
            /// - Parameters:
            ///   - position: The destination position in the collection.
            ///   - collectionID: The destination collection identifier.
            public init(position: Position, collectionID: CollectionID) {
                self.collectionID = collectionID
                self.position = position
            }

            /// Creates a reorder destination in a single collection.
            ///
            /// - Parameter position: The destination position in the collection.
            public init(position: Position) where CollectionID == Backport<Any>.ReorderableSingleCollectionIdentifier {
                self.init(
                    position: position,
                    collectionID: Backport<Any>.ReorderableSingleCollectionIdentifier()
                )
            }
        }

        /// The source item identifiers.
        public var sources: [ItemID]

        /// The reorder destination.
        public var destination: Destination
    }
}

extension Backport<Any>.ReorderDifference.Destination.Position: Equatable where ItemID: Equatable { }
extension Backport<Any>.ReorderDifference.Destination.Position: Hashable where ItemID: Hashable { }
extension Backport<Any>.ReorderDifference.Destination.Position: Sendable where ItemID: Sendable { }

extension Backport<Any>.ReorderDifference.Destination: Equatable where ItemID: Equatable, CollectionID: Equatable { }
extension Backport<Any>.ReorderDifference.Destination: Hashable where ItemID: Hashable, CollectionID: Hashable { }
extension Backport<Any>.ReorderDifference.Destination: Sendable where ItemID: Sendable, CollectionID: Sendable { }

extension Backport<Any>.ReorderDifference: Equatable where ItemID: Equatable, CollectionID: Equatable { }
extension Backport<Any>.ReorderDifference: Hashable where ItemID: Hashable, CollectionID: Hashable { }
extension Backport<Any>.ReorderDifference: Sendable where ItemID: Sendable, CollectionID: Sendable { }
