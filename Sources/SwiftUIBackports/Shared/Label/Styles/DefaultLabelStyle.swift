import SwiftUI

@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, deprecated: 14)
@available(watchOS, deprecated: 7)
extension Backport where Content == Any {

    /// The default label style in the current context.
    ///
    /// You can also use ``LabelStyle/automatic`` to construct this style.
    public struct DefaultLabelStyle: BackportLabelStyle {

        /// Creates an automatic label style.
        public init() { }

        /// Creates a view that represents the body of a label.
        ///
        /// The system calls this method for each ``Label`` instance in a view
        /// hierarchy where this style is the current label style.
        ///
        /// - Parameter configuration: The properties of the label.
        public func makeBody(configuration: DefaultLabelStyle.Configuration) -> some View {
            EmptyView()
        }

    }

}

@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, deprecated: 14)
@available(watchOS, deprecated: 7)
extension BackportLabelStyle where Self == Backport<Any>.DefaultLabelStyle {

    /// A label style that resolves its appearance automatically based on the
    /// current context.
    public static var automatic: Self { .init() }

}
