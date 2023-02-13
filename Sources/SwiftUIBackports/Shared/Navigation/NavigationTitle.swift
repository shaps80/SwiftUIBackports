import SwiftUI

@available(iOS, deprecated: 14)
@available(watchOS, deprecated: 7)
@available(tvOS, deprecated: 14)
public extension Backport where Wrapped: View {

    @ViewBuilder
    func navigationTitle<S: StringProtocol>(_ title: S) -> some View {
        #if os(macOS)
        if #available(macOS 11, *) {
            wrapped.navigationTitle(title)
        } else {
            wrapped
        }
        #else
        wrapped.navigationBarTitle(title)
        #endif
    }

    @ViewBuilder
    func navigationTitle(_ titleKey: LocalizedStringKey) -> some View {
        #if os(macOS)
        if #available(macOS 11, *) {
            wrapped.navigationTitle(titleKey)
        } else {
            wrapped
        }
        #else
        wrapped.navigationBarTitle(titleKey)
        #endif
    }

}
