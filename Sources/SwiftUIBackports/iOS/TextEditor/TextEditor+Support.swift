import SwiftUI

#if os(iOS)
@available(iOS 15, *)
extension DynamicTypeSize {
    var uiContentSizeCategory: UIContentSizeCategory {
        switch self {
        case .xSmall: return .extraSmall
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        case .xLarge: return .extraLarge
        case .xxLarge: return .extraExtraLarge
        case .xxxLarge: return .extraExtraExtraLarge
        case .accessibility1: return .accessibilityMedium
        case .accessibility2: return .accessibilityLarge
        case .accessibility3: return .accessibilityExtraLarge
        case .accessibility4: return .accessibilityExtraExtraLarge
        case .accessibility5: return .accessibilityExtraExtraExtraLarge
        default: return .large
        }
    }
}

extension LayoutDirection {
    var uiLayoutDirection: UITraitEnvironmentLayoutDirection {
        switch self {
        case .leftToRight: return .leftToRight
        case .rightToLeft: return .rightToLeft
        default: return .leftToRight
        }
    }
}

extension TextAlignment {
    var nsTextAlignment: NSTextAlignment {
        switch self {
        case .leading: return .left
        case .center: return .center
        case .trailing: return .right
        }
    }
}

extension ContentSizeCategory {
    var uiContentSizeCategory: UIContentSizeCategory {
        switch self {
        case .extraSmall: return .extraSmall
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        case .extraLarge: return .extraLarge
        case .extraExtraLarge: return .extraExtraLarge
        case .extraExtraExtraLarge: return .extraExtraExtraLarge
        case .accessibilityMedium: return .accessibilityMedium
        case .accessibilityLarge: return .accessibilityLarge
        case .accessibilityExtraLarge: return .accessibilityExtraLarge
        case .accessibilityExtraExtraLarge: return .accessibilityExtraExtraLarge
        case .accessibilityExtraExtraExtraLarge: return .accessibilityExtraExtraExtraLarge
        default: return .large
        }
    }
}

extension EnvironmentValues {
    var uiTraitCollection: UITraitCollection {
        var traits: [UITraitCollection] = [
            .init(legibilityWeight: legibilityWeight?.uiLegibilityWeight ?? .unspecified),
            .init(layoutDirection: layoutDirection.uiLayoutDirection),
        ]

        if #available(iOS 15, *) {
            traits.append(.init(preferredContentSizeCategory: dynamicTypeSize.uiContentSizeCategory))
        } else {
            traits.append(.init(preferredContentSizeCategory: sizeCategory.uiContentSizeCategory))
        }

        return UITraitCollection(traitsFrom: traits)
    }
}
#endif
