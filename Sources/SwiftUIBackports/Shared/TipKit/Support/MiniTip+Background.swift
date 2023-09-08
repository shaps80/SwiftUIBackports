import SwiftUI
import SwiftBackports

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
extension View {
    @ViewBuilder
    func background(style: any ShapeStyle, color: Color, placement: Backport<Any>.TipViewStyleConfiguration.Placement) -> some View {
        backport.background {
            if #available(iOS 16.4, tvOS 16.4, macOS 13.3, watchOS 9.4, *) {
                Rectangle()
                    .foregroundStyle(placement == .inline ? AnyShapeStyle(style) : AnyShapeStyle(.clear))
#if os(iOS)
                    .presentationBackground(AnyShapeStyle(style))
#endif
                    .presentationCompactAdaptation(.popover)
            } else if #available(iOS 15, macOS 12, *) {
                Rectangle()
                    .foregroundStyle(AnyShapeStyle(style))
            } else {
                Rectangle()
                    .foregroundColor(color)
            }
        }
    }
}
