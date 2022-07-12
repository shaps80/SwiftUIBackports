import SwiftUI

@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, deprecated: 14)
@available(watchOS, deprecated: 7)
extension Backport where Wrapped == Any {

    // A label style that only displays the title of the label.
    ///
    /// You can also use ``LabelStyle/titleOnly`` to construct this style.
    public struct TitleOnlyLabelStyle: BackportLabelStyle {

        /// Creates a title-only label style.
        public init() { }

        /// Creates a view that represents the body of a label.
        ///
        /// The system calls this method for each ``Label`` instance in a view
        /// hierarchy where this style is the current label style.
        ///
        /// - Parameter configuration: The properties of the label.
        public func makeBody(configuration: Configuration) -> some View {
            configuration.title
        }

    }


}

@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, deprecated: 14)
@available(watchOS, deprecated: 7)
extension BackportLabelStyle where Self == Backport<Any>.TitleOnlyLabelStyle {

    /// A label style that only displays the title of the label.
    public static var titleOnly: Self { .init() }

}
