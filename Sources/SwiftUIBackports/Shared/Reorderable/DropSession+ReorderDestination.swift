import SwiftUI
import SwiftBackports

@available(iOS 26, macOS 26, visionOS 26, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public extension SwiftUI.DropSession {
    /// Wraps a SwiftUI drop session that can be extended to provide backport
    /// functionality.
    nonisolated var backport: Backport<Self> {
        .init(self)
    }
}

@available(iOS 26, macOS 26, visionOS 26, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public extension Backport where Wrapped == SwiftUI.DropSession {
    /// Returns the reorder destination for an identifiable item type.
    ///
    /// - Parameters:
    ///   - item: The item type to query.
    ///   - collectionID: The collection identifier type.
    /// - Returns: The destination of the reorder operation, or `nil` if the
    ///   drop session doesn't contain a matching reorder destination.
    @available(iOS, deprecated: 27, message: "Use DropSession.reorderDestination instead")
    @available(macOS, deprecated: 27, message: "Use DropSession.reorderDestination instead")
    @available(visionOS, deprecated: 27, message: "Use DropSession.reorderDestination instead")
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    nonisolated func reorderDestination<Item, CollectionID>(
        for item: Item.Type,
        in collectionID: CollectionID.Type = Backport<Any>.ReorderableSingleCollectionIdentifier.self
    ) -> Backport<Any>.ReorderDifference<Item.ID, CollectionID>.Destination? where Item: Identifiable {
        nil
    }

    /// Returns the reorder destination for an item identifier key path.
    ///
    /// - Parameters:
    ///   - item: The item type to query.
    ///   - itemID: A key path to the item identifier.
    ///   - collectionID: The collection identifier type.
    /// - Returns: The destination of the reorder operation, or `nil` if the
    ///   drop session doesn't contain a matching reorder destination.
    @available(iOS, deprecated: 27, message: "Use DropSession.reorderDestination instead")
    @available(macOS, deprecated: 27, message: "Use DropSession.reorderDestination instead")
    @available(visionOS, deprecated: 27, message: "Use DropSession.reorderDestination instead")
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    nonisolated func reorderDestination<Item, ItemID, CollectionID>(
        for item: Item.Type,
        itemID: KeyPath<Item, ItemID>,
        in collectionID: CollectionID.Type = Backport<Any>.ReorderableSingleCollectionIdentifier.self
    ) -> Backport<Any>.ReorderDifference<ItemID, CollectionID>.Destination? {
        nil
    }
}
