import SwiftUI

/// The requirements for an object that provides the configuration for a content view.
///
/// This protocol provides a blueprint for a content configuration object, which encompasses
/// default styling and content for a content view. The content configuration encapsulates
/// all of the supported properties and behaviors for content view customization.
/// You use the configuration to create the content view.
@available(iOS, deprecated: 14)
@available(tvOS, deprecated: 14)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public protocol BackportUIContentConfiguration {
    /// Initializes and returns a new instance of the content view using this configuration.
    func makeContentView() -> UIView
}
