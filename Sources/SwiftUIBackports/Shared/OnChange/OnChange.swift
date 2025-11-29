import SwiftUI
import SwiftBackports
import Combine

public extension Backport where Wrapped: View {

    /// Adds a modifier for this view that fires an action when a specific
    /// value changes.
    ///
    /// `onChange` is called on the main thread. Avoid performing long-running
    /// tasks on the main thread. If you need to perform a long-running task in
    /// response to `value` changing, you should dispatch to a background queue.
    ///
    /// The new value is passed into the closure.
    ///
    /// - Parameters:
    ///   - value: The value to observe for changes
    ///   - action: A closure to run when the value changes.
    ///   - newValue: The new value that changed
    ///
    /// - Returns: A view that fires an action when the specified value changes.
    /// @available(iOS, deprecated: 14.0, message: "Use View.onChange instead")
    @available(iOS, deprecated: 14.0, message: "Use View.onChange instead")
    @available(tvOS, deprecated: 14.0, message: "Use View.onChange instead")
    @available(macOS, deprecated: 11.0, message: "Use View.onChange instead")
    @available(watchOS, deprecated: 7.0, message: "Use View.onChange instead")
    func onChange<Value: Equatable>(of value: Value, perform action: @escaping (Value) -> Void) -> some View {
        wrapped.modifier(
            ChangeModifier(
                value: value,
                action: { _, newValue in
                    action(newValue)
                }
            )
        )
    }

    /// Adds a modifier for this view that fires an action when a specific
    /// value changes.
    ///
    /// You can use `onChange` to trigger a side effect as the result of a
    /// value changing, such as an `Environment` key or a `Binding`.
    ///
    /// The system may call the action closure on the main actor, so avoid
    /// long-running tasks in the closure. If you need to perform such tasks,
    /// detach an asynchronous background task.
    ///
    /// When the value changes, the new version of the closure will be called,
    /// so any captured values will have their values from the time that the
    /// observed value has its new value. The old and new observed values are
    /// passed into the closure. In the following code example, `PlayerView`
    /// passes both the old and new values to the model.
    ///
    ///     struct PlayerView: View {
    ///         var episode: Episode
    ///         @State private var playState: PlayState = .paused
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Text(episode.title)
    ///                 Text(episode.showTitle)
    ///                 PlayButton(playState: $playState)
    ///             }
    ///             .backport.onChange(of: playState) { oldState, newState in
    ///                 model.playStateDidChange(from: oldState, to: newState)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether
    ///     to run the closure.
    ///   - initial: Whether the action should be run when this view initially
    ///     appears.
    ///   - action: A closure to run when the value changes.
    ///   - oldValue: The old value that failed the comparison check (or the
    ///     initial value when requested).
    ///   - newValue: The new value that failed the comparison check.
    ///
    /// - Returns: A view that fires an action when the specified value changes.
    @available(iOS, deprecated: 17.0, message: "Use View.onChange instead")
    @available(tvOS, deprecated: 17.0, message: "Use View.onChange instead")
    @available(macOS, deprecated: 14.0, message: "Use View.onChange instead")
    @available(watchOS, deprecated: 10.0, message: "Use View.onChange instead")
    func onChange<V>(of value: V, initial: Bool = false, _ action: @escaping (_ oldValue: V, _ newValue: V) -> Void) -> some View where V: Equatable {
        wrapped.modifier(
            ChangeModifier(
                value: value,
                action: action
            )
        )
    }
}

private struct ChangeModifier<Value: Equatable>: ViewModifier {
    let value: Value
    let action: (Value, Value) -> Void

    @State var oldValue: Value?

    init(value: Value, action: @escaping (Value, Value) -> Void) {
        self.value = value
        self.action = action
        _oldValue = .init(initialValue: value)
    }

    func body(content: Content) -> some View {
        content
            .onReceive(Just(value)) { newValue in
                guard newValue != oldValue else { return }
                action(oldValue ?? value, newValue)
                oldValue = newValue
            }
    }
}
