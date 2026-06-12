import CoreTransferable
import Foundation
import SwiftUI
import SwiftBackports

@available(iOS, introduced: 16, deprecated: 27, message: "Use View.draggable instead")
@available(macOS, introduced: 13, deprecated: 26, message: "Use View.draggable instead")
@available(visionOS, deprecated: 27, message: "Use View.draggable instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public extension Backport where Wrapped: View {
    /// Makes this view draggable using an item identifier associated with a
    /// drag container.
    ///
    /// - Parameters:
    ///   - containerItemID: The identifier for the dragged item in a drag container.
    ///   - containerNamespace: The namespace that identifies the drag container.
    /// - Returns: A view that begins a drag for the item identifier.
    nonisolated func draggable<ItemID>(
        containerItemID: ItemID,
        containerNamespace: Namespace.ID? = nil
    ) -> some View where ItemID: Hashable & Sendable {
        wrapped.onDrag {
            NSItemProvider(object: String(describing: containerItemID) as NSString)
        }
    }

    /// Makes this view draggable using an optional identifiable transferable
    /// item.
    ///
    /// - Parameters:
    ///   - itemType: The item type.
    ///   - item: The item to drag.
    ///   - containerNamespace: The namespace that identifies the drag container.
    /// - Returns: A view that begins a drag for the item.
    nonisolated func draggable<Item>(
        _ itemType: Item.Type = Item.self,
        item: @autoclosure @escaping () -> Item?,
        containerNamespace: Namespace.ID? = nil
    ) -> some View where Item: Transferable & Identifiable, Item.ID: Sendable {
        wrapped.onDrag {
            provider(for: item())
        }
    }

    /// Makes this view draggable using an optional identifiable transferable
    /// item.
    ///
    /// - Parameters:
    ///   - itemType: The item type.
    ///   - containerNamespace: The namespace that identifies the drag container.
    ///   - item: A closure that returns the item to drag.
    /// - Returns: A view that begins a drag for the item.
    nonisolated func draggable<Item>(
        _ itemType: Item.Type = Item.self,
        containerNamespace: Namespace.ID? = nil,
        _ item: @escaping () -> Item?
    ) -> some View where Item: Transferable & Identifiable, Item.ID: Sendable {
        wrapped.onDrag {
            provider(for: item())
        }
    }

    /// Sets the current item selection for a drag container.
    ///
    /// - Parameters:
    ///   - selection: The selected item identifiers.
    ///   - containerNamespace: The namespace that identifies the drag container.
    /// - Returns: A view that stores the drag container selection.
    nonisolated func dragContainerSelection<ItemID>(
        _ selection: @autoclosure @escaping () -> [ItemID],
        containerNamespace: Namespace.ID? = nil
    ) -> some View where ItemID: Hashable & Sendable {
        wrapped
    }

    /// Makes this view draggable using an optional transferable item and an
    /// item identifier key path.
    ///
    /// - Parameters:
    ///   - itemType: The item type.
    ///   - id: A key path to the item identifier.
    ///   - item: The item to drag.
    ///   - containerNamespace: The namespace that identifies the drag container.
    /// - Returns: A view that begins a drag for the item.
    nonisolated func draggable<Item, ItemID>(
        _ itemType: Item.Type = Item.self,
        id: KeyPath<Item, ItemID>,
        item: @autoclosure @escaping () -> Item?,
        containerNamespace: Namespace.ID? = nil
    ) -> some View where Item: Transferable, ItemID: Hashable & Sendable {
        wrapped.onDrag {
            provider(for: item())
        }
    }

    /// Makes this view draggable using an optional transferable item and an
    /// item identifier key path.
    ///
    /// - Parameters:
    ///   - itemType: The item type.
    ///   - id: A key path to the item identifier.
    ///   - containerNamespace: The namespace that identifies the drag container.
    ///   - item: A closure that returns the item to drag.
    /// - Returns: A view that begins a drag for the item.
    nonisolated func draggable<Item, ItemID>(
        _ itemType: Item.Type = Item.self,
        id: KeyPath<Item, ItemID>,
        containerNamespace: Namespace.ID? = nil,
        _ item: @escaping () -> Item?
    ) -> some View where Item: Transferable, ItemID: Hashable & Sendable {
        wrapped.onDrag {
            provider(for: item())
        }
    }

    /// Defines a drag container for a transferable item type.
    ///
    /// - Parameters:
    ///   - itemType: The item type.
    ///   - itemID: A key path to the item identifier.
    ///   - namespace: The namespace that identifies the drag container.
    ///   - payload: A closure that returns payload items for a dragged item identifier.
    /// - Returns: A view that defines a drag container.
    @_disfavoredOverload
    nonisolated func dragContainer<ItemID, Item, Data>(
        for itemType: Item.Type = Item.self,
        itemID: KeyPath<Item, ItemID>,
        in namespace: Namespace.ID? = nil,
        _ payload: @escaping (_ draggedItemID: ItemID) -> Data
    ) -> some View where ItemID: Hashable & Sendable, Item: Transferable, Data: Collection, Data.Element == Item {
        wrapped
    }

    /// Defines a drag container for an identifiable transferable item type.
    ///
    /// - Parameters:
    ///   - itemType: The item type.
    ///   - namespace: The namespace that identifies the drag container.
    ///   - payload: A closure that returns payload items for dragged item identifiers.
    /// - Returns: A view that defines a drag container.
    nonisolated func dragContainer<Item, Data>(
        for itemType: Item.Type = Item.self,
        in namespace: Namespace.ID? = nil,
        _ payload: @escaping (_ draggedItemIDs: [Item.ID]) -> Data
    ) -> some View where Item: Transferable & Identifiable, Data: Collection, Data.Element == Item, Item.ID: Sendable {
        wrapped
    }

    /// Defines a drag container for an identifiable transferable item type.
    ///
    /// - Parameters:
    ///   - itemType: The item type.
    ///   - namespace: The namespace that identifies the drag container.
    ///   - payload: A closure that returns payload items for a dragged item identifier.
    /// - Returns: A view that defines a drag container.
    @_disfavoredOverload
    nonisolated func dragContainer<Item, Data>(
        for itemType: Item.Type = Item.self,
        in namespace: Namespace.ID? = nil,
        _ payload: @escaping (_ draggedItemID: Item.ID) -> Data
    ) -> some View where Item: Transferable & Identifiable, Data: Collection, Data.Element == Item, Item.ID: Sendable {
        wrapped
    }

    /// Defines a drag container for a transferable item type using an item
    /// identifier key path.
    ///
    /// - Parameters:
    ///   - itemType: The item type.
    ///   - itemID: A key path to the item identifier.
    ///   - namespace: The namespace that identifies the drag container.
    ///   - payload: A closure that returns payload items for dragged item identifiers.
    /// - Returns: A view that defines a drag container.
    nonisolated func dragContainer<ItemID, Item, Data>(
        for itemType: Item.Type = Item.self,
        itemID: KeyPath<Item, ItemID>,
        in namespace: Namespace.ID? = nil,
        _ payload: @escaping (_ draggedItemIDs: [ItemID]) -> Data
    ) -> some View where ItemID: Hashable & Sendable, Item: Transferable, Data: Collection, Data.Element == Item {
        wrapped
    }

    /// Performs an action when the drag session changes.
    ///
    /// - Parameter onUpdate: The action to perform with the current drag session.
    /// - Returns: A view that observes drag session updates.
    nonisolated func onDragSessionUpdated(
        _ onUpdate: @escaping (Backport<Any>.DragSession) -> Void
    ) -> some View {
        wrapped
    }
}

