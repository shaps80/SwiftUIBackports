import SwiftUI
import SwiftBackports

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
extension Backport where Wrapped: View {
    public func tipAssetSize(_ size: CGSize) -> some View {
        wrapped.environment(\.tipAssetSize, size)
    }

    public func tipCornerRadius(_ cornerRadius: Double, antialiased: Bool = true) -> some View {
        wrapped.environment(\.tipCorner, (cornerRadius, antialiased))
    }

    /// Sets the tip's view background to a style.
    ///
    /// - Parameters:
    ///   - style: An instance of a type that conforms to `ShapeStyle` that
    ///     SwiftUI draws behind the modified view.
    ///
    /// - Returns: A view with the specified style drawn behind it.
    @available(iOS 15, tvOS 15, macOS 12, watchOS 8, *)
    public func tipBackground(_ style: some ShapeStyle) -> some View {
        wrapped.environment(\.tipBackgroundStyle, style)
    }

    /// Sets the tip's view background to a color
    ///
    /// - Parameters:
    ///   - color: An instance of a color that SwiftUI draws behind the modified view.
    ///
    /// - Returns: A view with the specified color drawn behind it.
    @available(iOS, introduced: 13, deprecated: 15)
    @available(tvOS, introduced: 13, deprecated: 15)
    @available(macOS, introduced: 11, deprecated: 12)
    @available(watchOS, introduced: 6, deprecated: 8)
    public func tipBackground(color: Color) -> some View {
        wrapped.environment(\.tipBackgroundColor, color)
    }
}

private struct TipAssetSizeEnvironmentKey: EnvironmentKey {
    static var defaultValue: CGSize = .init(width: 44, height: 44)
}
internal extension EnvironmentValues {
    var tipAssetSize: CGSize {
        get { self[TipAssetSizeEnvironmentKey.self] }
        set { self[TipAssetSizeEnvironmentKey.self] = newValue }
    }
}

private struct TipCornerEnvironmentKey: EnvironmentKey {
    static var defaultValue: (radius: CGFloat, antialiased: Bool) = (13, true)
}
internal extension EnvironmentValues {
    var tipCorner: (radius: CGFloat, antialiased: Bool) {
        get { self[TipCornerEnvironmentKey.self] }
        set { self[TipCornerEnvironmentKey.self] = newValue }
    }
}

private struct TipBackgroundStyleEnvironmentKey: EnvironmentKey {
#if os(macOS)
    static var defaultValue: any ShapeStyle { Color.primary.opacity(0.055) }
#else
    static var defaultValue: any ShapeStyle { Color(.secondarySystemBackground) }
#endif
}
internal extension EnvironmentValues {
    var tipBackgroundStyle: any ShapeStyle {
        get { self[TipBackgroundStyleEnvironmentKey.self] }
        set { self[TipBackgroundStyleEnvironmentKey.self] = newValue }
    }
}

private struct TipBackgroundColorEnvironmentKey: EnvironmentKey {
#if os(macOS)
    static var defaultValue: Color { Color.primary.opacity(0.055) }
#else
    static var defaultValue: Color { Color(.secondarySystemBackground) }
#endif
}
internal extension EnvironmentValues {
    var tipBackgroundColor: Color {
        get { self[TipBackgroundColorEnvironmentKey.self] }
        set { self[TipBackgroundColorEnvironmentKey.self] = newValue }
    }
}

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
private struct TipStyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: any BackportTipViewStyle { Backport.MiniTipViewStyle() }
}

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
internal extension EnvironmentValues {
    var tipStyle: any BackportTipViewStyle {
        get { self[TipStyleEnvironmentKey.self] }
        set { self[TipStyleEnvironmentKey.self] = newValue }
    }
}
