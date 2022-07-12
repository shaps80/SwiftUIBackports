import SwiftUI

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
extension Backport where Wrapped == Any {

    /// A container for attaching a label to a value-bearing view.
    ///
    /// The instance's content represents a read-only or read-write value, and its
    /// label identifies or describes the purpose of that value.
    /// The resulting element has a layout that's consistent with other framework
    /// controls and automatically adapts to its container, like a form or toolbar.
    /// Some styles of labeled content also apply styling or behaviors to the value
    /// content, like making ``Text`` views selectable.
    ///
    /// The following example associates a label with a custom view and has
    /// a layout that matches the label of the ``Picker``:
    ///
    ///     Form {
    ///         Backport.LabeledContent("Custom Value") {
    ///             MyCustomView(value: $value)
    ///         }
    ///         Picker("Selected Value", selection: $selection) {
    ///             PickerOption("Option 1", 1)
    ///             PickerOption("Option 2", 2)
    ///         }
    ///     }
    ///
    /// ### Custom view labels
    ///
    /// You can assemble labeled content with an explicit view for its label
    /// using the ``init(content:label:)`` initializer. For example, you can
    /// rewrite the previous labeled content example using a ``Text`` view:
    ///
    ///     LabeledContent {
    ///         MyCustomView(value: $value)
    ///     } label: {
    ///         Text("Custom Value")
    ///     }
    ///
    /// The `label` view builder accepts any kind of view, like a ``Label``:
    ///
    ///     Backport.LabeledContent {
    ///         MyCustomView(value: $value)
    ///     } label: {
    ///         Label("Custom Value", systemImage: "hammer")
    ///     }
    ///
    /// ### Textual labeled content
    ///
    /// You can construct labeled content with string values or formatted values
    /// to create read-only displays of textual values:
    ///
    ///     Form {
    ///         Section("Information") {
    ///             Backport.LabeledContent("Name", value: person.name)
    ///         }
    ///         if !person.pets.isEmpty {
    ///             Section("Pets") {
    ///                 ForEach(pet) { pet in
    ///                     Backport.LabeledContent(pet.species, value: pet.name)
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// Wherever possible, SwiftUI makes this text selectable.
    ///
    /// ### Compositional elements
    ///
    /// You can use labeled content as the label for other elements. For example,
    /// a ``NavigationLink`` can present a summary value for the destination it
    /// links to:
    ///
    ///     Form {
    ///         NavigationLink(value: Settings.wifiDetail) {
    ///             Backport.LabeledContent("Wi-Fi", value: ssidName)
    ///         }
    ///     }
    ///
    /// In some cases, the styling of views used as the value content is
    /// specialized as well. For example, while a ``Toggle`` in an inset group
    /// form on macOS is styled as a switch by default, it's styled as a checkbox
    /// when used as a value element within a surrounding `LabeledContent`
    /// instance:
    ///
    ///     Form {
    ///         Backport.LabeledContent("Source Control") {
    ///             Toggle("Refresh local status automatically",
    ///                 isOn: $refreshLocalStatus)
    ///             Toggle("Fetch and refresh server status automatically",
    ///                 isOn: $refreshServerStatus)
    ///             Toggle("Add and remove files automatically",
    ///                 isOn: $addAndRemoveFiles)
    ///             Toggle("Select files to commit automatically",
    ///                 isOn: $selectFiles)
    ///         }
    ///     }
    ///
    /// ### Controlling label visibility
    ///
    /// A label communicates the identity or purpose of the value, which is
    /// important for accessibility. However, you might want to hide the label
    /// in the display, and some controls or contexts may visually hide their label
    /// by default. The ``View/labels(_:)`` modifier allows controlling that
    /// visibility. The following example hides both labels, producing only a
    /// group of the two value views:
    ///
    ///     Group {
    ///         LabeledContent("Custom Value") {
    ///             MyCustomView(value: $value)
    ///         }
    ///         Picker("Selected Value", selection: $selection) {
    ///             PickerOption("Option 1", 1)
    ///             PickerOption("Option 2", 2)
    ///         }
    ///     }
    ///     .labelsHidden()
    ///
    /// ### Styling labeled content
    ///
    /// You can set label styles using the ``View/labeledContentStyle(_:)``
    /// modifier. You can also build custom styles using ``LabeledContentStyle``.
    public struct LabeledContent<Label, Content> {
        @Environment(\.backportLabeledContentStyle) private var style
        let config: LabeledContentStyleConfiguration
        public var body: some View {
            style.makeBody(configuration: config)
        }
    }

}

