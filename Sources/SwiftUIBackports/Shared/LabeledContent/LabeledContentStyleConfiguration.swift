import SwiftUI

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
extension Backport where Wrapped == Any {

    /// The properties of a labeled content instance.
    public struct LabeledContentStyleConfiguration {

        /// A type-erased label of a labeled content instance.
        public struct Label: View {
            @EnvironmentContains(key: "LabelsHiddenKey") private var isHidden
            let view: AnyView
            public var body: some View {
                if isHidden {
                    EmptyView()
                } else {
                    view
                }
            }
            init<V: View>(_ view: V) {
                self.view = .init(view)
            }
        }

        /// A type-erased content of a labeled content instance.
        public struct Content: View {
            @EnvironmentContains(key: "LabelsHiddenKey") private var isHidden
            let view: AnyView
            public var body: some View {
                view
                    .foregroundColor(isHidden ? .primary : .secondary)
                    .frame(maxWidth: .infinity, alignment: isHidden ? .leading : .trailing)
            }
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
