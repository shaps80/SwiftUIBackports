import SwiftUI
import SwiftBackports

@available(iOS, deprecated: 17)
@available(macOS, deprecated: 14)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(xrOS, unavailable)
public extension Backport where Wrapped: View {
    func inspector<V>(isPresented: Binding<Bool>, @ViewBuilder content: () -> V) -> some View where V: View {
        InspectorView(isPresented: isPresented, content: wrapped, inspector: content)
    }

//    func inspectorColumnWidth(min: CGFloat? = nil, ideal: CGFloat, max: CGFloat? = nil) -> some View {
//        wrapped
//            .environment(\.inspectorDimensions, (min, ideal, max))
//    }

    func inspectorColumnWidth(_ width: CGFloat) -> some View {
        wrapped
            .environment(\.inspectorDimensions, (width, width, width))
    }
}
