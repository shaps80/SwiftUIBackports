import SwiftBackports

#if os(iOS)
import SwiftUI

public extension Backport<Any> {
    struct ToolbarPlacement: Hashable {
        enum Placement: Hashable {
            var id: Self { self }
            case bottomBar
            case navigationbar
            case tabBar
        }

        let placement: Placement

        /// The bottom toolbar of an app.
        @available(macOS, unavailable)
        public static var bottomBar: ToolbarPlacement {
            .init(placement: .bottomBar)
        }

        /// The navigation bar of an app.
        @available(macOS, unavailable)
        public static var navigationBar: ToolbarPlacement {
            .init(placement: .navigationbar)
        }

        /// The tab bar of an app.
        @available(macOS, unavailable)
        public static var tabBar: ToolbarPlacement {
            .init(placement: .tabBar)
        }
    }
}

@available(iOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public extension Backport where Wrapped: View {
    func toolbarBackground(_ visibility: Backport<Any>.Visibility, for bars: Backport<Any>.ToolbarPlacement...) -> some View {
        wrapped
            .modifier(ToolbarBackgroundModifier())
            .environment(\.toolbarVisibility, .init(
                navigationBar: bars.contains(.navigationBar) ? visibility : nil,
                bottomBar: bars.contains(.bottomBar) ? visibility : nil,
                tabBar: bars.contains(.tabBar) ? visibility : nil)
            )
    }

    func toolbarBackground<S>(_ style: S, for bars: Backport<Any>.ToolbarPlacement...) -> some View where S: ShapeStyle & View {
        wrapped
            .modifier(ToolbarBackgroundModifier())
            .environment(\.toolbarViews, .init(
                navigationBar: bars.contains(.navigationBar) ? .init(style) : nil,
                bottomBar: bars.contains(.bottomBar) ? .init(style) : nil,
                tabBar: bars.contains(.tabBar) ? .init(style) : nil)
            )
    }
}
#endif
