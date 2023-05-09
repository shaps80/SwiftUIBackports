import SwiftUI
import SwiftBackports

extension Backport<Any> {
    /// A control for navigating to a URL.
    ///
    /// Create a link by providing a destination URL and a title. The title
    /// tells the user the purpose of the link, and can be a string, a title
    /// key that produces a localized string, or a view that acts as a label.
    /// The example below creates a link to `example.com` and displays the
    /// title string as a link-styled view:
    ///
    ///     Backport.Link("View Our Terms of Service",
    ///           destination: URL(string: "https://www.example.com/TOS.html")!)
    ///
    /// When a user taps or clicks a `Link`, the default behavior depends on the
    /// contents of the URL. For example, SwiftUI opens a Universal Link in the
    /// associated app if possible, or in the user's default web browser if not.
    /// Alternatively, you can override the default behavior by setting the
    /// ``EnvironmentValues/openURL`` environment value with a custom
    /// ``OpenURLAction``:
    ///
    ///     Backport.Link("Visit Our Site", destination: URL(string: "https://www.example.com")!)
    ///         .environment(\.backportOpenURL, Backport.OpenURLAction { url in
    ///             print("Open \(url)")
    ///             return .handled
    ///         })
    ///
    /// As with other views, you can style links using standard view modifiers
    /// depending on the view type of the link's label. For example, a ``Text``
    /// label could be modified with a custom ``View/font(_:)`` or
    /// ``View/foregroundColor(_:)`` to customize the appearance of the link in
    /// your app's UI.
    @available(iOS, deprecated: 14)
    @available(tvOS, deprecated: 14)
    @available(macOS, deprecated: 11)
    @available(watchOS, deprecated: 7)
    public struct Link<Label>: View where Label: View {
        @Environment(\.backportOpenURL) private var openUrl
        let label: Label
        let destination: URL

        public var body: some View {
            Button {
                openUrl(destination)
            } label: {
                label
            }
            #if os(macOS)
            .buttonStyle(.link)
            #endif
        }

        /// Creates a control, consisting of a URL and a label, used to navigate
        /// to the given URL.
        ///
        /// - Parameters:
        ///     - destination: The URL for the link.
        ///     - label: A view that describes the destination of URL.
        public init(destination: URL, @ViewBuilder label: () -> Label) {
            self.destination = destination
            self.label = label()
        }
    }
}

extension Backport<Any>.Link where Label == Text {
    /// Creates a control, consisting of a URL and a title key, used to
    /// navigate to a URL.
    ///
    /// Use ``Link`` to create a control that your app uses to navigate to a
    /// URL that you provide. The example below creates a link to
    /// `example.com` and uses `Visit Example Co` as the title key to
    /// generate a link-styled view in your app:
    ///
    ///     Link("Visit Example Co",
    ///           destination: URL(string: "https://www.example.com/")!)
    ///
    /// - Parameters:
    ///     - titleKey: The key for the localized title that describes the
    ///       purpose of this link.
    ///     - destination: The URL for the link.
    public init(_ titleKey: LocalizedStringKey, destination: URL) {
        self.destination = destination
        self.label = Text(titleKey)
    }

    /// Creates a control, consisting of a URL and a title string, used to
    /// navigate to a URL.
    ///
    /// Use ``Link`` to create a control that your app uses to navigate to a
    /// URL that you provide. The example below creates a link to
    /// `example.com` and displays the title string you provide as a
    /// link-styled view in your app:
    ///
    ///     func marketingLink(_ callToAction: String) -> Link {
    ///         Link(callToAction,
    ///             destination: URL(string: "https://www.example.com/")!)
    ///     }
    ///
    /// - Parameters:
    ///     - title: A text string used as the title for describing the
    ///       underlying `destination` URL.
    ///     - destination: The URL for the link.
    public init<S>(_ title: S, destination: URL) where S: StringProtocol {
        self.destination = destination
        self.label = Text(title)
    }
}
