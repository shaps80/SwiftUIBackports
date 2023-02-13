import SwiftBackports

#if os(iOS)
import UIKit

internal extension UIApplication {
    static var activeScene: UIWindowScene? {
        shared.connectedScenes
            .first { $0.activationState == .foregroundActive }
        as? UIWindowScene
    }
}
#endif
