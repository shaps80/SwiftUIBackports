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
        let placement: Backport.ToolbarItemPlacement
        let content: AnyView

        public init<Content: View>(placement: Backport.ToolbarItemPlacement, @ViewBuilder content: () -> Content) {
            self.placement = placement
            self.content = AnyView(content())
        }

        public var body: some View {
            content
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
public extension Backport where Wrapped: View {
    @ViewBuilder
    func toolbar(@BackportToolbarContentBuilder _ items: () -> [Backport<Any>.ToolbarItem]) -> some View {
        let items = items()
        content
            .navigationBarItems(leading: items.filter { $0.placement.isLeading }.content, trailing: items.filter { $0.placement.isTrailing }.content)
            .controller { controller in
                controller?.navigationItem.titleView = UIHostingController(
                    rootView: items.filter { $0.placement == .principal }.content,
                    ignoreSafeArea: false
                ).view
            }
    }
}

@resultBuilder
public struct BackportToolbarContentBuilder { }
public extension BackportToolbarContentBuilder {
    static func buildBlock() -> [Backport<Any>.ToolbarItem] {
        [Backport<Any>.ToolbarItem(placement: .automatic, content: { EmptyView() })]
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
