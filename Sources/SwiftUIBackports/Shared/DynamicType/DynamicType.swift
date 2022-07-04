import SwiftUI

@available(iOS, deprecated: 15)
@available(tvOS, deprecated: 15)
@available(macOS, deprecated: 12)
@available(watchOS, deprecated: 8)
extension Backport where Content == Any {

    /// A Dynamic Type size, which specifies how large scalable content should be.
    ///
    /// For more information about Dynamic Type sizes in iOS, see iOS Human Interface Guidelines >
    /// [Dynamic Type Sizes](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/#dynamic-type-sizes).
    /// For more information about Dynamic Type sizes in watchOS, see watchOS Human Interface Guidelines >
    /// [Dynamic Type Sizes](https://developer.apple.com/design/human-interface-guidelines/watchos/visual/typography/#dynamic-type-sizes).
    public enum DynamicTypeSize: Hashable, Comparable, CaseIterable {

        /// An extra small size.
        case xSmall

        /// A small size.
        case small

        /// A medium size.
        case medium

        /// A large size.
        case large

        /// An extra large size.
        case xLarge

        /// An extra extra large size.
        case xxLarge

        /// An extra extra extra large size.
        case xxxLarge

        /// The first accessibility size.
        case accessibility1

        /// The second accessibility size.
        case accessibility2

        /// The third accessibility size.
        case accessibility3

        /// The fourth accessibility size.
        case accessibility4

        /// The fifth accessibility size.
        case accessibility5

        /// A Boolean value indicating whether the size is one that is associated
        /// with accessibility.
        public var isAccessibilitySize: Bool {
            self >= .accessibility1
        }

        #if os(iOS) || os(tvOS)
        /// Create a Dynamic Type size from its `UIContentSizeCategory` equivalent.
        public init?(_ uiSizeCategory: UIContentSizeCategory) {
            switch uiSizeCategory {
            case .extraSmall:
                self = .xSmall
            case .small:
                self = .small
            case .medium:
                self = .medium
            case .large:
                self = .medium
            case .extraLarge:
                self = .xLarge
            case .extraExtraLarge:
                self = .xxLarge
            case .extraExtraExtraLarge:
                self = .xxxLarge
            case .accessibilityMedium:
                self = .accessibility1
            case .accessibilityLarge:
                self = .accessibility2
            case .accessibilityExtraLarge:
                self = .accessibility3
            case .accessibilityExtraExtraLarge:
                self = .accessibility4
            case .accessibilityExtraExtraExtraLarge:
                self = .accessibility5
            default:
                return nil
            }
        }
        #endif

        internal init(_ sizeCategory: ContentSizeCategory) {
            switch sizeCategory {
            case .extraSmall:
                self = .xSmall
            case .small:
                self = .small
            case .medium:
                self = .medium
            case .large:
                self = .large
            case .extraLarge:
                self = .xLarge
            case .extraExtraLarge:
                self = .xxLarge
            case .extraExtraExtraLarge:
                self = .xxxLarge
            case .accessibilityMedium:
                self = .accessibility1
            case .accessibilityLarge:
                self = .accessibility2
            case .accessibilityExtraLarge:
                self = .accessibility3
            case .accessibilityExtraExtraLarge:
                self = .accessibility4
            case .accessibilityExtraExtraExtraLarge:
                self = .accessibility5
            default:
                self = .large
            }
        }

        var sizeCategory: ContentSizeCategory {
            switch self {
            case .xSmall:
                return .extraSmall
            case .small:
                return .small
            case .medium:
                return .medium
            case .large:
                return .large
            case .xLarge:
                return .extraLarge
            case .xxLarge:
                return .extraExtraLarge
            case .xxxLarge:
                return .extraExtraExtraLarge
            case .accessibility1:
                return .accessibilityMedium
            case .accessibility2:
                return .accessibilityLarge
            case .accessibility3:
                return .accessibilityExtraLarge
            case .accessibility4:
                return .accessibilityExtraExtraLarge
            case .accessibility5:
                return .accessibilityExtraExtraExtraLarge
            }
        }

    }

}

@available(iOS 15, tvOS 15, macOS 12, watchOS 8, *)
internal extension Backport.DynamicTypeSize {

    var dynamicTypeSize: DynamicTypeSize {
        switch self {
        case .xSmall:
            return .xSmall
        case .small:
            return .small
        case .medium:
            return .medium
        case .large:
            return .large
        case .xLarge:
            return .xLarge
        case .xxLarge:
            return .xxLarge
        case .xxxLarge:
            return .xxxLarge
        case .accessibility1:
            return .accessibility1
        case .accessibility2:
            return .accessibility2
        case .accessibility3:
            return .accessibility3
        case .accessibility4:
            return .accessibility4
        case .accessibility5:
            return .accessibility5
        }
    }

}

#if os(iOS) || os(tvOS)
@available(iOS, deprecated: 15)
@available(tvOS, deprecated: 15)
extension UIContentSizeCategory {
    public init(_ dynamicTypeSize: Backport<Any>.DynamicTypeSize?) {
        switch dynamicTypeSize {
        case .xSmall:
            self = .extraSmall
        case .small:
            self = .small
        case .medium:
            self = .medium
        case .large:
            self = .large
        case .xLarge:
            self = .extraLarge
        case .xxLarge:
            self = .extraExtraLarge
        case .xxxLarge:
            self = .extraExtraExtraLarge
        case .accessibility1:
            self = .accessibilityMedium
        case .accessibility2:
            self = .accessibilityLarge
        case .accessibility3:
            self = .accessibilityExtraLarge
        case .accessibility4:
            self = .accessibilityExtraExtraLarge
        case .accessibility5:
            self = .accessibilityExtraExtraExtraLarge
        case .none:
            self = .large
        }
    }

}
#endif
