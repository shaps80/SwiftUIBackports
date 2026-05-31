import SwiftUI

#if os(iOS)

/// Clears the background color of the enclosing `UIHostingController`'s view so
/// that a SwiftUI-provided background renders through.
///
/// Only acts when the hosting controller is actually being presented modally,
/// guarding against accidentally clearing the background of the application's
/// root host. Idempotent: re-applies on `updateUIView` and `didMoveToWindow`,
/// so any subsequent system re-paint (e.g. after a trait collection change) is
/// undone.
@available(iOS 15, *)
struct BackgroundClearer: UIViewRepresentable {
    func makeUIView(context: Context) -> BackgroundClearingView {
        BackgroundClearingView()
    }

    func updateUIView(_ uiView: BackgroundClearingView, context: Context) {
        uiView.clearHostBackground()
    }
}

#endif