extension Backport.LabeledContent where Wrapped == Any, Label == Backport<Any>.LabeledContentStyleConfiguration.Label, Content == Backport<Any>.LabeledContentStyleConfiguration.Content {

    /// Creates labeled content based on a labeled content style configuration.
    ///
    /// You can use this initializer within the
    /// ``LabeledContentStyle/makeBody(configuration:)`` method of a
    /// ``LabeledContentStyle`` to create a labeled content instance.
    /// This is useful for custom styles that only modify the current style,
    /// as opposed to implementing a brand new style.
    ///
    /// For example, the following style adds a red border around the labeled
    /// content, but otherwise preserves the current style:
    ///
    ///     struct RedBorderLabeledContentStyle: LabeledContentStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             LabeledContent(configuration)
    ///                 .border(.red)
    ///         }
    ///     }
    ///
    /// - Parameter configuration: The properties of the labeled content
    public init(_ config: Backport.LabeledContentStyleConfiguration) {
        self.config = config
    }
}

extension Backport.LabeledContent where Wrapped == Any, Label == Text, Content : View {

    /// Creates a labeled view that generates its label from a localized string
    /// key.
    ///
    /// This initializer creates a ``Text`` label on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// `Text` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the view's localized title, that describes
    ///     the purpose of the view.
    ///   - content: The value content being labeled.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        config = .init(
            label: Text(titleKey),
            content: content()
        )
    }

    /// Creates a labeled view that generates its label from a string.
    ///
    /// This initializer creates a ``Text`` label on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. See `Text` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the view.
    ///   - content: The value content being labeled.
    public init<S>(_ title: S, @ViewBuilder content: () -> Content) where S: StringProtocol {
        config = .init(
            label: Text(title),
            content: content()
        )
    }

}

extension Backport.LabeledContent: View where Wrapped == Any, Label: View, Content: View {

    /// Creates a labeled view that generates its label from a localized string
    /// key.
    ///
    /// This initializer creates a ``Text`` label on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// `Text` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the view's localized title, that describes
    ///     the purpose of the view.
    ///   - content: The value content being labeled.
    public init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
        config = .init(
            label: label(),
            content: content()
        )
    }

}

extension Backport.LabeledContent where Wrapped == Any, Label == Text, Content == Text {

    /// Creates a labeled informational view.
    ///
    /// This initializer creates a ``Text`` label on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// `Text` for more information about localizing strings.
    ///
    ///     Form {
    ///         LabeledContent("Name", value: person.name)
    ///     }
    ///
    /// In some contexts, this text will be selectable by default.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the view's localized title, that describes
    ///     the purpose of the view.
    ///   - value: The value being labeled.
    public init<S: StringProtocol>(_ titleKey: LocalizedStringKey, value: S) {
        config = .init(
            label: Text(titleKey),
            content: Text(value))
    }

    /// Creates a labeled informational view.
    ///
    /// This initializer creates a ``Text`` label on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. See `Text` for more
    /// information about localizing strings.
    ///
    ///     Form {
    ///         ForEach(person.pet) { pet in
    ///             LabeledContent(pet.species, value: pet.name)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the view.
    ///   - value: The value being labeled.
    public init<S1: StringProtocol, S2: StringProtocol>(_ title: S1, value: S2) {
        config = .init(
            label: Text(title),
            content: Text(value)
        )
    }

}
