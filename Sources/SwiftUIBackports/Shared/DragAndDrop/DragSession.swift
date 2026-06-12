import CoreGraphics
import SwiftUI
import SwiftBackports

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DragSession instead")
@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DragSession instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DragSession instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public extension Backport<Any> {
    /// Information about an active drag session.
    struct DragSession: Identifiable {
        /// The phase of a drag session.
        public enum Phase: Hashable, Sendable {
            /// The initial phase of the drag.
            case initial

            /// The active phase of the drag.
            case active

            /// The drag is ending with an operation.
            @available(macOS, unavailable)
            case ending(Backport<Any>.DropOperation)

            /// The drag ended with an operation.
            case ended(Backport<Any>.DropOperation)

            /// The data transfer completed.
            case dataTransferCompleted
        }

        /// The identity of a drag session.
        public struct ID: Hashable, Sendable {
            private let rawValue: ObjectIdentifier

            init(rawValue: ObjectIdentifier) {
                self.rawValue = rawValue
            }
        }

        /// The session identity.
        public private(set) var id: ID

        /// The current phase.
        public private(set) var phase: Phase

        /// The index of the dragged item.
        public private(set) var draggedItemIndex: Int

        /// The drag location.
        public var location: CGPoint

        private var itemIDs: [AnyHashable]

        init(
            id: ID,
            phase: Phase,
            draggedItemIndex: Int = 0,
            itemIDs: [AnyHashable] = [],
            location: CGPoint = .zero
        ) {
            self.id = id
            self.phase = phase
            self.draggedItemIndex = draggedItemIndex
            self.itemIDs = itemIDs
            self.location = location
        }

        /// Returns the dragged item identifiers for the specified type.
        ///
        /// - Parameter type: The item identifier type.
        /// - Returns: The dragged item identifiers.
        public func draggedItemIDs<ItemID>(for type: ItemID.Type) -> [ItemID] where ItemID: Hashable {
            itemIDs.compactMap { $0.base as? ItemID }
        }
    }
}

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DragSession.Phase instead")
@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DragSession.Phase instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DragSession.Phase instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Backport<Any>.DragSession.Phase: CustomStringConvertible {
    public var description: String {
        switch self {
            case .initial: return "initial"
            case .active: return "active"
            case .ending(let operation): return "ending(\(operation))"
            case .ended(let operation): return "ended(\(operation))"
            case .dataTransferCompleted: return "dataTransferCompleted"
        }
    }
}

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DragSession.ID instead")
@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DragSession.ID instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DragSession.ID instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Backport<Any>.DragSession.ID: CustomDebugStringConvertible {
    public var debugDescription: String {
        "DragSession.ID(\(rawValue))"
    }
}

#if os(iOS) || os(visionOS)
import UIKit

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DragSession.ID instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DragSession.ID instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Backport<Any>.DragSession.ID {
    @MainActor
    init(_ session: any UIDragSession) {
        self.init(rawValue: ObjectIdentifier(session as AnyObject))
    }

    /// Returns whether this identifier matches a UIKit drag session.
    ///
    /// - Parameter dragSession: The UIKit drag session to compare.
    /// - Returns: A Boolean value that indicates whether the sessions match.
    public func matches(_ dragSession: any UIDragSession) -> Bool {
        rawValue == ObjectIdentifier(dragSession as AnyObject)
    }
}

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DragSession instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DragSession instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Backport<Any>.DragSession {
    @MainActor
    init(_ session: any UIDragSession, phase: Phase, in view: UIView?, draggedItemIndex: Int = 0) {
        self.init(
            id: .init(session),
            phase: phase,
            draggedItemIndex: draggedItemIndex,
            itemIDs: session.items.compactMap { ($0.localObject as? DragItemContext)?.itemID },
            location: view.map { session.location(in: $0) } ?? .zero
        )
    }
}
#endif

#if os(macOS)
import AppKit

@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DragSession.ID instead")
extension Backport<Any>.DragSession.ID {
    @MainActor
    init(_ session: NSDraggingSession) {
        self.init(rawValue: ObjectIdentifier(session))
    }

    @MainActor
    func matches(_ session: NSDraggingSession) -> Bool {
        rawValue == ObjectIdentifier(session)
    }
}

@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DragSession instead")
extension Backport<Any>.DragSession {
    @MainActor
    init(_ session: NSDraggingSession, phase: Phase) {
        self.init(
            id: .init(session),
            phase: phase,
            itemIDs: [],
            location: session.draggingLocation
        )
    }
}
#endif
