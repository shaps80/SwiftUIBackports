import SwiftUI

/// A geometry reader that automatically sizes its height to 'fit' its content.
public struct FittingGeometryReader<Content>: View where Content: View {

    @State private var height: CGFloat = 10 // must be non-zero
    private var content: (GeometryProxy) -> Content

    public init(@ViewBuilder content: @escaping (GeometryProxy) -> Content) {
        self.content = content
    }

    public var body: some View {
        GeometryReader { geo in
            content(geo)
                .fixedSize(horizontal: false, vertical: true)
                .modifier(SizeModifier())
                .onPreferenceChange(SizePreferenceKey.self) {
                    height = $0.height
                }
        }
        .frame(height: height)
    }

}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

private struct SizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.overlay(
            GeometryReader { geo in
                Color.clear.preference(
                    key: SizePreferenceKey.self,
                    value: geo.size
                )
            }
        )
    }
}
