import CoreGraphics
import SwiftUI
import SwiftBackports

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DropSession instead")
@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropSession instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DropSession instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public extension Backport<Any> {
    /// Information about an active drop session.
    struct DropSession: Identifiable {
        /// Information about a local drag session associated with this drop.
        public struct LocalSession {
            private var itemIDs: [AnyHashable]

            init(itemIDs: [AnyHashable]) {
                self.itemIDs = itemIDs
            }

            /// Returns the dragged item identifiers for the specified type.
            ///
            /// - Parameter type: The item identifier type.
            /// - Returns: The dragged item identifiers.
            public func draggedItemIDs<ItemID>(for type: ItemID.Type) -> [ItemID] where ItemID: Hashable {
                itemIDs.compactMap { $0.base as? ItemID }
            }
        }

        /// The identity of a drop session.
        public struct ID: Hashable, Sendable {
            private let rawValue: ObjectIdentifier

            init(rawValue: ObjectIdentifier) {
                self.rawValue = rawValue
            }
        }

        /// The phase of a drop session.
        public enum Phase: Hashable, Sendable {
            /// The drag entered the drop target.
            case entering

            /// The drag is active over the drop target.
            case active

            /// The drag is exiting the drop target.
            case exiting

            /// The drop ended with an operation.
            case ended(Backport<Any>.DropOperation)

            /// The data transfer completed.
            case dataTransferCompleted
        }

        /// The session identity.
        public private(set) var id: ID

        /// The current phase.
        public private(set) var phase: Phase

        /// The associated local drag session, if this drop originated in the app.
        public var localSession: LocalSession?

        /// The number of items in the drop session.
        public var itemsCount: Int

        /// The suggested drop operations.
        public var suggestedOperations: Backport<Any>.DropOperation.Set

        /// The size of the drop.
        public var size: CGSize

        /// The drop location.
        public var location: CGPoint

        init(
            id: ID,
            phase: Phase,
            localSession: LocalSession? = nil,
            itemsCount: Int = 0,
            suggestedOperations: Backport<Any>.DropOperation.Set = [.copy],
            size: CGSize = .zero,
            location: CGPoint = .zero
        ) {
            self.id = id
            self.phase = phase
            self.localSession = localSession
            self.itemsCount = itemsCount
            self.suggestedOperations = suggestedOperations
            self.size = size
            self.location = location
        }
    }
}

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DropSession.ID instead")
@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropSession.ID instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DropSession.ID instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Backport<Any>.DropSession.ID: CustomStringConvertible {
    public var description: String {
        "DropSession.ID(\(rawValue))"
    }
}

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DropSession.Phase instead")
@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropSession.Phase instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DropSession.Phase instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Backport<Any>.DropSession.Phase: CustomStringConvertible {
    public var description: String {
        switch self {
            case .entering: return "entering"
            case .active: return "active"
            case .exiting: return "exiting"
            case .ended(let operation): return "ended(\(operation))"
            case .dataTransferCompleted: return "dataTransferCompleted"
        }
    }
}

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DropSession instead")
@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropSession instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DropSession instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Backport<Any>.DropSession: CustomDebugStringConvertible {
    public var debugDescription: String {
        "DropSession(id: \(id), phase: \(phase), itemsCount: \(itemsCount), location: \(location))"
    }
}

#if os(iOS) || os(visionOS)
import UIKit

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DropSession.ID instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DropSession.ID instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Backport<Any>.DropSession.ID {
    @MainActor
    init(_ session: any UIDropSession) {
        self.init(rawValue: ObjectIdentifier(session as AnyObject))
    }

    /// Returns whether this identifier matches a UIKit drop session.
    ///
    /// - Parameter dropSession: The UIKit drop session to compare.
    /// - Returns: A Boolean value that indicates whether the sessions match.
    public func matches(_ dropSession: any UIDropSession) -> Bool {
        rawValue == ObjectIdentifier(dropSession as AnyObject)
    }
}

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DropSession instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DropSession instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Backport<Any>.DropSession {
    @MainActor
    init(_ session: any UIDropSession, phase: Phase, in view: UIView?) {
        let itemIDs = session.localDragSession?.items.compactMap { ($0.localObject as? DragItemContext)?.itemID } ?? []
        self.init(
            id: .init(session),
            phase: phase,
            localSession: itemIDs.isEmpty ? nil : .init(itemIDs: itemIDs),
            itemsCount: session.items.count,
            suggestedOperations: session.allowsMoveOperation ? [.copy, .move] : [.copy],
            size: .zero,
            location: view.map { session.location(in: $0) } ?? .zero
        )
    }
}
#endif

#if os(macOS)
import AppKit

@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropSession.ID instead")
extension Backport<Any>.DropSession.ID {
    @MainActor
    init(_ session: any NSDraggingInfo) {
        self.init(rawValue: ObjectIdentifier(session as AnyObject))
    }

    @MainActor
    func matches(_ session: any NSDraggingInfo) -> Bool {
        rawValue == ObjectIdentifier(session as AnyObject)
    }
}

@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropSession instead")
extension Backport<Any>.DropSession {
    @MainActor
    init(_ session: any NSDraggingInfo, phase: Phase, in view: NSView?) {
        let location = view.map { $0.convert(session.draggingLocation, from: nil) } ?? session.draggingLocation

        self.init(
            id: .init(session),
            phase: phase,
            itemsCount: session.draggingPasteboard.pasteboardItems?.count ?? session.numberOfValidItemsForDrop,
            suggestedOperations: .init(session.draggingSourceOperationMask),
            size: .zero,
            location: location
        )
    }
}
#endif
