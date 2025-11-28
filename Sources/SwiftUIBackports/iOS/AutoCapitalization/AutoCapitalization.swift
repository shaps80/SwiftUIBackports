import SwiftUI
import SwiftBackports

#if os(iOS)
@available(iOS, deprecated: 15)
@MainActor
public extension Backport where Wrapped: View {
    /// Sets how often the shift key in the keyboard is automatically enabled.
    ///
    /// Use `backport.textInputAutocapitalization(_:)` when you need to automatically
    /// capitalize words, sentences, or other text like proper nouns.
    ///
    /// In example below, as the user enters text the shift key is
    /// automatically enabled before every word:
    ///
    ///     TextField("Last, First", text: $fullName)
    ///         .backport.textInputAutocapitalization(.words)
    ///
    /// The ``TextInputAutocapitalization`` struct defines the available
    /// autocapitalizing behavior. Providing `nil` to  this view modifier does
    /// not change the autocapitalization behavior. The default is
    /// `Backport<Any>.TextInputAutocapitalization.sentences`.
    ///
    /// - Parameter autocapitalization: One of the capitalizing behaviors
    /// defined in the `Backport<Any>.TextInputAutocapitalization` struct or nil.
    @ViewBuilder
    func textInputAutocapitalization(_ autocapitalization: Backport<Any>.TextInputAutocapitalization?) -> some View {
        Group {
            if #available(iOS 16, *) {
                wrapped.textInputAutocapitalization(textInputAutocapitalizationType(autocapitalization))
            } else {
                wrapped.modifier(
                    AutoCapitalizationModifier(
                        capitalization: autocapitalization?.capitalization ?? .none
                    )
                )
            }
        }
        .environment(\.textInputAutocapitalization, autocapitalization)
    }
    
    @available(iOS 16.0, *)
    private func textInputAutocapitalizationType(_ autocapitalization: Backport<Any>.TextInputAutocapitalization?) -> SwiftUI.TextInputAutocapitalization {
        switch autocapitalization {
        case .none:
            return .sentences
        case .some(let wrapped):
            switch wrapped {
            case .never: return .never
            case .words: return .words
            case .sentences: return .sentences
            case .characters: return .characters
            default: return .sentences
            }
        }
    }
}

@available(iOS, deprecated: 15)
extension Backport<Any> {
    /// The kind of autocapitalization behavior applied during text input.
    ///
    /// Pass an instance of `Backport<Any>.TextInputAutocapitalization` to the
    /// ``View/backport.textInputAutocapitalization(_:)`` view modifier.
    public struct TextInputAutocapitalization: Equatable {
        internal let capitalization: UITextAutocapitalizationType

        fileprivate init(capitalization: UITextAutocapitalizationType) {
            self.capitalization = capitalization
        }

        /// Defines an autocapitalizing behavior that will not capitalize anything.
        public static var never: TextInputAutocapitalization { .init(capitalization: .none) }

        /// Defines an autocapitalizing behavior that will capitalize the first
        /// letter of every word.
        public static var words: TextInputAutocapitalization { .init(capitalization: .words) }

        /// Defines an autocapitalizing behavior that will capitalize the first
        /// letter in every sentence.
        public static var sentences: TextInputAutocapitalization { .init(capitalization: .sentences) }

        /// Defines an autocapitalizing behavior that will capitalize every letter.
        public static var characters: TextInputAutocapitalization { .init(capitalization: .allCharacters) }

        /// Creates a new `Backport<Any>.TextInputAutocapitalization` struct from a
        /// `UITextAutocapitalizationType` enum.
        public init?(_ type: UITextAutocapitalizationType) {
            self.capitalization = type
        }
    }
}

@available(iOS, deprecated: 15)
private struct AutoCapitalizationModifier: ViewModifier {
    let capitalization: UITextAutocapitalizationType

    func body(content: Content) -> some View {
        content
            .any(forType: UITextField.self) { proxy in
                proxy.instance.autocapitalizationType = capitalization
            }
            .any(forType: UITextView.self) { proxy in
                proxy.instance.autocapitalizationType = capitalization
            }
    }
}

private struct AutoCapitalizationEnvironmentKey: EnvironmentKey {
    static var defaultValue: Backport<Any>.TextInputAutocapitalization? = .sentences
}

internal extension EnvironmentValues {
    var textInputAutocapitalization: Backport<Any>.TextInputAutocapitalization? {
        get { self[AutoCapitalizationEnvironmentKey.self] }
        set { self[AutoCapitalizationEnvironmentKey.self] = newValue }
    }
}
#endif
