import SwiftUI
import SwiftBackports
#if canImport(TipKit)
import TipKit
#endif
@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
public extension Backport where Wrapped == Any {
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
        public var action: (BackportTipAction) -> Void
        internal var placement: Backport<Any>.TipViewStyleConfiguration.Placement = .inline
        
        @State private var isVisible = true
        @State private var popWidth:  CGFloat = 0   // measured at runtime
        @State private var popHeight: CGFloat = 0
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
        @MainActor public init(_ tip: Content, arrowEdge: Edge? = nil, action: @escaping (BackportTipAction) -> Void = { _ in }) {
            self.tip = tip
            self.arrowEdge = arrowEdge
            self.action = action
        }
        
        @MainActor internal init(_ tip: Content, arrowEdge: Edge? = nil, placement: Backport<Any>.TipViewStyleConfiguration.Placement, action: @escaping (BackportTipAction) -> Void = { _ in }) {
            self.tip = tip
            self.arrowEdge = arrowEdge
            self.placement = placement
            self.action = action
        }
        
        public var body: some View {
#if canImport(TipKit)
            if Backport<Any>.Tips.forceBackportTip == false,
               #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                // Native inline TipView
                TipKit.TipView(tip.asAnyTip, arrowEdge: arrowEdge)
            } else {
                fallbackContainer                      // iOS 14‑16
            }
#else
            fallbackContainer                          // when TipKit not linked
#endif
            
        }
        
        var fallbackContainer: some View {
            Group {
                if isVisible, Backport.Tips.shouldDisplay(tip) {
                    if arrowEdge == nil {
                        fallbackBody()
                    } else {
                        // Invisible anchor. GeometryReader gives its position.
                        Color.clear
                            .frame(width: 1, height: 1)
                            .overlay(
                                GeometryReader { anchor in
                                    PopoverWithArrow(
                                        content: AnyView(fallbackBody(anchor)),
                                        anchor: anchor,
                                        arrowEdge: arrowEdge ?? .top,
                                        popWidth: popWidth,
                                        popHeight: popHeight
                                    )
                                }.frame(width: 0, height: 0)
                            )
                            .zIndex(1_000)
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .backportTipDidClose)) { notification in
                guard let tipClosed = notification.object as? BackportTip,
                      tipClosed.id == tip.id else { return }
                isVisible = false
                Backport.Tips.invalidate(tipClosed,reason: .tipClosed)
                Backport<Any>.Tips.shouldDisplay(tipClosed)
            }
        }
        
        private func fallbackBody(_ anchor: GeometryProxy? = nil)-> some View {
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
            .shadow(color: Color.black.opacity(0.06), radius: 1, y: 1) // borde fino
            .shadow(color: Color.black.opacity(0.12), radius: 6, y: 4) // blur real
            // Measure real size for pop‑over positioning
            .background(
                GeometryReader { g in
                    Color.clear
                        .onAppear {
                            popWidth = max(g.size.width, UIScreen.main.bounds.width * 0.8)
                            popHeight = min(g.size.height * 2, 120)
                        }
                        .ifAvailableOnChange(of: g.frame(in: .global)) { view in
                            popWidth = max(g.size.width, UIScreen.main.bounds.width * 0.8)
                            popHeight = min(g.size.height * 2, 120)
                        }
                }
            )
            .frame(width: popWidth, height: popHeight)
            .onAppear {
                DispatchQueue.main.async {                      // ←
                    Backport<Any>.Tips.recordDisplay(tip)
                }
            }
        }
    }
}

// MARK: – Pop‑over container with dynamic arrow positioning

