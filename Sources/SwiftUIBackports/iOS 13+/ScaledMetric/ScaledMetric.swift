import SwiftUI

@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, deprecated: 14)
@available(watchOS, deprecated: 7)
extension Backport where Content == Any {

    /// A dynamic property that scales a numeric value.
    @propertyWrapper
    public struct ScaledMetric<Value>: DynamicProperty where Value: BinaryFloatingPoint {

        @Environment(\.sizeCategory) var sizeCategory

        private let baseValue: Value
        private let metrics: UIFontMetrics

        public var wrappedValue: Value {
            #if os(iOS) || os(tvOS)
            let traits = UITraitCollection(traitsFrom: [
                UITraitCollection(preferredContentSizeCategory: UIContentSizeCategory(sizeCategory: sizeCategory))
            ])

            return Value(metrics.scaledValue(for: CGFloat(baseValue), compatibleWith: traits))
            #else
            return baseValue
            #endif
        }

        /// Creates the scaled metric with an unscaled value using the default scaling.
        public init(baseValue: Value, metrics: UIFontMetrics) {
            self.baseValue = baseValue
            self.metrics = metrics
        }

        /// Creates the scaled metric with an unscaled value using the default scaling.
        public init(wrappedValue: Value) {
            self.init(baseValue: wrappedValue, metrics: UIFontMetrics(forTextStyle: .body))
        }

        /// Creates the scaled metric with an unscaled value and a text style to scale relative to.
        public init(wrappedValue: Value, relativeTo textStyle: UIFont.TextStyle) {
            self.init(baseValue: wrappedValue, metrics: UIFontMetrics(forTextStyle: textStyle))
        }

    }

}

#if os(iOS) || os(tvOS)
private extension UIContentSizeCategory {
    init(sizeCategory: ContentSizeCategory?) {
        switch sizeCategory {
        case .accessibilityExtraExtraExtraLarge: self = .accessibilityExtraExtraExtraLarge
        case .accessibilityExtraExtraLarge: self = .accessibilityExtraExtraLarge
        case .accessibilityExtraLarge: self = .accessibilityExtraLarge
        case .accessibilityLarge: self = .accessibilityLarge
        case .accessibilityMedium: self = .accessibilityMedium
        case .extraExtraExtraLarge: self = .extraExtraExtraLarge
        case .extraExtraLarge: self = .extraExtraLarge
        case .extraLarge: self = .extraLarge
        case .extraSmall: self = .extraSmall
        case .large: self = .large
        case .medium: self = .medium
        case .small: self = .small
        default: self = .unspecified
        }
    }
}
#endif
