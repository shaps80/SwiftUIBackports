import SwiftUI
import SwiftBackports

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
extension Backport where Wrapped: View {
    @MainActor public func popoverTip<Content>(_ tip: Content, arrowEdge: Edge = .top, action: @escaping (Backport<Any>.Tips.Action) -> Void = { _ in }) -> some View where Content: BackportTip {
        wrapped.modifier(PopoverTipModifier(tip: tip, arrowEdge: arrowEdge, action: action))
    }
}

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
private struct PopoverTipModifier<Tip: BackportTip>: ViewModifier {
    @State private var isPresented: Bool = false
    let tip: Tip
    let arrowEdge: Edge
    let action: (Backport<Any>.Tips.Action) -> Void

    func body(content: Content) -> some View {
        content.popover(isPresented: $isPresented, arrowEdge: arrowEdge) {
            Backport<Any>.TipView(tip, arrowEdge: arrowEdge, placement: .popover, action: action)
#if os(iOS)
                .frame(minWidth: 200)
#endif
        }
        .onAppear {
            #warning("This should only be based on a rule later on")
            isPresented = true
        }
    }
}