fileprivate struct PopoverWithArrow: View {
    let content: AnyView
    let anchor: GeometryProxy         // proxy for the invisible 1×1 anchor
    let arrowEdge: Edge
    let popWidth:  CGFloat
    let popHeight: CGFloat
    
    // Constants
    private let sideInset: CGFloat = 32
    private let arrowSize = CGSize(width: 32, height: 16)
    private let screen = UIScreen.main.bounds
    
    var position: (showAbove: Bool, offsetX: CGFloat, offsetY: CGFloat) {
        // Where is the anchor on screen?
        let anchorFrame = anchor.frame(in: .global)
        
        // Decide whether we have more space above or below anchor
        let spaceAbove = anchorFrame.minY - 44            // rough nav‑bar
        let spaceBelow = screen.height - anchorFrame.maxY - 34 // home bar
        let showAbove  = spaceAbove > spaceBelow
        
        // Compute horizontal offset, clamped inside safe area
        let offsetX = horizontalOffset(
            midX: anchorFrame.midX,
            screenW: screen.width
        )
        // Vertical: either just above (-4) or above the card height+arrow
        let offsetY: CGFloat
        switch arrowEdge {
            case .top, .bottom:
                offsetY = showAbove ? -(popHeight + arrowSize.height) : arrowSize.height / 2
            default:
                offsetY = showAbove ? -(popHeight + arrowSize.height) : -arrowSize.height / 2
        }
        print(offsetX)
        print(offsetY)
        return (!showAbove, offsetX, offsetY)
    }
    
    var body: some View {
        let (showAbove, offsetX, offsetY) = position
        Group {
            switch arrowEdge {
                case .top, .bottom:
                    VStack(spacing: 0) {
                        if showAbove {
                            arrow(rotate: .zero, offset: .init(x: 0, y: arrowSize.height / 2))
                        }
                        content
                        if !showAbove {
                            arrow(rotate: .degrees(180), offset: .init(x: 0, y: arrowSize.height / -2))
                        }
                    }
                default:
                    content
            }
        }
        .offset(x: offsetX, y: offsetY)
    }
    
    // MARK: Arrows
    private func arrow(rotate: Angle, offset: CGPoint)-> some View {
        Triangle()
            .fill(Color(.secondarySystemBackground))
            .frame(width: arrowSize.width, height: arrowSize.height)
            .rotationEffect(rotate)
            .offset(x: offset.x, y: offset.y)
            .shadow(color: Color.black.opacity(0.12), radius: 6, x: offset.x / 2, y: 4)
    }
    
    // MARK: Helper horizontal clamping
    private func horizontalOffset(midX: CGFloat, screenW: CGFloat) -> CGFloat {
        // Desired global leading so that arrow is centred
        let desiredLeading = midX - popWidth / 2
        // Safe limits (16‑pt padding)
        let minLeading = sideInset
        let maxLeading = screenW - sideInset - popWidth
        
        // Clamp so the pop‑over never leaves the screen
        let clampedLeading = min(max(desiredLeading, minLeading), maxLeading)
        
        // Current global leading of the invisible anchor (1 × 1 pt)
        // = anchor.minX ; the overlay’s origin in local coords is the same.
        let currentLeading: CGFloat
        switch arrowEdge {
            case .top, .bottom:
                currentLeading = anchor.frame(in: .global).minX
            case .leading, .trailing:
                currentLeading = anchor.frame(in: .global).minX + 8
        }
        
        // Offset relative to the overlay’s local system
        return clampedLeading - currentLeading
    }
}

// MARK: – Simple triangle shape (arrow)

fileprivate struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

#if DEBUG
public extension GeometryProxy {
    public func debugPrint(title: String, event: String) {
        print("\(event) \(title) geometry {")
        print(" width: \(self.size.width)")
        print(" height: \(self.size.height)")
        print(" origin: \(self.frame(in: .global).origin)")
        print("}")
    }
}
#endif

public extension View {
    @ViewBuilder
    func ifAvailableOnChange<V>(of value: V, perform action: @escaping (_ newValue: V) -> Void) -> some View where V : Equatable {
        if #available(iOS 14, *) {
            self.onChange(of: value) { newValue in
                action(newValue)
            }
        } else {
            self
        }
    }
    
    @ViewBuilder
    func taskIfAvailable<T>(
        id value: T,
        priority: TaskPriority = .userInitiated,
        _ action: @escaping @Sendable () async -> Void
    ) -> some View where T : Equatable {
        if #available(iOS 15, *) {
            self.task(id: value) {
                Task { @MainActor in
                    await action()
                }
            }
        } else {
            self
        }
    }
}
