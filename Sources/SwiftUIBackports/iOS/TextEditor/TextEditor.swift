import SwiftUI

#if os(iOS)
@available(iOS 14.0, *)

extension Backport where Wrapped == Any {

    /// A view that can display and edit long-form text.
    ///
    /// A text editor view allows you to display and edit multiline, scrollable text in your app’s user interface. By default, the text editor view styles the text using characteristics inherited from the environment, like font(_:), foregroundColor(_:), and multilineTextAlignment(_:).
    ///
    /// You create a text editor by adding a TextEditor instance to the body of your view, and initialize it by passing in a Binding to a string variable in your app.
    ///
    /// To style the text, use the standard view modifiers to configure a system font, set a custom font, or change the color of the view’s text.
    /// In this example, the view renders the editor’s text in gray with a custom font:
    ///
    ///     struct TextEditingView: View {
    ///         @State private var fullText: String = "This is some editable text..."
    ///
    ///         var body: some View {
    ///             TextEditor(text: $fullText)
    ///                .foregroundColor(Color.gray)
    ///                .font(.custom("HelveticaNeue", size: 13))
    ///                .lineSpacing(5)
    ///         }
    ///     }
    ///
    /// > The order of some modifiers matter with this implementation. PLEASE REPORT ISSUES ON THE REPO!
    ///
    /// Specifically, its recommended to place `foregroundColor` modifiers BEFORE `font` modifiers to ensure things work as expected.
    /// 
    public struct TextEditor: View {
        @Environment(\.self) private var environment
        @Binding var text: String

        /// Creates a plain text editor.
        ///
        /// Use a TextEditor instance to create a view in which users can enter and edit long-form text.
        /// In this example, the text editor renders gray text using the 13 point Helvetica Neue font with 5 points of spacing between each line:
        ///
        ///     struct TextEditingView: View {
        ///         @State private var fullText: String = "This is some editable text..."
        ///
        ///         var body: some View {
        ///             TextEditor(text: $fullText)
        ///                 .foregroundColor(Color.gray)
        ///                 .font(.custom("HelveticaNeue", size: 13))
        ///                 .lineSpacing(5)
        ///         }
        ///     }
        ///
        /// You can define the styling for the text within the view, including the text color, font, and line spacing. You define these styles by applying standard view modifiers to the view. The default text editor doesn’t support rich text, such as styling of individual elements within the editor’s view. The styles you set apply globally to all text in the view.
        ///
        /// - Parameter text: A `Binding` to the variable containing the text to edit.
        public init(text: Binding<String>) {
            _text = text
        }

        private var isAccented: Bool {
            guard let provider = colorProvider(from: environment) else { return false }
            return isAccentColor(provider: provider)
        }

        public var body: some View {
            Representable(parent: self)
                .blendMode(!environment.isEnabled && isAccented ? .luminosity: .normal)
        }

        struct Representable: UIViewRepresentable {
            let parent: TextEditor

            func makeCoordinator() -> Coordinator {
                .init(parent: parent)
            }

            func makeUIView(context: Context) -> UIView {
                context.coordinator.view
            }

            func updateUIView(_ view: UIView, context: Context) {
                context.coordinator.update(parent: parent)
            }
        }

        final class Coordinator: NSObject, UITextViewDelegate {
            let view = UITextView(frame: .zero)
            var parent: TextEditor

            init(parent: TextEditor) {
                self.parent = parent
            }

            func update(parent: TextEditor) {
                self.parent = parent
                guard view.text != parent.text else { return }

                view.delegate = self
                view.adjustsFontForContentSizeCategory = true
                view.autocapitalizationType = .allCharacters
                view.backgroundColor = .clear

                switch parent.environment.disableAutocorrection {
                case .some(true):
                    view.autocorrectionType = .yes
                case .some(false):
                    view.autocorrectionType = .no
                case nil:
                    view.autocorrectionType = .default
                }

                let style = NSMutableParagraphStyle()
                style.lineSpacing = parent.environment.lineSpacing
                style.alignment = parent.environment.multilineTextAlignment.nsTextAlignment

                view.textColor = resolveColor(parent.environment) ?? .label
                view.font = resolveFont(parent.environment.font ?? .body)?
                    .font(with: parent.environment.uiTraitCollection)
                ?? .preferredFont(forTextStyle: .body)

                view.typingAttributes = [
                    .paragraphStyle: style,
                    .foregroundColor: view.textColor ?? .label,
                    .font: view.font ?? .preferredFont(forTextStyle: .body)
                ]

                view.text = parent.text
            }

            func textViewDidChange(_ textView: UITextView) {
                DispatchQueue.main.async { [weak self] in
                    self?.parent.text = textView.text
                }
            }
        }
    }
}
#endif
