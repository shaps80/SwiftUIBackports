import SwiftUI
import SwiftBackports

@available(iOS, deprecated: 17, message: "Use SwiftUI.SensoryFeedback instead")
@available(tvOS, deprecated: 17, message: "Use SwiftUI.SensoryFeedback instead")
@available(macOS, deprecated: 14, message: "Use SwiftUI.SensoryFeedback instead")
@available(watchOS, deprecated: 10, message: "Use SwiftUI.SensoryFeedback instead")
extension Backport<Any> {
    public struct SensoryFeedback: Equatable, Sendable {
        enum Kind: Equatable, Sendable {
            case success
            case warning
            case error
            case selection
            case impact(Impact)
        }

        internal let kind: Kind
        internal let intensity: Double

        /// Indicates that a task or action has completed.
        ///
        /// Only plays feedback on iOS and watchOS.
        public static let success: SensoryFeedback = .init(
            kind: .success,
            intensity: 1
        )

        /// Indicates that a task or action has produced a warning of some kind.
        ///
        /// Only plays feedback on iOS and watchOS.
        public static let warning: SensoryFeedback = .init(
            kind: .warning,
            intensity: 1
        )

        /// Indicates that an error has occurred.
        ///
        /// Only plays feedback on iOS and watchOS.
        public static let error: SensoryFeedback = .init(
            kind: .error,
            intensity: 1
        )

        /// Indicates that a UI element’s values are changing.
        ///
        /// Equivalent to ``selection(_:)`` with ``SelectionFeedback/default``.
        ///
        /// Only plays feedback on iOS and watchOS.
        public static let selection: SensoryFeedback = .init(
            kind: .selection,
            intensity: 1
        )

        /// Provides a physical metaphor you can use to complement a visual
        /// experience.
        ///
        /// Use this to provide feedback for UI elements colliding. It should
        /// supplement the user experience, since only some platforms will play
        /// feedback in response to it.
        ///
        /// Only plays feedback on iOS and watchOS.
        public static let impact: SensoryFeedback = .init(
            kind: .impact(.medium),
            intensity: 1
        )

        /// Provides a physical metaphor you can use to complement a visual
        /// experience.
        ///
        /// Use this to provide feedback for UI elements colliding. It should
        /// supplement the user experience, since only some platforms will play
        /// feedback in response to it.
        ///
        /// Not all platforms will play different feedback for different weights and
        /// intensities of impact.
        ///
        /// Only plays feedback on iOS and watchOS.
        public static func impact(weight: SensoryFeedback.Weight = .medium, intensity: Double = 1.0) -> SensoryFeedback {
            .init(kind: .impact(weight.impact), intensity: intensity)
        }

        /// Provides a physical metaphor you can use to complement a visual
        /// experience.
        ///
        /// Use this to provide feedback for UI elements colliding. It should
        /// supplement the user experience, since only some platforms will play
        /// feedback in response to it.
        ///
        /// Not all platforms will play different feedback for different
        /// flexibilities and intensities of impact.
        ///
        /// Only plays feedback on iOS and watchOS.
        public static func impact(flexibility: SensoryFeedback.Flexibility, intensity: Double = 1.0) -> SensoryFeedback {
            .init(kind: .impact(flexibility.impact), intensity: intensity)
        }

        /// The weight to be represented by a type of feedback.
        ///
        /// `Weight` values can be passed to
        /// `SensoryFeedback.impact(weight:intensity:)`.
        public struct Weight: Equatable, Sendable {
            internal let impact: Impact

            /// Indicates a collision between small or lightweight UI objects.
            public static let light: SensoryFeedback.Weight = .init(impact: .light)

            /// Indicates a collision between medium-sized or medium-weight UI
            /// objects.
            public static let medium: SensoryFeedback.Weight = .init(impact: .medium)

            /// Indicates a collision between large or heavyweight UI objects.
            public static let heavy: SensoryFeedback.Weight = .init(impact: .heavy)
        }

        /// The flexibility to be represented by a type of feedback.
        ///
        /// `Flexibility` values can be passed to
        /// `SensoryFeedback.impact(flexibility:intensity:)`.
        public struct Flexibility: Equatable, Sendable {
            internal let impact: Impact

            /// Indicates a collision between hard or inflexible UI objects.
            public static let rigid: SensoryFeedback.Flexibility = .init(impact: .rigid)

            /// Indicates a collision between solid UI objects of medium
            /// flexibility.
            public static let solid: SensoryFeedback.Flexibility = .init(impact: .solid)

            /// Indicates a collision between soft or flexible UI objects.
            public static let soft: SensoryFeedback.Flexibility = .init(impact: .soft)
        }

        internal enum Impact {
            case light
            case medium
            case heavy
            case soft
            case solid
            case rigid
        }
    }
}
