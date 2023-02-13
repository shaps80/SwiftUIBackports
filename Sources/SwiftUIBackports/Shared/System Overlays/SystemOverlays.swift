import SwiftUI
import SwiftBackports

@available(iOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(tvOS, deprecated: 16)
@available(watchOS, deprecated: 9)
public extension Backport where Wrapped: View {
    /// Sets the preferred visibility of the non-transient system views
    /// overlaying the app.
    ///
    /// Use this modifier if you would like to customise the immersive
    /// experience of your app by hiding or showing system overlays that may
    /// affect user experience. The following example hides every persistent
    /// system overlay.
    ///
    ///     struct ImmersiveView: View {
    ///         var body: some View {
    ///             Text("Maximum immersion")
    ///                 .persistentSystemOverlays(.hidden)
    ///         }
    ///     }
    ///
    /// Note that this modifier only sets a preference and, ultimately the
    /// system will decide if it will honour it or not.
    ///
    /// These non-transient system views include:
    /// - The Home indicator
    ///
    /// - Parameter visibility: A value that indicates the visibility of the
    /// non-transient system views overlaying the app.
    func persistentSystemOverlays(_ visibility: Backport<Any>.Visibility) -> some View {
        wrapped.preference(key: PersistentSystemOverlaysPreferenceKey.self, value: visibility)
    }
}

private struct PersistentSystemOverlaysPreferenceKey: PreferenceKey {
    typealias Value = Backport<Any>.Visibility
    static var defaultValue: Value = .automatic
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

#if os(iOS)
private final class Representable: UIHostingController<AnyView> {
    init<Content: View>(rootView: Content) {
        let box = WeakBox()
        super.init(
            rootView: AnyView(
                rootView
                    .onPreferenceChange(PersistentSystemOverlaysPreferenceKey.self) { visibility in
                        box.value?.persistentSystemOverlaysHidden = visibility == .hidden
                    }
            )
        )
        box.value = self
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private class WeakBox {
        weak var value: Representable?
        init() {}
    }

    private var persistentSystemOverlaysHidden = false {
        didSet { setNeedsUpdateOfHomeIndicatorAutoHidden() }
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        persistentSystemOverlaysHidden
    }
}
#endif
