#if os(iOS)
import SwiftUI

public extension Backport<Any> {
    enum ToolbarItemPlacement {
        case automatic
        case primaryAction
        case confirmationAction
        case cancellationAction
        case destructiveAction
        case principal
        case bottomBar

        var isLeading: Bool {
            switch self {
            case .cancellationAction:
                return true
            default:
                return false
            }
        }

        var isTrailing: Bool {
            switch self {
            case .automatic, .primaryAction, .confirmationAction, .destructiveAction:
                return true
            default:
                return false
            }
        }
    }

    struct ToolbarItem: View {
        let id: String
        let placement: Backport.ToolbarItemPlacement
        let content: AnyView

        public init<Content: View>(id: String = UUID().uuidString, placement: Backport.ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> Content) {
            self.id = id
            self.placement = placement
            self.content = AnyView(content())
        }

        public var body: some View {
            content.id(id)
        }
    }
}

extension Collection where Element == Backport<Any>.ToolbarItem, Indices: RandomAccessCollection, Indices.Index: Hashable {
    @ViewBuilder var content: some View {
        if !isEmpty {
            HStack {
                ForEach(indices, id: \.self) { index in
                    self[index].content
                }
            }
        }
    }
}

@available(iOS, introduced: 13, deprecated: 14)
struct ToolbarModifier: ViewModifier {
    let leadingItems: [Backport<Any>.ToolbarItem]
    let trailingItems: [Backport<Any>.ToolbarItem]
    let principalItems: [Backport<Any>.ToolbarItem]
    let bottomBarItems: [Backport<Any>.ToolbarItem]

    init(items: [Backport<Any>.ToolbarItem]) {
        leadingItems = items.filter { $0.placement.isLeading }
        trailingItems = items.filter { $0.placement.isTrailing }
        principalItems = items.filter { $0.placement == .principal }
        bottomBarItems = items.filter { $0.placement == .bottomBar }
    }

    @ViewBuilder
    private var leading: some View {
        if !leadingItems.isEmpty {
            HStack {
                ForEach(leadingItems, id: \.id) { item in
                    item.content
                }
            }
        }
    }

    @ViewBuilder
    private var trailing: some View {
        if !trailingItems.isEmpty {
            HStack {
                ForEach(trailingItems, id: \.id) { item in
                    item.content
                }
            }
        }
    }

    @ViewBuilder
    private var principal: some View {
        if !principalItems.isEmpty {
            HStack {
                ForEach(principalItems, id: \.id) { item in
                    item.content
                }
            }
        }
    }

    @ViewBuilder
    private var bottomBar: some View {
        if !bottomBarItems.isEmpty {
            HStack {
                ForEach(bottomBarItems, id: \.id) { item in
                    item.content
                }
            }
        }
    }

    @Namespace private var namespace

    func body(content: Content) -> some View {
        content
            .navigationBarItems(leading: leading, trailing: trailing)
            .controller { controller in
                if !principalItems.isEmpty {
                    controller?.navigationItem.titleView = UIHostingController(
                        rootView: principal.backport.largeScale(),
                        ignoreSafeArea: false
                    ).view
                    controller?.navigationItem.titleView?.backgroundColor = .clear
                }

                if !bottomBarItems.isEmpty {
                    controller?.navigationController?.setToolbarHidden(false, animated: false)
                    controller?.toolbarItems = bottomBarItems.map {
                        let view = UIHostingController(rootView: $0.content.backport.largeScale()).view!
                        view.backgroundColor = .clear
                        return .init(customView: view)
                    }
                }
            }
    }
}

private extension Backport where Wrapped: View {
    func largeScale() -> some View {
        #if os(macOS)
        if #available(macOS 11, *) {
            content.imageScale(.large)
        } else {
            content
        }
        #else
        content.imageScale(.large)
        #endif
    }
}

@available(iOS, introduced: 13, deprecated: 14)
public extension Backport where Wrapped: View {
    @ViewBuilder
    func toolbar(@Backport<Any>.ToolbarContentBuilder _ items: () -> [Backport<Any>.ToolbarItem]) -> some View {
        content.modifier(ToolbarModifier(items: items()))
    }
}

public extension Backport<Any> {
    @resultBuilder struct ToolbarContentBuilder { }
}

public extension Backport<Any>.ToolbarContentBuilder {
    static func buildBlock() -> [Backport<Any>.ToolbarItem] {
        [.init(content: EmptyView.init)]
    }

    static func buildBlock(_ content: Backport<Any>.ToolbarItem) -> [Backport<Any>.ToolbarItem] {
        [content]
    }

    static func buildIf(_ content: Backport<Any>.ToolbarItem?) -> [Backport<Any>.ToolbarItem?] {
        [content].compactMap { $0 }
    }

    static func buildEither(first: Backport<Any>.ToolbarItem) -> [Backport<Any>.ToolbarItem] {
        [first]
    }

    static func buildEither(second: Backport<Any>.ToolbarItem) -> [Backport<Any>.ToolbarItem] {
        [second]
    }

    static func buildLimitedAvailability(_ content: Backport<Any>.ToolbarItem) -> [Backport<Any>.ToolbarItem] {
        [content]
    }

    static func buildBlock(_ c0: Backport<Any>.ToolbarItem, _ c1: Backport<Any>.ToolbarItem) -> [Backport<Any>.ToolbarItem] {
        [c0, c1]
    }

    static func buildBlock(_ c0: Backport<Any>.ToolbarItem, _ c1: Backport<Any>.ToolbarItem, _ c2: Backport<Any>.ToolbarItem) -> [Backport<Any>.ToolbarItem] {
        [c0, c1, c2]
    }

    static func buildBlock(_ c0: Backport<Any>.ToolbarItem, _ c1: Backport<Any>.ToolbarItem, _ c2: Backport<Any>.ToolbarItem, _ c3: Backport<Any>.ToolbarItem) -> [Backport<Any>.ToolbarItem] {
        [c0, c1, c2, c3]
    }

    static func buildBlock(_ c0: Backport<Any>.ToolbarItem, _ c1: Backport<Any>.ToolbarItem, _ c2: Backport<Any>.ToolbarItem, _ c3: Backport<Any>.ToolbarItem, _ c4: Backport<Any>.ToolbarItem) -> [Backport<Any>.ToolbarItem] {
        [c0, c1, c2, c3, c4]
    }

    static func buildBlock(_ c0: Backport<Any>.ToolbarItem, _ c1: Backport<Any>.ToolbarItem, _ c2: Backport<Any>.ToolbarItem, _ c3: Backport<Any>.ToolbarItem, _ c4: Backport<Any>.ToolbarItem, _ c5: Backport<Any>.ToolbarItem) -> [Backport<Any>.ToolbarItem] {
        [c0, c1, c2, c3, c4, c5]
    }
}
#endif
