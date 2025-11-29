import SwiftUI
import SwiftBackports

@available(iOS, deprecated: 18, message: "Used View.onGeometryChange instead")
@available(tvOS, deprecated: 18, message: "Used View.onGeometryChange instead")
@available(macOS, deprecated: 15, message: "Used View.onGeometryChange instead")
@available(watchOS, deprecated: 10, message: "Used View.onGeometryChange instead")
extension Backport where Wrapped: View {
    /// Adds an action to be performed when a value, created from a
    /// geometry proxy, changes.
    ///
    /// The geometry of a view can change frequently, especially if
    /// the view is contained within a ``ScrollView`` and that scroll view
    /// is scrolling.
    ///
    /// You should avoid updating large parts of your app whenever
    /// the scroll geometry changes. To aid in this, you provide two
    /// closures to this modifier:
    ///   * transform: This converts a value of ``GeometryProxy`` to your
    ///     own data type.
    ///   * action: This provides the data type you created in `of`
    ///     and is called whenever the data type changes.
    ///
    /// For example, you can use this modifier to know how much of a view
    /// is visible on screen. In the following example,
    /// the data type you convert to is a ``Bool`` and the action is called
    /// whenever the ``Bool`` changes.
    ///
    ///     ScrollView(.horizontal) {
    ///         LazyHStack {
    ///              ForEach(videos) { video in
    ///                  VideoView(video)
    ///              }
    ///          }
    ///      }
    ///
    ///     struct VideoView: View {
    ///         var video: VideoModel
    ///
    ///         var body: some View {
    ///             VideoPlayer(video)
    ///                 .backport.onGeometryChange(for: Bool.self) { proxy in
    ///                     let frame = proxy.frame(in: .scrollView)
    ///                     let bounds = proxy.bounds(of: .scrollView) ?? .zero
    ///                     let intersection = frame.intersection(
    ///                         CGRect(origin: .zero, size: bounds.size))
    ///                     let visibleHeight = intersection.size.height
    ///                     return (visibleHeight / frame.size.height) > 0.75
    ///                  } action: { isVisible in
    ///                     video.updateAutoplayingState(
    ///                         isVisible: isVisible)
    ///                 }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - type: The type of value transformed from a geometry proxy.
    ///   - transform: A closure that transforms a ``GeometryProxy``
    ///     to your type.
    ///   - action: A closure to run when the transformed data changes.
    ///   - oldValue: The old value that failed the comparison check.
    ///   - newValue: The new value that failed the comparison check.
    public nonisolated func onGeometryChange<T>(
        for type: T.Type,
        of transform: @escaping @Sendable (GeometryProxy) -> T,
        action: @escaping (_ oldValue: T, _ newValue: T) -> Void
    ) -> some View where T: Equatable & Sendable {
        wrapped.modifier(
            GeometryChangeModifier(
                transform: transform,
                action: action
            )
        )
    }
}

private struct GeometryChangeModifier<T>: ViewModifier where T: Equatable & Sendable {
    @State private var value: T?
    var transform: @Sendable (GeometryProxy) -> T
    var action: (_ oldValue: T, _ newValue: T) -> Void

    func body(content: Content) -> some View {
        content
            .backport.background {
                GeometryReader { proxy in
                    let value = transform(proxy)
                    Color.clear
                        .onAppear { action(value, value) }
                        .backport.onChange(of: value) { newValue in
                            action(value, newValue)
                        }
                }
                .allowsHitTesting(false)
            }
    }
}
