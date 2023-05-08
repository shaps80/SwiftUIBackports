import SwiftUI
import SwiftBackports

#if os(iOS)
extension Backport where Wrapped: View {
    func textInputAutocapitalization(_ autocapitalization: Backport<Any>.TextInputAutocapitalization?) -> some View {
        wrapped.modifier(
            AutoCapitalizationModifier(
                capitalization: autocapitalization?.capitalization ?? .none
            )
        )
    }
}

@available(iOS, introduced: 13, deprecated: 15)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Backport<Any> {
    public struct TextInputAutocapitalization {
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

        public init?(_ type: UITextAutocapitalizationType) {
            self.capitalization = type
        }
    }
}

private struct AutoCapitalizationModifier: ViewModifier {
    let capitalization: UITextAutocapitalizationType

    func body(content: Content) -> some View {
        content
            .inspect { inspector in
                inspector.ancestor(ofType: UITextField.self)
            } customize: { view in
                view.autocapitalizationType = capitalization
            }
            .inspect { inspector in
                inspector.ancestor(ofType: UITextView.self)
            } customize: { view in
                view.autocapitalizationType = capitalization
            }
    }
}
#endif
