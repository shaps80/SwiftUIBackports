import SwiftUI

@available(iOS, deprecated: 14)
@available(watchOS, deprecated: 7)
@available(tvOS, deprecated: 14)
@available(macOS)
public extension Backport where Content: View {

    @ViewBuilder
    func navigationTitle<S: StringProtocol>(_ title: S) -> some View {
        #if os(macOS)
        content.navigationTitle(title)
        #else
        content.navigationBarTitle(title)
        #endif
    }

    @ViewBuilder
    func navigationTitle(_ titleKey: LocalizedStringKey) -> some View {
        #if os(macOS)
        content.navigationTitle(titleKey)
        #else
        content.navigationBarTitle(titleKey)
        #endif
    }

}
#endif
