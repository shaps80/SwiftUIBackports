import SwiftUI
import SwiftBackports

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DropOperation instead")
@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropOperation instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DropOperation instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public extension Backport<Any> {
    /// An operation that a drop interaction can perform.
    enum DropOperation: Hashable, Sendable {
        /// Cancels the drop operation.
        case cancel

        /// Forbids the drop operation.
        case forbidden

        /// Copies the dropped content.
        case copy

        /// Moves the dropped content.
        case move

        /// Deletes the dropped content.
        @available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropOperation.delete instead")
        @available(iOS, unavailable)
        @available(visionOS, unavailable)
        case delete

        /// Creates an alias to the dropped content.
        @available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropOperation.alias instead")
        @available(iOS, unavailable)
        @available(visionOS, unavailable)
        case alias

        /// A set of drop operations.
        public struct Set: OptionSet, Hashable {
            /// The raw value of the operation set.
            public let rawValue: Int

            /// Creates a drop operation set from a raw value.
            ///
            /// - Parameter rawValue: The raw value.
            public init(rawValue: Int) {
                self.rawValue = rawValue
            }

            /// A set containing the cancel operation.
            public static var cancel: Set { Set(rawValue: 1 << 0) }

            /// A set containing the copy operation.
            public static var copy: Set { Set(rawValue: 1 << 1) }

            /// A set containing the move operation.
            public static var move: Set { Set(rawValue: 1 << 2) }

            /// A set containing the forbidden operation.
            public static var forbidden: Set { Set(rawValue: 1 << 3) }

            /// A set containing the delete operation.
            @available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropOperation.Set.delete instead")
            @available(iOS, unavailable)
            @available(visionOS, unavailable)
            public static var delete: Set { Set(rawValue: 1 << 4) }

            /// A set containing the alias operation.
            @available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropOperation.Set.alias instead")
            @available(iOS, unavailable)
            @available(visionOS, unavailable)
            public static var alias: Set { Set(rawValue: 1 << 5) }
        }
    }
}

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DropOperation.Set instead")
@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropOperation.Set instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DropOperation.Set instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Backport<Any>.DropOperation.Set: CustomStringConvertible {
    public var description: String {
        var values: [String] = []
        if contains(.cancel) { values.append("cancel") }
        if contains(.copy) { values.append("copy") }
        if contains(.move) { values.append("move") }
        if contains(.forbidden) { values.append("forbidden") }
        #if os(macOS)
        if contains(.delete) { values.append("delete") }
        if contains(.alias) { values.append("alias") }
        #endif
        return values.joined(separator: ", ")
    }
}

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DropOperation instead")
@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropOperation instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DropOperation instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Backport<Any>.DropOperation {
    var swiftUIOperation: SwiftUI.DropOperation {
        switch self {
            case .cancel: return .cancel
            case .forbidden: return .forbidden
            case .copy: return .copy
            case .move: return .move
            #if os(macOS)
            case .delete:
                if #available(macOS 26, *) {
                    return .delete
                } else {
                    return .forbidden
                }

            case .alias:
                if #available(macOS 26, *) {
                    return .alias
                } else {
                    return .copy
                }
            #elseif os(tvOS) || os(watchOS)
            case .delete: return .forbidden
            case .alias: return .copy
            #endif
        }
    }

    init(_ operation: SwiftUI.DropOperation) {
        #if os(macOS)
        if #available(macOS 26, *) {
            switch operation {
                case .delete:
                    self = .delete
                    return
                case .alias:
                    self = .alias
                    return
                default:
                    break
            }
        }
        #endif

        switch operation {
            case .cancel: self = .cancel
            case .forbidden: self = .forbidden
            case .copy: self = .copy
            case .move: self = .move
            default: self = .cancel
        }
    }
}

#if os(iOS) || os(visionOS)
import UIKit

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DropOperation instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DropOperation instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Backport<Any>.DropOperation {
    init(_ operation: UIDropOperation) {
        switch operation {
            case .cancel: self = .cancel
            case .forbidden: self = .forbidden
            case .copy: self = .copy
            case .move: self = .move
            @unknown default: self = .cancel
        }
    }

    var uiDropOperation: UIDropOperation {
        switch self {
            case .cancel: return .cancel
            case .forbidden: return .forbidden
            case .copy: return .copy
            case .move: return .move
        }
    }
}
#endif

#if os(macOS)
import AppKit

@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropOperation instead")
extension Backport<Any>.DropOperation {
    init(_ operation: NSDragOperation) {
        if operation.contains(.move) {
            self = .move
        } else if operation.contains(.copy) {
            self = .copy
        } else if operation.contains(.delete) {
            self = .delete
        } else if operation.contains(.link) {
            self = .alias
        } else if operation.isEmpty {
            self = .cancel
        } else {
            self = .forbidden
        }
    }

    var nsDragOperation: NSDragOperation {
        switch self {
            case .cancel, .forbidden:
                return []
            case .copy:
                return .copy
            case .move:
                return .move
            case .delete:
                return .delete
            case .alias:
                return .link
        }
    }
}

@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DropOperation.Set instead")
extension Backport<Any>.DropOperation.Set {
    init(_ operations: NSDragOperation) {
        var result: Self = []

        if operations.isEmpty {
            result.insert(.cancel)
        }

        if operations.contains(.copy) {
            result.insert(.copy)
        }

        if operations.contains(.move) {
            result.insert(.move)
        }

        if operations.contains(.delete) {
            result.insert(.delete)
        }

        if operations.contains(.link) {
            result.insert(.alias)
        }

        self = result
    }

    var nsDragOperation: NSDragOperation {
        var result: NSDragOperation = []

        if contains(.copy) {
            result.insert(.copy)
        }

        if contains(.move) {
            result.insert(.move)
        }

        if contains(.delete) {
            result.insert(.delete)
        }

        if contains(.alias) {
            result.insert(.link)
        }

        return result
    }
}
#endif
