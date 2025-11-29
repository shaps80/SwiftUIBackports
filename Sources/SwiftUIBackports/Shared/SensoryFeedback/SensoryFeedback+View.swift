import SwiftUI

extension Backport where Wrapped: View {
    /// Plays the specified `feedback` when the provided `trigger` value
    /// changes.
    ///
    /// For example, you could play feedback when a state value changes:
    ///
    ///     struct MyView: View {
    ///         @State private var showAccessory = false
    ///
    ///         var body: some View {
    ///             ContentView()
    ///                 .backport.sensoryFeedback(.selection, trigger: showAccessory)
    ///                 .onLongPressGesture {
    ///                     showAccessory.toggle()
    ///                 }
    ///
    ///             if showAccessory {
    ///                 AccessoryView()
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - feedback: Which type of feedback to play.
    ///   - trigger: A value to monitor for changes to determine when to play.
    nonisolated public func sensoryFeedback<T>(
        _ feedback: Backport<Any>.SensoryFeedback,
        trigger: T
    ) -> some View where T: Equatable {
        wrapped.modifier(
            SensoryFeedbackModifier(
                trigger: trigger,
                feedback: { _, _ in feedback },
                condition: { _, _ in true }
            )
        )
    }

    /// Plays the specified `feedback` when the provided `trigger` value changes
    /// and the `condition` closure returns `true`.
    ///
    /// For example, you could play feedback for certain state transitions:
    ///
    ///     struct MyView: View {
    ///         @State private var phase = Phase.inactive
    ///
    ///         var body: some View {
    ///             ContentView(phase: $phase)
    ///                 .backport.sensoryFeedback(.selection, trigger: phase) { old, new in
    ///                     old == .inactive || new == .expanded
    ///                 }
    ///         }
    ///
    ///         enum Phase {
    ///             case inactive
    ///             case preparing
    ///             case active
    ///             case expanded
    ///         }
    ///     }
    ///
    /// When the value changes, the new version of the closure will be called,
    /// so any captured values will have their values from the time that the
    /// observed value has its new value.
    ///
    /// - Parameters:
    ///   - feedback: Which type of feedback to play.
    ///   - trigger: A value to monitor for changes to determine when to play.
    ///   - condition: A closure to determine whether to play the feedback when
    ///     `trigger` changes.
    nonisolated public func sensoryFeedback<T>(
        _ feedback: Backport<Any>.SensoryFeedback,
        trigger: T,
        condition: @escaping (_ oldValue: T, _ newValue: T) -> Bool
    ) -> some View where T: Equatable {
        wrapped.modifier(
            SensoryFeedbackModifier(
                trigger: trigger,
                feedback: { _, _ in feedback },
                condition: condition
            )
        )
    }

    /// Plays feedback when returned from the `feedback` closure after the
    /// provided `trigger` value changes.
    ///
    /// For example, you could play different feedback for different state
    /// transitions:
    ///
    ///     struct MyView: View {
    ///         @State private var phase = Phase.inactive
    ///
    ///         var body: some View {
    ///             ContentView(phase: $phase)
    ///                 .backport.sensoryFeedback(trigger: phase) { old, new in
    ///                     switch (old, new) {
    ///                         case (.inactive, _): return .success
    ///                         case (_, .expanded): return .impact
    ///                         default: return nil
    ///                     }
    ///                 }
    ///         }
    ///
    ///         enum Phase {
    ///             case inactive
    ///             case preparing
    ///             case active
    ///             case expanded
    ///         }
    ///     }
    ///
    /// When the value changes, the new version of the closure will be called,
    /// so any captured values will have their values from the time that the
    /// observed value has its new value.
    ///
    /// - Parameters:
    ///   - trigger: A value to monitor for changes to determine when to play.
    ///   - feedback: A closure to determine whether to play the feedback and
    ///     what type of feedback to play when `trigger` changes.
    nonisolated public func sensoryFeedback<T>(
        trigger: T,
        _ feedback: @escaping (_ oldValue: T, _ newValue: T) -> Backport<Any>.SensoryFeedback?
    ) -> some View where T: Equatable {
        wrapped.modifier(
            SensoryFeedbackModifier(
                trigger: trigger,
                feedback: feedback,
                condition: { _, _ in true }
            )
        )
    }

    /// Plays feedback when returned from the `feedback` closure after the
    /// provided `trigger` value changes.
    ///
    /// For example, you could play different feedback for different state
    /// transitions:
    ///
    ///     struct MyView: View {
    ///         @State private var isExpanded = false
    ///
    ///         var body: some View {
    ///             ContentView(isExpanded: $isExpanded)
    ///                 .backport.sensoryFeedback(trigger: isExpanded) {
    ///                     isExpanded ? .impact : nil
    ///                 }
    ///         }
    ///     }
    ///
    /// When the value changes, the new version of the closure will be called,
    /// so any captured values will have their values from the time that the
    /// observed value has its new value.
    ///
    /// - Parameters:
    ///   - trigger: A value to monitor for changes to determine when to play.
    ///   - feedback: A closure to determine whether to play the feedback and
    ///     what type of feedback to play when `trigger` changes.
    nonisolated public func sensoryFeedback<T>(
        trigger: T,
        _ feedback: @escaping () -> Backport<Any>.SensoryFeedback?
    ) -> some View where T: Equatable {
        wrapped.modifier(
            SensoryFeedbackModifier(
                trigger: trigger,
                feedback: { _, _ in feedback() },
                condition: { _, _ in true }
            )
        )
    }
}
