import SwiftUI

@available(iOS, deprecated: 15)
@available(tvOS, deprecated: 15)
@available(macOS, deprecated: 12)
@available(watchOS, deprecated: 8)
extension Backport where Content == Any {

    /// A container view that you can use to add hierarchy to certain collection views.
    ///
    /// Use `Section` instances in views like ``List``, ``Picker``, and
    /// ``Form`` to organize content into separate sections. Each section has
    /// custom content that you provide on a per-instance basis. You can also
    /// provide headers and footers for each section.
    public struct Section<P: View, C: View, F: View>: View {
        @ViewBuilder let content: () -> C
        @ViewBuilder let header: () -> P
        @ViewBuilder let footer: () -> F

        public var body: some View {
            SwiftUI.Section(
                content: content,
                header: header,
                footer: footer
            )
        }
    }

}

extension Backport.Section where Content == Any, P == Text, F == EmptyView {

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - titleKey: The key for the section's localized title, which describes
    ///     the contents of the section.
    ///   - content: The section's content.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: @escaping () -> C) {
        self.header = { Text(titleKey) }
        self.content = content
        self.footer = { EmptyView() }
    }

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - title: A string that describes the contents of the section.
    ///   - content: The section's content.
    public init<S>(_ title: S, @ViewBuilder content: @escaping () -> C) where S: StringProtocol {
        self.header = { Text(title) }
        self.content = content
        self.footer = { EmptyView() }
    }

}
