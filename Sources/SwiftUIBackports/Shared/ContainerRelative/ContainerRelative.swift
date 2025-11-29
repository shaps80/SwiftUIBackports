import SwiftUI
import SwiftBackports

@available(iOS, deprecated: 17, message: "Used View.containerRelativeFrame instead")
@available(tvOS, deprecated: 17, message: "Used View.containerRelativeFrame instead")
@available(macOS, deprecated: 14, message: "Used View.containerRelativeFrame instead")
@available(watchOS, deprecated: 10, message: "Used View.containerRelativeFrame instead")
extension Backport where Wrapped: View {
    /// Positions this view within an invisible frame with a size relative
    /// to the nearest container.
    ///
    /// Use this modifier to specify a size for a view's width, height,
    /// or both that is dependent on the size of the nearest container.
    /// Different things can represent a "container" including:
    ///   - The window presenting a view on iPadOS or macOS, or the
    ///     screen of a device on iOS.
    ///   - A column of a NavigationSplitView
    ///   - A NavigationStack
    ///   - A tab of a TabView
    ///   - A scrollable view like ScrollView or List
    ///
    /// The size provided to this modifier is the size of a container like
    /// the ones listed above subtracting any safe area insets that might
    /// be applied to that container.
    ///
    /// The following example will have each purple rectangle occupy the full
    /// size of the screen on iOS:
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 0.0) {
    ///             ForEach(items) { item in
    ///                 Rectangle()
    ///                     .fill(.purple)
    ///                     .backport.containerRelativeFrame([.horizontal, .vertical])
    ///             }
    ///         }
    ///     }
    ///
    /// Use the ``View/containerRelativeFrame(_:count:span:spacing:alignment:)``
    /// modifier to size a view such that multiple views will be visible in
    /// the container. When using this modifier, the count refers to the
    /// total number of rows or columns that the length of the container size
    /// in a particular axis should be divided into. The span refers to the
    /// number of rows or columns that the modified view should actually
    /// occupy. Thus the size of the element can be described like so:
    ///
    ///     let availableWidth = (containerWidth - (spacing * (count - 1)))
    ///     let columnWidth = (availableWidth / count)
    ///     let itemWidth = (columnWidth * span) + ((span - 1) * spacing)
    ///
    /// The following example only uses the nearest container size in the
    /// horizontal axis, allowing the vertical axis to be determined using
    /// the ``View/aspectRatio(_:contentMode:)`` modifier.
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 Rectangle()
    ///                     .fill(.purple)
    ///                     .aspectRatio(3.0 / 2.0, contentMode: .fit)
    ///                     .backport.containerRelativeFrame(
    ///                         .horizontal, count: 4, span: 3, spacing: 10.0)
    ///             }
    ///         }
    ///     }
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// Use the ``View/containerRelativeFrame(_:alignment:_:)``
    /// modifier to apply your own custom logic to adjust the size
    /// of the nearest container for your view. The following example will
    /// result in the container frame's width being divided by 3 and using
    /// that value as the width of the purple rectangle.
    ///
    ///     Rectangle()
    ///         .fill(.purple)
    ///         .aspectRatio(1.0, contentMode: .fill)
    ///         .backport.containerRelativeFrame(
    ///             .horizontal, alignment: .topLeading
    ///         ) { length, axis in
    ///             if axis == .vertical {
    ///                 return length / 3.0
    ///             } else {
    ///                 return length / 5.0
    ///             }
    ///         }
    ///
    nonisolated public func containerRelativeFrame(
        _ axes: Axis.Set,
        alignment: Alignment = .center
    ) -> some View {
        wrapped.modifier(
            ContainerRelativeFrameModifier(
                axes: axes,
                alignment: alignment
            ) { length, _ in
                length
            }
        )
    }

    /// Positions this view within an invisible frame with a size relative
    /// to the nearest container.
    ///
    /// Use the ``View/containerRelativeFrame(_:alignment:)`` modifier
    /// to specify a size for a view's width, height, or both that
    /// is dependent on the size of the nearest container. Different
    /// things can represent a "container" including:
    ///   - The window presenting a view on iPadOS or macOS, or the
    ///     screen of a device on iOS.
    ///   - A column of a NavigationSplitView
    ///   - A NavigationStack
    ///   - A tab of a TabView
    ///   - A scrollable view like ScrollView or List
    ///
    /// The size provided to this modifier is the size of a container like
    /// the ones listed above subtracting any safe area insets that might
    /// be applied to that container.
    ///
    /// The following example will have each purple rectangle occupy the full
    /// size of the screen on iOS:
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 0.0) {
    ///             ForEach(items) { item in
    ///                 Rectangle()
    ///                     .fill(.purple)
    ///                     .backport.containerRelativeFrame([.horizontal, .vertical])
    ///             }
    ///         }
    ///     }
    ///
    /// Use this modifier to size a view such that multiple views will be
    /// visible in the container. When using this modifier, the count refers
    /// to the total number of rows or columns that the length of the
    /// container size in a particular axis should be divided into. The span
    /// refers to the number of rows or columns that the modified view
    /// should actually occupy. Thus the size of the element can be
    /// described like so:
    ///
    ///     let availableWidth = (containerWidth - (spacing * (count - 1)))
    ///     let columnWidth = (availableWidth / count)
    ///     let itemWidth = (columnWidth * span) + ((span - 1) * spacing)
    ///
    /// The following example only uses the nearest container size in the
    /// horizontal axis, allowing the vertical axis to be determined using
    /// the ``View/aspectRatio(_:contentMode:)`` modifier.
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 Rectangle()
    ///                     .fill(.purple)
    ///                     .aspectRatio(3.0 / 2.0, contentMode: .fit)
    ///                     .backport.containerRelativeFrame(
    ///                         .horizontal, count: 4, span: 3, spacing: 10.0)
    ///             }
    ///         }
    ///     }
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// Use the ``View/containerRelativeFrame(_:alignment:_:)``
    /// modifier to apply your own custom logic to adjust the size
    /// of the nearest container for your view. The following example will
    /// result in the container frame's width being divided by 3 and using
    /// that value as the width of the purple rectangle.
    ///
    ///     Rectangle()
    ///         .fill(.purple)
    ///         .aspectRatio(1.0, contentMode: .fill)
    ///         .backport.containerRelativeFrame(
    ///             .horizontal, alignment: .topLeading
    ///         ) { length, axis in
    ///             if axis == .vertical {
    ///                 return length / 3.0
    ///             } else {
    ///                 return length / 5.0
    ///             }
    ///         }
    ///
//    nonisolated public func containerRelativeFrame(
//        _ axes: Axis.Set,
//        count: Int,
//        span: Int = 1,
//        spacing: CGFloat,
//        alignment: Alignment = .center
//    ) -> some View {
//        wrapped.modifier(
//            ContainerRelativeFrameModifier(
//                axes: axes,
//                alignment: alignment
//            ) { length, axis in
//
//            }
//        )
//    }

    /// Positions this view within an invisible frame with a size relative
    /// to the nearest container.
    ///
    /// Use the ``View/containerRelativeFrame(_:alignment:)`` modifier
    /// to specify a size for a view's width, height, or both that
    /// is dependent on the size of the nearest container. Different
    /// things can represent a "container" including:
    ///   - The window presenting a view on iPadOS or macOS, or the
    ///     screen of a device on iOS.
    ///   - A column of a NavigationSplitView
    ///   - A NavigationStack
    ///   - A tab of a TabView
    ///   - A scrollable view like ScrollView or List
    ///
    /// The size provided to this modifier is the size of a container like
    /// the ones listed above subtracting any safe area insets that might
    /// be applied to that container.
    ///
    /// The following example will have each purple rectangle occupy the full
    /// size of the screen on iOS:
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 0.0) {
    ///             ForEach(items) { item in
    ///                 Rectangle()
    ///                     .fill(.purple)
    ///                     .backport.containerRelativeFrame([.horizontal, .vertical])
    ///             }
    ///         }
    ///     }
    ///
    /// Use the ``View/containerRelativeFrame(_:count:spacing:alignment:)``
    /// modifier to size a view such that multiple views will be
    /// visible in the container. When using this modifier, the count
    /// refers to the total number of rows or columns that the length of
    /// the container size in a particular axis should be divided into.
    /// The span refers to the number of rows or columns that the modified
    /// view should actually occupy. Thus the size of the element can
    /// be described like so:
    ///
    ///     let availableWidth = (containerWidth - (spacing * (count - 1)))
    ///     let columnWidth = (availableWidth / count)
    ///     let itemWidth = (columnWidth * span) + ((span - 1) * spacing)
    ///
    /// The following example only uses the nearest container size in the
    /// horizontal axis, allowing the vertical axis to be determined using
    /// the ``View/aspectRatio(_:contentMode:)`` modifier.
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack(spacing: 10.0) {
    ///             ForEach(items) { item in
    ///                 Rectangle()
    ///                     .fill(.purple)
    ///                     .aspectRatio(3.0 / 2.0, contentMode: .fit)
    ///                     .backport.containerRelativeFrame(
    ///                         .horizontal, count: 4, span: 3, spacing: 10.0)
    ///             }
    ///         }
    ///     }
    ///     .safeAreaPadding(.horizontal, 20.0)
    ///
    /// Use this modifier to apply your own custom logic to adjust the size
    /// of the nearest container for your view. The following example will
    /// result in the container frame's width being divided by 3 and using
    /// that value as the width of the purple rectangle.
    ///
    ///     Rectangle()
    ///         .fill(.purple)
    ///         .aspectRatio(1.0, contentMode: .fill)
    ///         .backport.containerRelativeFrame(
    ///             .horizontal, alignment: .topLeading
    ///         ) { length, axis in
    ///             if axis == .vertical {
    ///                 return length / 3.0
    ///             } else {
    ///                 return length / 5.0
    ///             }
    ///         }
    ///
    nonisolated public func containerRelativeFrame(
        _ axes: Axis.Set,
        alignment: Alignment = .center,
        _ length: @escaping (CGFloat, Axis) -> CGFloat
    ) -> some View {
        wrapped.modifier(
            ContainerRelativeFrameModifier(
                axes: axes,
                alignment: alignment,
                length: length
            )
        )
    }
}

private struct ContainerRelativeFrameModifier: ViewModifier {
    @State private var size: CGSize = .zero

    var axes: Axis.Set
    var alignment: Alignment
    var length: (CGFloat, Axis) -> CGFloat

    func body(content: Content) -> some View {
        content
//            .frame(
//                width: axes.contains(.horizontal) ? length(size.width, .horizontal) : nil,
//                alignment: alignment
//            )
//            .frame(
//                height: axes.contains(.vertical) ? length(size.height, .vertical) : nil,
//                alignment: alignment
//            )
            .backport.onGeometryChange(for: CGSize.self) {
                $0.size
            } action: { _, newValue in
                size = newValue
            }
    }
}
