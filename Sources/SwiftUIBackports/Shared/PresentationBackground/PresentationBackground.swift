import SwiftUI
import SwiftBackports

@available(iOS, deprecated: 16.4)
@available(tvOS, deprecated: 16.4)
@available(macOS, deprecated: 13.3)
@available(watchOS, deprecated: 9.4)
@MainActor
public extension Backport where Wrapped: View {

    /// Sets the presentation background of the enclosing sheet using a shape style.
    ///
    /// The following example uses the `thick` material as the sheet background:
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .backport.presentationBackground(.thickMaterial)
    ///             }
    ///         }
    ///     }
    ///
    /// The `presentationBackground(_:)` modifier differs from the `background(_:)`
    /// modifier in several key ways. A presentation background:
    ///
    /// - Automatically fills the entire presentation.
    /// - Allows views behind the presentation to show through translucent styles
    ///   on supported platforms.
    ///
    /// On iOS 15 the background is rendered behind the sheet content via SwiftUI's
    /// regular `background` modifier, and the underlying `UIHostingController` view
    /// background is cleared so the supplied style is what the user sees. This
    /// approximates the native behavior closely for the common case where the
    /// modifier is applied to the root of a presented modal.
    ///
    /// - Parameter style: The shape style to use as the presentation background.
    @ViewBuilder
    @available(iOS, introduced: 15, deprecated: 16.4, message: "Presentation background is supported natively on iOS 16.4+")
    func presentationBackground<S: ShapeStyle>(_ style: S) -> some View {
        #if os(iOS)
        if #available(iOS 16.4, *) {
            wrapped.presentationBackground(style)
        } else {
            wrapped
                .background(style, ignoresSafeAreaEdges: .all)
                .background(BackgroundClearer())
        }
        #else
        wrapped
        #endif
    }

    /// Sets the presentation background of the enclosing sheet to a custom view.
    ///
    /// The following example uses a yellow view as the sheet background:
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .backport.presentationBackground {
    ///                         Color.yellow
    ///                     }
    ///             }
    ///         }
    ///     }
    ///
    /// A presentation background automatically fills the entire presentation and,
    /// where supported, lets views behind the presentation show through translucent
    /// styles.
    ///
    /// - Parameters:
    ///   - alignment: The alignment that the modifier uses to position the
    ///     implicit `ZStack` that groups the background views. The default is
    ///     `center`.
    ///   - content: The view to use as the background of the presentation.
    @ViewBuilder
    @available(iOS, introduced: 15, deprecated: 16.4, message: "Presentation background is supported natively on iOS 16.4+")
    func presentationBackground<V: View>(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> V
    ) -> some View {
        #if os(iOS)
        if #available(iOS 16.4, *) {
            wrapped.presentationBackground(alignment: alignment, content: content)
        } else {
            wrapped
                .background(alignment: alignment) {
                    content().ignoresSafeArea()
                }
                .background(BackgroundClearer())
        }
        #else
        wrapped
        #endif
    }
}
