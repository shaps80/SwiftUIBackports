import SwiftUI

extension Backport where Wrapped == Any {

    /// The properties of a labeled content instance.
    public struct LabeledContentStyleConfiguration {

        /// A type-erased label of a labeled content instance.
        public struct Label: View {
            let view: AnyView
            public var body: some View { view }
            init<V: View>(_ view: V) {
                self.view = .init(view)
            }
        }

        /// A type-erased content of a labeled content instance.
        public struct Content: View {
            let view: AnyView
            public var body: some View { view }
            init<V: View>(_ view: V) {
                self.view = .init(view)
            }
        }

        /// The label of the labeled content instance.
        public let label: Label

        /// The content of the labeled content instance.
        public let content: Content

        internal init<L: View, C: View>(label: L, content: C) {
            self.label = .init(label)
            self.content = .init(content)
        }

        internal init<L: View, C: View>(@ViewBuilder content: () -> C, @ViewBuilder label: () -> L) {
            self.content = .init(content())
            self.label = .init(label())
        }

    }

}
