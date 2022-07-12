import SwiftUI

extension Backport where Wrapped == Any {

    public struct LabeledContent<Label, Content> {
        @Environment(\.backportLabeledContentStyle) private var style
        let config: LabeledContentStyleConfiguration
        public var body: some View {
            style.makeBody(configuration: config)
        }
    }

}

//extension Backport.LabeledContent where Content == Any, Label == Backport<Any>.LabeledContentStyleConfiguration.Label, Content == Backport<Any>.LabeledContentStyleConfiguration.Content {
//    public init(_ config: Backport<Any>.LabeledContentStyleConfiguration) {
//        self.config = config
//    }
//}
//
//extension Backpot.LabeledContent Label == Text, Content : View {
//
//    /// Creates a labeled view that generates its label from a localized string
//    /// key.
//    ///
//    /// This initializer creates a ``Text`` label on your behalf, and treats the
//    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
//    /// `Text` for more information about localizing strings.
//    ///
//    /// - Parameters:
//    ///   - titleKey: The key for the view's localized title, that describes
//    ///     the purpose of the view.
//    ///   - content: The value content being labeled.
//    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
//        config = .init(
//            label: Text(titleKey),
//            content: content()
//        )
//    }
//
//    /// Creates a labeled view that generates its label from a string.
//    ///
//    /// This initializer creates a ``Text`` label on your behalf, and treats the
//    /// title similar to ``Text/init(_:)-9d1g4``. See `Text` for more
//    /// information about localizing strings.
//    ///
//    /// - Parameters:
//    ///   - title: A string that describes the purpose of the view.
//    ///   - content: The value content being labeled.
//    public init<S>(_ title: S, @ViewBuilder content: () -> Content) where S: StringProtocol {
//        config = .init(
//            label: Text(title),
//            content: content()
//        )
//    }
//
//}
//
//extension Backport.LabeledContent: View where Content == Any, Label: View, Content: View {
//
//    /// Creates a labeled view that generates its label from a localized string
//    /// key.
//    ///
//    /// This initializer creates a ``Text`` label on your behalf, and treats the
//    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
//    /// `Text` for more information about localizing strings.
//    ///
//    /// - Parameters:
//    ///   - titleKey: The key for the view's localized title, that describes
//    ///     the purpose of the view.
//    ///   - content: The value content being labeled.
//    public init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
//        config = .init(
//            label: label(),
//            content: content()
//        )
//    }
//
//}
//
//extension Backport.LabeledContent where Content == Any, Label == Text, Content == Text {
//
//    /// Creates a labeled informational view.
//    ///
//    /// This initializer creates a ``Text`` label on your behalf, and treats the
//    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
//    /// `Text` for more information about localizing strings.
//    ///
//    ///     Form {
//    ///         LabeledContent("Name", value: person.name)
//    ///     }
//    ///
//    /// In some contexts, this text will be selectable by default.
//    ///
//    /// - Parameters:
//    ///   - titleKey: The key for the view's localized title, that describes
//    ///     the purpose of the view.
//    ///   - value: The value being labeled.
//    init<S: StringProtocol>(_ titleKey: LocalizedStringKey, value: S) {
//        config = .init(
//            label: Text(titleKey),
//            content: Text(value))
//    }
//
//    /// Creates a labeled informational view.
//    ///
//    /// This initializer creates a ``Text`` label on your behalf, and treats the
//    /// title similar to ``Text/init(_:)-9d1g4``. See `Text` for more
//    /// information about localizing strings.
//    ///
//    ///     Form {
//    ///         ForEach(person.pet) { pet in
//    ///             LabeledContent(pet.species, value: pet.name)
//    ///         }
//    ///     }
//    ///
//    /// - Parameters:
//    ///   - title: A string that describes the purpose of the view.
//    ///   - value: The value being labeled.
//    init<S1: StringProtocol, S2: StringProtocol>(_ title: S1, value: S2) {
//        config = .init(
//            label: Text(title),
//            content: Text(value)
//        )
//    }
//
//}
