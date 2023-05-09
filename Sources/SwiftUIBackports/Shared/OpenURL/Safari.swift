import SwiftUI

#if canImport(SwiftUIPlus) && canImport(SafariServices)
import SafariServices

@available(iOS 15, macOS 12, *)
@MainActor
public extension OpenURLAction.Result {
    static func safari(_ url: URL) -> Self {
        _ = Backport<Any>.OpenURLAction.Result.safari(url)
        return .handled
    }
}

@MainActor
public extension Backport<Any>.OpenURLAction.Result {
    static func safari(_ url: URL) -> Self {
#if os(macOS)
        NSWorkspace.shared.open(url)
#elseif os(iOS)
        let scene = UIApplication.shared.connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
        let window = scene?.windows.first { $0.isKeyWindow }
        guard let root = window?.rootViewController else {
            UIApplication.shared.open(url)
            return .handled
        }

        let controller = SFSafariViewController(url: url)
        root.present(controller, animated: true)
#elseif os(tvOS)
        UIApplication.shared.open(url)
#else
        WKExtension.shared().openSystemURL(url)
#endif
        return .handled
    }
}
#endif
