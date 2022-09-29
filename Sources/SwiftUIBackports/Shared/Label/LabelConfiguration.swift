import SwiftUI

@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, deprecated: 14)
@available(watchOS, deprecated: 7)
extension Backport where Wrapped == Any {

    /// The properties of a label.
    public struct LabelStyleConfiguration {

        /// A description of the labeled item.
        public internal(set) var title: AnyView

        /// A symbolic representation of the labeled item.
        public internal(set) var icon: AnyView

        internal var environment: EnvironmentValues = .init()

        func environment(_ values: EnvironmentValues) -> Self {
            var config = self
            config.environment = values
            return config
        }

    }

}
