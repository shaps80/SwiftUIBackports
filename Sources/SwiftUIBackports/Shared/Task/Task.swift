import SwiftUI

@available(iOS, deprecated: 15.0)
@available(macOS, deprecated: 12.0)
@available(tvOS, deprecated: 15.0)
@available(watchOS, deprecated: 8.0)
public extension Backport where Wrapped: View {

    /// Adds an asynchronous task to perform when this view appears.
    ///
    /// Use this modifier to perform an asynchronous task with a lifetime that
    /// matches that of the modified view. If the task doesn't finish
    /// before SwiftUI removes the view or the view changes identity, SwiftUI
    /// cancels the task.
    ///
    /// Use the `await` keyword inside the task to
    /// wait for an asynchronous call to complete.
    ///
    ///     let url = URL(string: "https://example.com")!
    ///     @State private var message = "Loading..."
    ///
    ///     var body: some View {
    ///         Text(message)
    ///             .task {
    ///                 do {
    ///                     var receivedLines = [String]()
    ///                     for try await line in url.lines {
    ///                         receivedLines.append(line)
    ///                         message = "Received \(receivedLines.count) lines"
    ///                     }
    ///                 } catch {
    ///                     message = "Failed to load"
    ///                 }
    ///             }
    ///     }
    ///
    /// When each new line arrives, the body of the `for`-`await`-`in`
    /// loop stores the line in an array of strings and updates the content of the
    /// text view to report the latest line count.
    ///
    /// - Parameters:
    ///   - priority: The task priority to use when creating the asynchronous
    ///     task. The default priority is `.userInitiated`
    ///   - action: A closure that SwiftUI calls as an asynchronous task
    ///     when the view appears. SwiftUI automatically cancels the task
    ///     if the view disappears before the action completes.
    ///
    ///
    /// - Returns: A view that runs the specified action asynchronously when
    ///   the view appears.
    @ViewBuilder
    func task(priority: TaskPriority = .userInitiated, _ action: @MainActor @escaping @Sendable () async -> Void) -> some View {
        wrapped.modifier(
            TaskModifier(
                id: 0,
                priority: priority,
                action: action
            )
        )
    }

    /// Adds a task to perform when this view appears or when a specified
    /// value changes.
    ///
    /// This method behaves like ``View/task(priority:_:)``, except that it also
    /// cancels and recreates the task when a specified value changes. To detect
    /// a change, the modifier tests whether a new value for the `id` parameter
    /// equals the previous value. For this to work,
    /// the value's type must conform to the `Equatable` protocol.
    ///
    /// For example, if you define an equatable `Server` type that posts custom
    /// notifications whenever its state changes --- for example, from _signed
    /// out_ to _signed in_ --- you can use the task modifier to update
    /// the contents of a ``Text`` view to reflect the state of the
    /// currently selected server:
    ///
    ///     Text(status ?? "Signed Out")
    ///         .task(id: server) {
    ///             let sequence = NotificationCenter.default.notifications(
    ///                 named: .didChangeStatus,
    ///                 object: server)
    ///             for try await notification in sequence {
    ///                 status = notification.userInfo["status"] as? String
    ///             }
    ///         }
    ///
    /// Elsewhere, the server defines a custom `didUpdateStatus` notification:
    ///
    ///     extension NSNotification.Name {
    ///         static var didUpdateStatus: NSNotification.Name {
    ///             NSNotification.Name("didUpdateStatus")
    ///         }
    ///     }
    ///
    /// The server then posts a notification of this type whenever its status
    /// changes, like after the user signs in:
    ///
    ///     let notification = Notification(
    ///         name: .didUpdateStatus,
    ///         object: self,
    ///         userInfo: ["status": "Signed In"])
    ///     NotificationCenter.default.post(notification)
    ///
    /// The task attached to the ``Text`` view gets and displays the status
    /// value from the notification's user information dictionary. When the user
    /// chooses a different server, SwiftUI cancels the task and creates a new
    /// one, which then starts waiting for notifications from the new server.
    ///
    /// - Parameters:
    ///   - id: The value to observe for changes. The value must conform
    ///     to the `Equatable` protocol.
    ///   - priority: The task priority to use when creating the asynchronous
    ///     task. The default priority is `.userInitiated`
    ///   - action: A closure that SwiftUI calls as an asynchronous task
    ///     when the view appears. SwiftUI automatically cancels the task
    ///     if the view disappears before the action completes. If the
    ///     `id` value changes, SwiftUI cancels and restarts the task.
    ///
    /// - Returns: A view that runs the specified action asynchronously when
    ///   the view appears, or restarts the task with the `id` value changes.
    @ViewBuilder
    func task<T: Equatable>(id: T, priority: TaskPriority = .userInitiated, _ action: @MainActor @escaping @Sendable () async -> Void) -> some View {
        wrapped.modifier(
            TaskModifier(
                id: id,
                priority: priority,
                action: action
            )
        )
    }

}

private struct TaskModifier<ID: Equatable>: ViewModifier {

    var id: ID
    var priority: TaskPriority
    var action: () async -> Void

    @State private var task: Task<Void, Never>?

    init(id: ID, priority: TaskPriority, action: @MainActor @escaping () async -> Void) {
        self.id = id
        self.priority = priority
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .backport.onChange(of: id) { _ in
                task?.cancel()
                task = Task(priority: priority) {
                    await action()
                }
            }
            .onAppear {
                task?.cancel()
                task = Task(priority: priority) {
                    await action()
                }
            }
            .onDisappear {
                task?.cancel()
                task = nil
            }
    }

}
