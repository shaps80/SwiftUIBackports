import SwiftUI
import SwiftBackports

@available(iOS, deprecated: 27, message: "Use View.reorderContainer instead")
@available(macOS, deprecated: 27, message: "Use View.reorderContainer instead")
@available(watchOS, deprecated: 27, message: "Use View.reorderContainer instead")
@available(visionOS, deprecated: 27, message: "Use View.reorderContainer instead")
@available(tvOS, unavailable)
public extension Backport where Wrapped: View {
    /// Defines a container that supports reordering identifiable items.
    ///
    /// Apply this modifier to a view that contains dynamic content marked with
    /// ``DynamicViewContent/backport/reorderable()``.
    ///
    /// - Parameters:
    ///   - item: The item type that the container reorders.
    ///   - isEnabled: A Boolean value that indicates whether reordering is enabled.
    ///   - move: A closure that handles the reorder difference.
    /// - Returns: A view that defines a reorder container.
    nonisolated func reorderContainer<Item>(
        for item: Item.Type,
        isEnabled: Bool = true,
        move: @escaping (_ difference: Backport<Any>.ReorderDifference<Item.ID, Backport<Any>.ReorderableSingleCollectionIdentifier>) -> Void
    ) -> some View where Item: Identifiable, Item.ID: Sendable {
        wrapped
    }

    /// Defines a container that supports reordering identifiable items across
    /// collections.
    ///
    /// Apply this modifier to a view that contains dynamic content marked with
    /// ``DynamicViewContent/backport/reorderable(collectionID:)``.
    ///
    /// - Parameters:
    ///   - item: The item type that the container reorders.
    ///   - collectionID: The collection identifier type.
    ///   - isEnabled: A Boolean value that indicates whether reordering is enabled.
    ///   - move: A closure that handles the reorder difference.
    /// - Returns: A view that defines a reorder container.
    nonisolated func reorderContainer<Item, CollectionID>(
        for item: Item.Type,
        in collectionID: CollectionID.Type,
        isEnabled: Bool = true,
        move: @escaping (_ difference: Backport<Any>.ReorderDifference<Item.ID, CollectionID>) -> Void
    ) -> some View where Item: Identifiable, CollectionID: Hashable & Sendable, Item.ID: Sendable {
        wrapped
    }

    /// Defines a container that supports reordering items using an item
    /// identifier key path.
    ///
    /// Apply this modifier to a view that contains dynamic content marked with
    /// ``DynamicViewContent/backport/reorderable()``.
    ///
    /// - Parameters:
    ///   - item: The item type that the container reorders.
    ///   - itemID: A key path to the item identifier.
    ///   - isEnabled: A Boolean value that indicates whether reordering is enabled.
    ///   - move: A closure that handles the reorder difference.
    /// - Returns: A view that defines a reorder container.
    nonisolated func reorderContainer<Item, ItemID>(
        for item: Item.Type,
        itemID: KeyPath<Item, ItemID>,
        isEnabled: Bool = true,
        move: @escaping (_ difference: Backport<Any>.ReorderDifference<ItemID, Backport<Any>.ReorderableSingleCollectionIdentifier>) -> Void
    ) -> some View where ItemID: Hashable & Sendable {
        wrapped
    }

    /// Defines a container that supports reordering items across collections
    /// using an item identifier key path.
    ///
    /// Apply this modifier to a view that contains dynamic content marked with
    /// ``DynamicViewContent/backport/reorderable(collectionID:)``.
    ///
    /// - Parameters:
    ///   - item: The item type that the container reorders.
    ///   - itemID: A key path to the item identifier.
    ///   - collectionID: The collection identifier type.
    ///   - isEnabled: A Boolean value that indicates whether reordering is enabled.
    ///   - move: A closure that handles the reorder difference.
    /// - Returns: A view that defines a reorder container.
    nonisolated func reorderContainer<Item, ItemID, CollectionID>(
        for item: Item.Type,
        itemID: KeyPath<Item, ItemID>,
        in collectionID: CollectionID.Type,
        isEnabled: Bool = true,
        move: @escaping (_ difference: Backport<Any>.ReorderDifference<ItemID, CollectionID>) -> Void
    ) -> some View where ItemID: Hashable & Sendable, CollectionID: Hashable & Sendable {
        wrapped
    }
}
