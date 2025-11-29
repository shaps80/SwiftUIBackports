import SwiftUI
import SwiftBackports
import CoreHaptics

internal struct SensoryFeedbackModifier<T: Equatable>: ViewModifier {
    var trigger: T
    var feedback: (_ oldValue: T, _ newValue: T) -> Backport<Any>.SensoryFeedback?
    var condition: (_ oldValue: T, _ newValue: T) -> Bool

    func body(content: Content) -> some View {
        content
#if os(iOS)
            .backport.onChange(of: trigger) { oldValue, newValue in
                guard condition(oldValue, newValue) else { return }
                guard let feedback = feedback(oldValue, newValue) else { return }

                switch feedback.kind {
                case .success:
                    let generator = UINotificationFeedbackGenerator()
                    generator.prepare()
                    generator.notificationOccurred(.success)
                case .warning:
                    let generator = UINotificationFeedbackGenerator()
                    generator.prepare()
                    generator.notificationOccurred(.warning)
                case .error:
                    let generator = UINotificationFeedbackGenerator()
                    generator.prepare()
                    generator.notificationOccurred(.error)
                case .selection:
                    let generator = UISelectionFeedbackGenerator()
                    generator.prepare()
                    generator.selectionChanged()
                case .impact(let impact):
                    let style: UIImpactFeedbackGenerator.FeedbackStyle

                    switch impact {
                    case .light: style = .light
                    case .medium: style = .medium
                    case .heavy: style = .heavy
                    case .soft: style = .soft
                    case .solid: style = .medium
                    case .rigid: style = .rigid
                    }

                    let generator = UIImpactFeedbackGenerator(style: style)
                    generator.prepare()
                    generator.impactOccurred(intensity: feedback.intensity)
                }
            }
#endif
    }
}
