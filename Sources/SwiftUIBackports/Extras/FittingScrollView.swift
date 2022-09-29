import SwiftUI

/// A scrollview that behaves more similarly to a `VStack` when its content size is small enough.
public struct FittingScrollView<Content: View>: View {
    private let content: Content
    private let showsIndicators: Bool

    /// A new scrollview
    /// - Parameters:
    ///   - showsIndicators: If true, the scroll view will show indicators when necessary
    ///   - content: The content for this scroll view
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
