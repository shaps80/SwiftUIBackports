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

public extension String {
    /// True if this string names a valid SF Symbol
    var isSFSymbol: Bool {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIImage(systemName: self) != nil
        #elseif os(macOS)
        return (NSImage(systemSymbolName: self, accessibilityDescription: nil) != nil)
        #else
        return false
        #endif
    }

    /// True if this string names a valid image in your asset catalog
    var isAssetImage: Bool {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIImage(named: self) != nil
        #elseif os(macOS)
        return (NSImage(named: NSImage.Name(self)) != nil)
        #else
        return false
        #endif
    }
}
