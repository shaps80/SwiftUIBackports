import SwiftUI
import TipKit

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
public protocol BackportTipViewStyle: DynamicProperty {
    /// The tip style's configuration.
    typealias Configuration = Backport<Any>.TipViewStyleConfiguration

    /// The user interface element of the tip.
    associatedtype Body: View

    /// A builder that makes the body of the tip view based on a style configuration.
    @ViewBuilder func makeBody(configuration: Configuration) -> Body
}

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
extension Backport<Any> {
    /// The container type that holds a tip's configuration.
    public struct TipViewStyleConfiguration {
        internal enum Placement {
            case inline
            case popover
        }

        public let tip: any BackportTip
        internal let arrowEdge: Edge?
        internal var action: (BackportTipAction) -> Void
        internal var placement: Placement
    }
}

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
extension BackportTipViewStyle where Self == Backport<Any>.MiniTipViewStyle {
    /// The default style for a tip view.
    public static var miniTip: Backport<Any>.MiniTipViewStyle { .init() }
}
