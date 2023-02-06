import SwiftUI

extension Backport where Wrapped: View {

    /// Sets the Dynamic Type size within the view to the given value.
    ///
    /// As an example, you can set a Dynamic Type size in `ContentView` to be
    /// ``DynamicTypeSize/xLarge`` (this can be useful in previews to see your
    /// content at a different size) like this:
    ///
    ///     ContentView()
    ///         .dynamicTypeSize(.xLarge)
    ///
    /// If a Dynamic Type size range is applied after setting a value,
    /// the value is limited by that range:
    ///
    ///     ContentView() // Dynamic Type size will be .large
    ///         .dynamicTypeSize(...DynamicTypeSize.large)
    ///         .dynamicTypeSize(.xLarge)
    ///
    /// When limiting the Dynamic Type size, consider if adding a
    /// large content view with ``View/accessibilityShowsLargeContentViewer()``
    /// would be appropriate.
    ///
    /// - Parameter size: The size to set for this view.
    ///
    /// - Returns: A view that sets the Dynamic Type size to the specified
    ///   `size`.
    @ViewBuilder
    public func dynamicTypeSize(_ size: Backport<Any>.DynamicTypeSize) -> some View {
        content.environment(\.backportDynamicTypeSize, size)
    }


    /// Limits the Dynamic Type size within the view to the given range.
    ///
    /// As an example, you can constrain the maximum Dynamic Type size in
    /// `ContentView` to be no larger than ``DynamicTypeSize/large``:
    ///
    ///     ContentView()
    ///         .dynamicTypeSize(...DynamicTypeSize.large)
    ///
    /// If the Dynamic Type size is limited to multiple ranges, the result is
    /// their intersection:
    ///
    ///     ContentView() // Dynamic Type sizes are from .small to .large
    ///         .dynamicTypeSize(.small...)
    ///         .dynamicTypeSize(...DynamicTypeSize.large)
    ///
    /// A specific Dynamic Type size can still be set after a range is applied:
    ///
    ///     ContentView() // Dynamic Type size is .xLarge
    ///         .dynamicTypeSize(.xLarge)
    ///         .dynamicTypeSize(...DynamicTypeSize.large)
    ///
    /// When limiting the Dynamic Type size, consider if adding a
    /// large content view with ``View/accessibilityShowsLargeContentViewer()``
    /// would be appropriate.
    ///
    /// - Parameter range: The range of sizes that are allowed in this view.
    ///
    /// - Returns: A view that constrains the Dynamic Type size of this view
    ///   within the specified `range`.
    @ViewBuilder
    public func dynamicTypeSize<T>(_ range: T) -> some View where T: RangeExpression, T.Bound == Backport<Any>.DynamicTypeSize {
        if let range = range as? Range<T.Bound> {
            content
                .modifier(DynamicTypeRangeModifier())
                .environment(\.dynamicTypeRange, range)
        } else if let range = range as? ClosedRange<T.Bound> {
            content
                .modifier(DynamicTypeRangeModifier())
                .environment(\.dynamicTypeRange, .init(uncheckedBounds: (lower: range.lowerBound, upper: range.upperBound)))
        } else if let range = range as? PartialRangeFrom<T.Bound> {
            content
                .modifier(DynamicTypeRangeModifier())
                .environment(\.dynamicTypeRange, .init(uncheckedBounds: (range.lowerBound, .accessibility5)))
        } else if let range = range as? PartialRangeUpTo<T.Bound> {
            content
                .modifier(DynamicTypeRangeModifier())
                .environment(\.dynamicTypeRange, .init(uncheckedBounds: (.xSmall, range.upperBound)))
        } else if let range = range as? PartialRangeThrough<T.Bound> {
            content
                .modifier(DynamicTypeRangeModifier())
                .environment(\.dynamicTypeRange, .init(uncheckedBounds: (.xSmall, range.upperBound)))
        } else {
            content
                .modifier(DynamicTypeRangeModifier())
        }
    }

}

private struct DynamicTypeRangeModifier: ViewModifier {
    @Environment(\.dynamicTypeRange) private var range
    @Environment(\.backportDynamicTypeSize) private var size

    private var resolvedSize: Backport<Any>.DynamicTypeSize {
        range.contains(size)
        ? size
        : max(range.lowerBound, min(range.upperBound, size))
    }

    func body(content: Content) -> some View {
        content.environment(\.backportDynamicTypeSize, resolvedSize)
    }
}
