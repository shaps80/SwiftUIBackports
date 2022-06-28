import SwiftUI

@available(iOS, introduced: 13, deprecated: 14)
@available(watchOS, introduced: 6, deprecated: 7)
@available(tvOS, introduced: 13, deprecated: 14)
public extension Backport where Content: View {

    @ViewBuilder
    func navigationTitle<S: StringProtocol>(_ title: S) -> some View {
        content.navigationBarTitle(title)
    }

    @ViewBuilder
    func navigationTitle(_ titleKey: LocalizedStringKey) -> some View {
        content.navigationBarTitle(titleKey)
    }

}
