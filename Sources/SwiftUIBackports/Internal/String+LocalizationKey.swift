import SwiftUI
import SwiftBackports

extension String {
    internal init?(_ stringKey: LocalizedStringKey) {
        guard let key = Mirror(reflecting: stringKey).children
            .first(where: { $0.label == "key" })?.value as? String else {
            return nil
        }

        self = NSLocalizedString(key, comment: "")
    }
}
