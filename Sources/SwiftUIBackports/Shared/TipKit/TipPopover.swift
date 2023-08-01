import SwiftUI
import SwiftBackports

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
extension Backport where Wrapped: View {
    @MainActor public func popoverTip<Content>(_ tip: Content, arrowEdge: Edge = .top, action: @escaping (Backport<Any>.Tips.Action) -> Void = { _ in }) -> some View where Content: BackportTip {
        wrapped.popover(isPresented: .constant(true), arrowEdge: arrowEdge) {
            Backport<Any>.TipView(tip, arrowEdge: arrowEdge, placement: .popover, action: action)
#if os(iOS)
                .frame(minWidth: 200)
#endif
        }
    }
}
