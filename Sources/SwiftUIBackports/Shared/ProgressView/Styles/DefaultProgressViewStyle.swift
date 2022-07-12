import SwiftUI

@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, deprecated: 14.0)
@available(watchOS, deprecated: 7.0)
extension Backport where Wrapped == Any {

    /// The default progress view style in the current context of the view being
    /// styled.
    ///
    /// You can also use ``ProgressViewStyle/automatic`` to construct this style.
    public struct DefaultProgressViewStyle: BackportProgressViewStyle {

        /// Creates a default progress view style.
        public init() { }

        /// Creates a view representing the body of a progress view.
        ///
        /// - Parameter configuration: The properties of the progress view being
        ///   created.
        ///
        /// The view hierarchy calls this method for each progress view where this
        /// style is the current progress view style.
        ///
        /// - Parameter configuration: The properties of the progress view, such as
        ///  its preferred progress type.
        public func makeBody(configuration: Configuration) -> some View {
            switch configuration.preferredKind {
            case .circular:
                Backport.CircularProgressViewStyle().makeBody(configuration: configuration)
            case .linear:
                #if os(iOS)
                if configuration.fractionCompleted == nil {
                    Backport.CircularProgressViewStyle().makeBody(configuration: configuration)
                } else {
                    Backport.LinearProgressViewStyle().makeBody(configuration: configuration)
                }
                #else
                Backport.LinearProgressViewStyle().makeBody(configuration: configuration)
                #endif
            }
        }
    }

}

public extension BackportProgressViewStyle where Self == Backport<Any>.DefaultProgressViewStyle {
    static var automatic: Self { .init() }
}