@available(iOS, introduced: 16, deprecated: 26, message: "Use View.dropDestination instead")
@available(macOS, introduced: 13, deprecated: 26, message: "Use View.dropDestination instead")
@available(visionOS, deprecated: 26, message: "Use View.dropDestination instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public extension Backport where Wrapped: View {
    /// Defines a destination for drops of transferable values.
    ///
    /// - Parameters:
    ///   - type: The transferable type to accept.
    ///   - isEnabled: A Boolean value that indicates whether this drop destination is enabled.
    ///   - action: The action to perform with the dropped items and drop session.
    /// - Returns: A view that accepts drops.
    nonisolated func dropDestination<T>(
        for type: T.Type = T.self,
        isEnabled: Bool = true,
        action: @escaping (_ items: [T], _ session: Backport<Any>.DropSession) -> Void
    ) -> some View where T: Transferable {
        wrapped.dropDestination(for: type) { items, location in
            guard isEnabled else { return false }

            action(items, .init(
                id: .init(rawValue: ObjectIdentifier(DropSessionIdentity())),
                phase: .ended(.copy),
                itemsCount: items.count,
                suggestedOperations: [.copy],
                location: location
            ))

            return true
        }
    }
}

private final class DropSessionIdentity {}

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI draggable APIs instead")
@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI draggable APIs instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI draggable APIs instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
private func provider<T>(for item: T?) -> NSItemProvider where T: Transferable {
    let provider = NSItemProvider()
    if let item {
        provider.register(item)
    }
    return provider
}
