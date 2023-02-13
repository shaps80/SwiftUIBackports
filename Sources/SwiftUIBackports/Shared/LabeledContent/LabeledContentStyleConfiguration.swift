import SwiftUI
import SwiftBackports

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
extension Backport where Wrapped == Any {

    /// The properties of a labeled content instance.
    public struct LabeledContentStyleConfiguration {
        private struct Label<Content: View>: View {
            let isHidden: Bool
            let content: Content

            public var body: some View {
                if !isHidden {
                    content
                }
            }
        }

        var labelHidden: Bool = false

        private let _label: AnyView

        /// The label of the labeled content instance.
        public var label: some View {
            Label(isHidden: labelHidden, content: _label)
        }

        /// The content of the labeled content instance.
        public let content: AnyView

        internal init<L: View, C: View>(label: L, content: C) {
            _label = .init(label)
            self.content = .init(content)
        }

        func labelHidden(_ hidden: Bool) -> Self {
            var copy = self
            copy.labelHidden = hidden
            return copy
        }
    }

}
