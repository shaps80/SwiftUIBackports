import SwiftUI
import SwiftBackports

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
extension Backport where Wrapped: View {
    @MainActor public func popoverTip<Content>(_ tip: Content, arrowEdge: Edge = .top, action: @escaping (BackportTipAction) -> Void = { _ in }) -> some View where Content: BackportTip {
        wrapped.modifier(PopoverTipModifier(tip: tip, arrowEdge: arrowEdge, action: action))
    }
}

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
private struct PopoverTipModifier<Tip: BackportTip>: ViewModifier {
    @Environment(\.tipStyle) private var tipStyle
    @State private var isPresented: Bool = false
    @State private var width: CGFloat = 200

    let tip: Tip
    let arrowEdge: Edge
    let action: (BackportTipAction) -> Void

    func body(content: Content) -> some View {
        content
            .backport.onChange(of: isPresented) { newValue in
                if !newValue { tip.invalidate(reason: .tipClosed) }
            }
            .backport.overlay {
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: SizePreferenceKey.self, 
                        value: proxy.size
                    )
                }
            }
            .onPreferenceChange(SizePreferenceKey.self) { value in
                width = min(value.width, 320)
            }
            .popover(isPresented: $isPresented, arrowEdge: arrowEdge) {
                AnyView(
                    tipStyle.resolve(
                        configuration: .init(
                            tip: tip,
                            arrowEdge: arrowEdge,
                            action: action,
                            placement: .popover
                        )
                    )
                )
                .popoverDismissDisabled()
#if os(iOS)
                .frame(minWidth: width)
#endif
            }
            .backport.task(id: tip.id) { isPresented = tip.shouldDisplay }
    }
}

extension View {
    @ViewBuilder
    func popoverDismissDisabled() -> some View {
#if os(iOS)
        if #available(iOS 15, *) {
            interactiveDismissDisabled()
        } else {
            backport.interactiveDismissDisabled()
        }
#else
        if #available(macOS 12, *) {
            interactiveDismissDisabled()
        } else {
            self
        }
#endif
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

private struct SizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.overlay(
            GeometryReader { geo in
                Color.clear.preference(
                    key: SizePreferenceKey.self,
                    value: geo.size
                )
            }
        )
    }
}
