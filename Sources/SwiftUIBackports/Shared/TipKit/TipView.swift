import SwiftUI

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
extension Backport<Any> {
    /// A user interface element that represents an inline tip.
    ///
    /// You create a tip view by providing a tip along with an optional arrow edge and action.
    /// The tip is a type that conforms to the ``Tip`` protocol.
    /// The arrow edge is a directional arrow pointing away from the tip.
    /// The action is a closure that executes when the user triggers a tip’s button.
    ///
    /// For example, display a tip view, above an image, with an arrow edge along the bottom:
    ///
    /// 1. Define your tip's content as a structure conforming to the `Tip` protocol.
    /// 2. Create an instance your tip as a variable in the view containing the feature you want to highlight.
    /// 3. Create an instance of a `TipView`, near the feature you want to highlight, passing in the instance your tip's content, along with an optional arrow edge.
    /// 4. Then configure and load the tips for your app by calling ``Tips/configure(options:)``.
    ///
    /// ```swift
    /// import SwiftUI
    /// import TipKit
    ///
    /// // Define your tips content.
    /// struct SampleTip: Tip {
    ///     var title: Text {
    ///         Text("Save as a Favorite")
    ///     }
    ///     var message: Text? {
    ///         Text("Your favorite backyards always appear at the top of the list.")
    ///     }
    ///     var asset: Image? {
    ///         Image(systemName: "star")
    ///     }
    /// }
    ///
    /// struct SampleView: View {
    ///     // Create an instance of your tip.
    ///     var tip = SampleTip()
    ///
    ///     var body: some View {
    ///         VStack {
    ///             // Place the tip view near the feature you want to highlight.
    ///             // ``Tips/configure(options:)`` must be called before your tip will be eligible for display.
    ///             TipView(tip, arrowEdge: .bottom)
    ///             Image(systemName: "star")
    ///                 .imageScale(.large)
    ///             Spacer()
    ///         }
    ///         .padding()
    ///     }
    /// }
    @MainActor public struct TipView<Content>: View where Content: BackportTip {
        @Environment(\.tipStyle) private var tipStyle
        
        public var tip: Content
        public var arrowEdge: Edge?
        public var action: (Backport<Any>.Tips.Action) -> Void
        internal var placement: Backport<Any>.TipViewStyleConfiguration.Placement = .inline

        /// Creates a tip view with an optional arrow.
        ///
        /// Use a `TipView` when you want to indicate the UI element to which
        /// the tip applies, but don't want to directly anchor the tip view to that
        /// element. Use the ``SwiftUI/View/popoverTip(_:arrowEdge:action:)``to anchor your tip to an element.
        ///
        /// - Parameters:
        ///   - tip: The tip to display.
        ///   - isVisible: A binding that gets set to `true` if tip eligibility is met. Gets set to `false` if tip eligibility is not met and `EmptyView` is returned.
        ///   - arrowEdge: The edge of the tip view that displays the arrow.
        ///   - action: The action to perform when the user triggers a tip's button.
        @MainActor public init(_ tip: Content, arrowEdge: Edge? = nil, action: @escaping (Backport<Any>.Tips.Action) -> Void = { _ in }) {
            self.tip = tip
            self.arrowEdge = arrowEdge
            self.action = action
        }

        @MainActor internal init(_ tip: Content, arrowEdge: Edge? = nil, placement: Backport<Any>.TipViewStyleConfiguration.Placement, action: @escaping (Backport<Any>.Tips.Action) -> Void = { _ in }) {
            self.tip = tip
            self.arrowEdge = arrowEdge
            self.placement = placement
            self.action = action
        }

        public var body: some View {
            AnyView(
                tipStyle.resolve(
                    configuration: .init(
                        tip: tip, 
                        arrowEdge: arrowEdge,
                        action: action,
                        placement: placement
                    )
                )
            )
        }
    }
}
