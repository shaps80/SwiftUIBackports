import SwiftUI
import StoreKit
import SwiftBackports

#if os(iOS) || os(macOS)
public extension EnvironmentValues {

    /// An instance that tells StoreKit to request an App Store rating or review from the user, if appropriate.
    /// Read the requestReview environment value to get an instance of this structure for a given Environment. Call the instance to tell StoreKit to ask the user to rate or review your app, if appropriate. You call the instance directly because it defines a callAsFunction() method that Swift calls when you call the instance.
    ///
    /// Although you normally call this instance to request a review when it makes sense in the user experience flow of your app, the App Store policy governs the actual display of the rating and review request view. Because calling this instance may not present an alert, don’t call it in response to a user action, such as a button tap.
    ///
    /// > When you call this instance while your app is in development mode, the system always displays a rating and review request view so you can test the user interface and experience. This instance has no effect when you call it in an app that you distribute using TestFlight.
    @MainActor var backportRequestReview: Backport<Any>.RequestReviewAction { .init() }

}

/// An instance that tells StoreKit to request an App Store rating or review from the user, if appropriate.
/// Read the requestReview environment value to get an instance of this structure for a given Environment. Call the instance to tell StoreKit to ask the user to rate or review your app, if appropriate. You call the instance directly because it defines a callAsFunction() method that Swift calls when you call the instance.
///
/// Although you normally call this instance to request a review when it makes sense in the user experience flow of your app, the App Store policy governs the actual display of the rating and review request view. Because calling this instance may not present an alert, don’t call it in response to a user action, such as a button tap.
///
/// > When you call this instance while your app is in development mode, the system always displays a rating and review request view so you can test the user interface and experience. This instance has no effect when you call it in an app that you distribute using TestFlight.
///
@available(iOS, deprecated: 16)
@available(macOS, deprecated: 13)
extension Backport where Wrapped == Any {
    @MainActor public struct RequestReviewAction {
        public func callAsFunction() {
            #if os(macOS)
            SKStoreReviewController.requestReview()
            #else
            if #available(iOS 14, *) {
                guard let scene = UIApplication.activeScene else { return }
                SKStoreReviewController.requestReview(in: scene)
            } else {
                SKStoreReviewController.requestReview()
            }
            #endif
        }
    }
}

#endif
