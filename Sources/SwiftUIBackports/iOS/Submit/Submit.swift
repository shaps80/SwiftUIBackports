import SwiftUI
import SwiftBackports

#if os(iOS)
@available(iOS, deprecated: 15)
public extension Backport where Wrapped: View {
    /// Adds an action to perform when the user submits a value to this view.
    ///
    /// Different views may have different triggers for the provided action. A TextField, or SecureField will trigger this action when the user hits the hardware or software return key. This modifier may also bind this action to a default action keyboard shortcut. You may set this action on an individual view or an entire view hierarchy.
    ///
    ///     TextField("Username", text: $username)
    ///         .backport.onSubmit {
    ///             guard viewModel.validate() else { return }
    ///             viewModel.login()
    ///         }
    ///
    @ViewBuilder
    func onSubmit(_ action: @escaping () -> Void) -> some View {
        Group {
            if #available(iOS 15, *) {
                wrapped
                    .onSubmit(action)
            } else {
                wrapped
                    .modifier(SubmitModifier())
                    .environment(\.backportSubmit, .init(submit: action))
            }
        }
    }

    /// A semantic label describing the label of submission within a view hierarchy.
    ///
    /// A submit label is a description of a submission action provided to a
    /// view hierarchy using the ``View/backport.onSubmit(of:_:)`` modifier.
    @ViewBuilder
    func submitLabel(_ label: Backport<Any>.SubmitLabel) -> some View {
        Group {
            if #available(iOS 15, *) {
                wrapped
                    .submitLabel(.init(label))
            } else {
                wrapped
            }
        }
        .modifier(SubmitModifier())
        .environment(\.backportSubmitLabel, label)
    }
}

public extension Backport where Wrapped == Any {
    /// A semantic label describing the label of submission within a view hierarchy.
    ///
    /// A submit label is a description of a submission action provided to a
    /// view hierarchy using the ``View/onSubmit(of:_:)`` modifier.
    struct SubmitLabel: Equatable {
        internal let returnKeyType: UIReturnKeyType
        fileprivate init(_ type: UIReturnKeyType) {
            returnKeyType = type
        }
    }
}

@available(iOS 15, *)
private extension SwiftUI.SubmitLabel {
    init(_ label: Backport<Any>.SubmitLabel) {
        switch label {
        case .continue: self = .continue
        case .done: self = .done
        case .go: self = .go
        case .join: self = .join
        case .next: self = .next
        case .return: self = .return
        case .route: self = .route
        case .search: self = .search
        case .send: self = .send
        default: self = .return
        }
    }
}

public extension Backport.SubmitLabel {
    /// Defines a submit label with text of "Continue".
    static var `continue`: Self { .init(.continue) }
    /// Defines a submit label with text of "Done".
    static var done: Self { .init(.done) }
    /// Defines a submit label with text of "Go".
    static var go: Self { .init(.go) }
    /// Defines a submit label with text of "Join".
    static var join: Self { .init(.join) }
    /// Defines a submit label with text of "Next".
    static var next: Self { .init(.next) }
    /// Defines a submit label with text of "Return".
    static var `return`: Self { .init(.default) }
    /// Defines a submit label with text of "Route".
    static var route: Self { .init(.route) }
    /// Defines a submit label with text of "Search".
    static var search: Self { .init(.search) }
    /// Defines a submit label with text of "Send".
    static var send: Self { .init(.send) }
}

internal struct SubmitAction {
    let submit: () -> Void
    func callAsFunction() { submit() }
}

private struct SubmitEnvironmentKey: EnvironmentKey {
    static var defaultValue: SubmitAction = .init(submit: { })
}

internal extension EnvironmentValues {
    var backportSubmit: SubmitAction {
        get { self[SubmitEnvironmentKey.self] }
        set { self[SubmitEnvironmentKey.self] = newValue }
    }
}

private struct SubmitLabelEnvironmentKey: EnvironmentKey {
    static var defaultValue: Backport.SubmitLabel = .return
}

internal extension EnvironmentValues {
    var backportSubmitLabel: Backport<Any>.SubmitLabel {
        get { self[SubmitLabelEnvironmentKey.self] }
        set { self[SubmitLabelEnvironmentKey.self] = newValue }
    }
}

private struct SubmitModifier: ViewModifier {
    @Environment(\.backportSubmit) private var submit
    @Environment(\.backportSubmitLabel) private var label

    @Backport.StateObject private var coordinator: Coordinator = .init()

    func body(content: Content) -> some View {
        content
            .inspect { inspector in
                inspector.any(ofType: UITextView.self)
            } customize: { view in
                view.returnKeyType = label.returnKeyType
            }
            .inspect { inspector in
                inspector.any(ofType: UITextField.self)
            } customize: { view in
                view.returnKeyType = label.returnKeyType
                coordinator.onReturn = { submit() }
                coordinator.observe(view: view)
            }
    }

    final class Coordinator: NSObject, ObservableObject {
        private(set) weak var field: UITextField?

        var onReturn: () -> Void = { }
        @objc private func didReturn() { onReturn() }

        override init() { }

        func observe(view: UITextField) {
            view.addTarget(self, action: #selector(didReturn), for: .editingDidEndOnExit)
        }
    }
}
#endif
