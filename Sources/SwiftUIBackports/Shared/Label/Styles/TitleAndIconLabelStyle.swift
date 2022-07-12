import SwiftUI

@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, deprecated: 14)
@available(watchOS, deprecated: 7)
extension Backport where Wrapped == Any {

    /// A label style that shows both the title and icon of the label using a
    /// system-standard layout.
    ///
    /// You can also use ``LabelStyle/titleAndIcon`` to construct this style.
    public struct TitleAndIconLabelStyle: BackportLabelStyle {

        /// Creates a label style that shows both the title and icon of the label
        /// using a system-standard layout.
        public init() { }

        /// Creates a view that represents the body of a label.
        ///
        /// The system calls this method for each ``Label`` instance in a view
        /// hierarchy where this style is the current label style.
        ///
        /// - Parameter configuration: The properties of the label.
        public func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.icon
                configuration.title
            }
        }

    }

}

@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, deprecated: 14)
@available(watchOS, deprecated: 7)
extension BackportLabelStyle where Self == Backport<Any>.TitleAndIconLabelStyle {

    /// A label style that shows both the title and icon of the label using a
    /// system-standard layout.
    ///
    /// In most cases, labels show both their title and icon by default. However,
    /// some containers might apply a different default label style to their
    /// content, such as only showing icons within toolbars on macOS and iOS. To
    /// opt in to showing both the title and the icon, you can apply the title
    /// and icon label style:
    ///
    ///     Label("Lightning", systemImage: "bolt.fill")
    ///         .labelStyle(.titleAndIcon)
    ///
    /// To apply the title and icon style to a group of labels, apply the style
    /// to the view hierarchy that contains the labels:
    ///
    ///     VStack {
    ///         Label("Rain", systemImage: "cloud.rain")
    ///         Label("Snow", systemImage: "snow")
    ///         Label("Sun", systemImage: "sun.max")
    ///     }
    ///     .labelStyle(.titleAndIcon)
    ///
    /// The relative layout of the title and icon is dependent on the context it
    /// is displayed in. In most cases, however, the label is arranged
    /// horizontally with the icon leading.
    public static var titleAndIcon: Self { .init() }

}
