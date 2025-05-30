import SwiftUI

/// Turns the current view into an anchor for a `BackportTip`.
/// The pop-over is centred on the view’s bottom-edge and automatically
/// falls back to the custom pop-over on iOS 14–16.
private struct BackportTipAttachmentModifier<Tip: BackportTip>: ViewModifier {
    @State private var xOffset: CGFloat = .zero
    @State private var showTip = true
    let tip: Tip
    let arrowEdge: Edge
    private let screen = UIScreen.main.bounds
    private let useBackwardsViewLayout: Bool
    /// Extra padding between the view and the pop-over arrow (optional).
    init(tip: Tip, arrowEdge: Edge) {
        self.tip = tip
        self.arrowEdge = arrowEdge
        self.useBackwardsViewLayout = Backport<Any>.Tips.forceBackportTip
    }
    func body(content: Content) -> some View {
        if #available(iOS 18.4, *), useBackwardsViewLayout == false {
            content
                .popoverTip(tip.asTip, arrowEdge: arrowEdge)
        }else if #available(iOS 17, *), useBackwardsViewLayout == false {
            content
                .popoverTip(tip.asAnyTip, arrowEdge: arrowEdge)
        } else {
            legacyBody(content: content)
        }
    }
    
    func legacyBody(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    // Invisible 1×1 pt anchor at the view’s bottom-centre
                    Color.clear
                        .frame(width: 1, height: 1)
                        .position(
                            x: geo.size.width / 2,
                            y: geo.size.height * -2
                        )
                        .overlay(
                            Backport.TipView(tip, arrowEdge: arrowEdge)
                        )
                }
            )
    }
}

// MARK: – Convenience API
public extension View {
    /// Attaches a `BackportTip` to the current view.
    ///
    /// ```swift
    /// Image(systemName: "square.and.arrow.up")
    ///     .attachBackportTip(BackportTip1())
    /// ```
    func attachBackportTip<T: BackportTip>(
        _ tip: T,
        arrowEdge: Edge
    ) -> some View {
        modifier(
            BackportTipAttachmentModifier(
                tip: tip,
                arrowEdge: arrowEdge
            )
        )
    }
}

