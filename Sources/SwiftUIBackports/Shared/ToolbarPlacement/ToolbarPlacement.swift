import SwiftUI

@available(iOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(tvOS, deprecated: 16)
@available(watchOS, deprecated: 9)
extension Backport {
    /// Use this type in conjunction with modifiers like View/toolbarBackground(_:for:) and toolbar(_:for:) to customize the appearance of different bars managed by SwiftUI. Not all bars support all types of customizations.
    /// See ToolbarItemPlacement to learn about the different regions of these toolbars that you can place your own controls into.
    public enum ToolbarPlacement: Hashable, CaseIterable {
        ///  The primary toolbar.
        case automatic
        /// The bottom toolbar of an app.
        case bottomBar
        /// The navigation bar of an app.
        case navigationBar
        ///  The tab bar of an app.
        case tabBar
        /// The window toolbar of an app.
        case windowToolbar
    }
}

@available(iOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
@available(tvOS, deprecated: 16)
public extension Backport where Wrapped: View {
    @ViewBuilder
    func toolbar(
        _ visibility: Backport<Any>.Visibility,
        for bars: Backport.ToolbarPlacement...
    ) -> some View {
        #if swift(>=5.7)    // hack for Xcode 13
        if #available(iOS 16.0, macOS 13.0, watchOS 9, tvOS 16, *) {
            if bars.contains(.automatic) {
                self.content.toolbar(.init(rawValue: visibility), for: .automatic)
            }
            #if os(macOS)
            if bars.contains(.windowToolbar) {
                self.content.toolbar(.init(rawValue: visibility), for: .windowToolbar)
            }
            #endif
            #if os(iOS)
            if bars.contains(.bottomBar) {
                self.content.toolbar(.init(rawValue: visibility), for: .bottomBar)
            }
            #endif
            #if os(iOS) || os(tvOS)
            if bars.contains(.tabBar) {
                self.content.toolbar(.init(rawValue: visibility), for: .tabBar)
            }
            #endif
            #if !os(macOS)
            if bars.contains(.navigationBar) {
                self.content.toolbar(.init(rawValue: visibility), for: .navigationBar)
            }
            #endif
        } else {
            self.content
        }
        #else
        self.content
        #endif
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension SwiftUI.Visibility {
    init(rawValue: Backport<Any>.Visibility) {
        switch rawValue {
        case .automatic:
            self = .automatic
        case .visible:
            self = .visible
        case .hidden:
            self = .hidden
        }
    }
}
