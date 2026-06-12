import SwiftUI
import SwiftBackports

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DragConfiguration instead")
@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DragConfiguration instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DragConfiguration instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public extension Backport<Any> {
    /// A drag configuration.
    struct DragConfiguration {
        /// The operations allowed for drags within the app.
        public struct OperationsWithinApp: Sendable {
            private var _allowAlias: Bool
            private var allowCopy: Bool
            private var allowMove: Bool
            private var allowDelete: Bool

            /// A Boolean value that indicates whether the drag allows aliasing.
            @available(iOS, unavailable)
            @available(visionOS, unavailable)
            public var allowAlias: Bool {
                get { _allowAlias }
                set { _allowAlias = newValue }
            }

            /// Creates a set of operations allowed for drags within the app.
            @available(iOS, unavailable)
            @available(visionOS, unavailable)
            public init(allowCopy: Bool = true, allowMove: Bool = false, allowDelete: Bool = false) {
                self._allowAlias = false
                self.allowCopy = allowCopy
                self.allowMove = allowMove
                self.allowDelete = allowDelete
            }

            /// Creates a set of operations allowed for drags within the app.
            @available(macOS, unavailable)
            public init(allowMove: Bool = false) {
                self._allowAlias = false
                self.allowCopy = true
                self.allowMove = allowMove
                self.allowDelete = false
            }
        }

        /// The operations allowed for drags outside the app.
        public struct OperationsOutsideApp: Sendable {
            private var _allowAlias: Bool
            private var allowCopy: Bool
            private var allowMove: Bool
            private var allowDelete: Bool

            /// A Boolean value that indicates whether the drag allows aliasing.
            @available(iOS, unavailable)
            @available(visionOS, unavailable)
            public var allowAlias: Bool {
                get { _allowAlias }
                set { _allowAlias = newValue }
            }

            /// Creates a set of operations allowed for drags outside the app.
            @available(iOS, unavailable)
            @available(visionOS, unavailable)
            public init(allowCopy: Bool = true, allowMove: Bool = false, allowDelete: Bool = false) {
                self._allowAlias = false
                self.allowCopy = allowCopy
                self.allowMove = allowMove
                self.allowDelete = allowDelete
            }

            /// Creates a set of operations allowed for drags outside the app.
            @available(macOS, unavailable)
            public init(allowCopy: Bool = true) {
                self._allowAlias = false
                self.allowCopy = allowCopy
                self.allowMove = false
                self.allowDelete = false
            }
        }

        /// The operations allowed for drags within the app.
        public var operationsWithinApp: OperationsWithinApp

        /// The operations allowed for drags outside the app.
        public var operationsOutsideApp: OperationsOutsideApp

        /// Creates a drag configuration.
        public init(
            operationsWithinApp: OperationsWithinApp = .init(),
            operationsOutsideApp: OperationsOutsideApp = .init()
        ) {
            self.operationsWithinApp = operationsWithinApp
            self.operationsOutsideApp = operationsOutsideApp
        }

        /// Creates a drag configuration.
        ///
        /// - Parameter allowMove: A Boolean value that indicates whether moving is allowed.
        public init(allowMove: Bool) {
            self.init(operationsWithinApp: .init(allowMove: allowMove))
        }

        /// Creates a drag configuration.
        ///
        /// - Parameters:
        ///   - allowMove: A Boolean value that indicates whether moving is allowed.
        ///   - allowDelete: A Boolean value that indicates whether deleting is allowed.
        @available(iOS, unavailable)
        @available(visionOS, unavailable)
        public init(allowMove: Bool, allowDelete: Bool) {
            self.init(
                operationsWithinApp: .init(allowMove: allowMove, allowDelete: allowDelete),
                operationsOutsideApp: .init(allowMove: allowMove, allowDelete: allowDelete)
            )
        }
    }
}

@available(iOS, introduced: 16, deprecated: 26, message: "Use SwiftUI.DragConfiguration instead")
@available(macOS, introduced: 13, deprecated: 26, message: "Use SwiftUI.DragConfiguration instead")
@available(visionOS, deprecated: 26, message: "Use SwiftUI.DragConfiguration instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Backport<Any>.DragConfiguration: CustomDebugStringConvertible {
    public var debugDescription: String {
        "DragConfiguration(operationsWithinApp: \(operationsWithinApp), operationsOutsideApp: \(operationsOutsideApp))"
    }
}
