import SwiftUI

@available(iOS, deprecated: 14)
@available(watchOS, deprecated: 7)
@available(tvOS, deprecated: 14)
public extension Backport where Wrapped: View {

    @ViewBuilder
    func navigationTitle<S: StringProtocol>(_ title: S) -> some View {
        #if os(macOS)
        if #available(macOS 11, *) {
            content.navigationTitle(title)
        } else {
            content
        }
        #else
        content.navigationBarTitle(title)
        #endif
    }

    @ViewBuilder
    func navigationTitle(_ titleKey: LocalizedStringKey) -> some View {
        #if os(macOS)
        if #available(macOS 11, *) {
            content.navigationTitle(titleKey)
        } else {
            content
        }
        #else
        content.navigationBarTitle(titleKey)
        #endif
    }

}
