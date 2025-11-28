import SwiftBackports
import SwiftUI

@available(iOS, unavailable, message: "This has been moved to SwiftUIPlus and renamed to VScrollStack. You should move to the new package which automatically includes all backports as well 👍", renamed: "VScrollStack")
@available(macOS, unavailable, message: "This has been moved to SwiftUIPlus and renamed to VScrollStack. You should move to the new package which automatically includes all backports as well 👍", renamed: "VScrollStack")
@available(tvOS, unavailable, message: "This has been moved to SwiftUIPlus and renamed to VScrollStack. You should move to the new package which automatically includes all backports as well 👍", renamed: "VScrollStack")
@available(watchOS, unavailable, message: "This has been moved to SwiftUIPlus and renamed to VScrollStack. You should move to the new package which automatically includes all backports as well 👍", renamed: "VScrollStack")
public struct FittingScrollView<Content: View>: View {
    private let content: Content
    private let showsIndicators: Bool

    public init(showsIndicators: Bool = true, @ViewBuilder content: () -> Content) {
        self.showsIndicators = showsIndicators
        self.content = content()
    }

    public var body: some View {
        GeometryReader { geo in
            SwiftUI.ScrollView(showsIndicators: showsIndicators) {
                VStack(spacing: 10) {
                    content
                }
                .frame(
                    maxWidth: geo.size.width,
                    minHeight: geo.size.height
                )
            }
        }
    }
}
