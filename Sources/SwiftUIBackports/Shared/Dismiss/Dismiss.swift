import SwiftUI

public extension EnvironmentValues {

    /// An action that dismisses the current presentation.
    ///
    /// Use this environment value to get the ``Backport.DismissAction`` instance
    /// for the current ``Environment``. Then call the instance
    /// to perform the dismissal. You call the instance directly because
    /// it defines a ``Backport.DismissAction/callAsFunction()``
    /// method that Swift calls when you call the instance.
    ///
    /// For example, you can create a button that calls the ``Backport.DismissAction``:
    ///
    ///     private struct SheetContents: View {
    ///         @Environment(\.backportDismiss) private var dismiss
    ///
    ///         var body: some View {
    ///             Button("Done") {
    ///                 dismiss()
    ///             }
    ///         }
    ///     }
    ///
    /// If you present the `SheetContents` view in a sheet, the user can dismiss
    /// the sheet by tapping or clicking the sheet's button:
    ///
    ///     private struct DetailView: View {
    ///         @State private var isSheetPresented = false
    ///
    ///         var body: some View {
    ///             Button("Show Sheet") {
    ///                 isSheetPresented = true
    ///             }
    ///             .sheet(isPresented: $isSheetPresented) {
    ///                 SheetContents()
    ///             }
    ///         }
    ///     }
    ///
    /// Be sure that you define the action in the appropriate environment.
    /// For example, don't reorganize the `DetailView` in the example above
    /// so that it creates the `dismiss` property and calls it from the
    /// ``View/sheet(item:onDismiss:content:)`` view modifier's `content`
    /// closure:
    ///
    ///     private struct DetailView: View {
    ///         @State private var isSheetPresented = false
    ///         @Environment(\.backportDismiss) private var dismiss // Applies to DetailView.
    ///
    ///         var body: some View {
    ///             Button("Show Sheet") {
    ///                 isSheetPresented = true
    ///             }
    ///             .sheet(isPresented: $isSheetPresented) {
    ///                 Button("Done") {
    ///                     dismiss() // Fails to dismiss the sheet.
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// If you do this, the sheet fails to dismiss because the action applies
    /// to the environment where you declared it, which is that of the detail
    /// view, rather than the sheet. In fact, if you've presented the detail
    /// view in a ``NavigationView``, the dismissal pops the detail view
    /// the navigation stack.
    ///
    /// The dismiss action has no effect on a view that isn't currently
    /// presented. If you need to query whether SwiftUI is currently presenting
    /// a view, read the ``EnvironmentValues/backportIsPresented`` environment value.
    var backportDismiss: Backport<Any>.DismissAction {
        .init(presentation: presentationMode)
    }

    /// A Boolean value that indicates whether the view associated with this
    /// environment is currently presented.
    ///
    /// You can read this value like any of the other ``EnvironmentValues``
    /// by creating a property with the ``Environment`` property wrapper:
    ///
    ///     @Environment(\.backportIsPresented) private var isPresented
    ///
    /// Read the value inside a view if you need to know when SwiftUI
    /// presents that view. For example, you can take an action when SwiftUI
    /// presents a view by using the ``View/onChange(of:perform:)``
    /// modifier:
    ///
    ///     .onChange(of: isPresented) { isPresented in
    ///         if isPresented {
    ///             // Do something when first presented.
    ///         }
    ///     }
    ///
    /// This behaves differently than ``View/onAppear(perform:)``, which
    /// SwiftUI can call more than once for a given presentation, like
    /// when you navigate back to a view that's already in the
    /// navigation hierarchy.
    ///
    /// To dismiss the currently presented view, use
    /// ``EnvironmentValues/backportDismiss``.
    var backportIsPresented: Bool {
        presentationMode.wrappedValue.isPresented
    }

}

@available(iOS, deprecated: 15)
@available(macOS, deprecated: 12)
@available(tvOS, deprecated: 15)
@available(watchOS, deprecated: 8)
extension Backport where Content: Any {

    /// An action that dismisses a presentation.
    ///
    /// Use the ``EnvironmentValues/dismiss`` environment value to get the instance
    /// of this structure for a given ``Environment``. Then call the instance
    /// to perform the dismissal. You call the instance directly because
    /// it defines a ``DismissAction/callAsFunction()``
    /// method that Swift calls when you call the instance.
    ///
    /// For example, you can create a button that calls the ``DismissAction``:
    ///
    ///     private struct SheetContents: View {
    ///         @Environment(\.backportDismiss) private var dismiss
    ///
    ///         var body: some View {
    ///             Button("Done") {
    ///                 dismiss()
    ///             }
    ///         }
    ///     }
    ///
    /// If you present the `SheetContents` view in a sheet, the user can dismiss
    /// the sheet by tapping or clicking the sheet's button:
    ///
    ///     private struct DetailView: View {
    ///         @State private var isSheetPresented = false
    ///
    ///         var body: some View {
    ///             Button("Show Sheet") {
    ///                 isSheetPresented = true
    ///             }
    ///             .sheet(isPresented: $isSheetPresented) {
    ///                 SheetContents()
    ///             }
    ///         }
    ///     }
    ///
    /// Be sure that you define the action in the appropriate environment.
    /// For example, don't reorganize the `DetailView` in the example above
    /// so that it creates the `dismiss` property and calls it from the
    /// ``View/sheet(item:onDismiss:content:)`` view modifier's `content`
    /// closure:
    ///
    ///     private struct DetailView: View {
    ///         @State private var isSheetPresented = false
    ///         @Environment(\.backportDismiss) private var dismiss // Applies to DetailView.
    ///
    ///         var body: some View {
    ///             Button("Show Sheet") {
    ///                 isSheetPresented = true
    ///             }
    ///             .sheet(isPresented: $isSheetPresented) {
    ///                 Button("Done") {
    ///                     dismiss() // Fails to dismiss the sheet.
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// If you do this, the sheet fails to dismiss because the action applies
    /// to the environment where you declared it, which is that of the detail
    /// view, rather than the sheet. In fact, if you've presented the detail
    /// view in a ``NavigationView``, the dismissal pops the detail view
    /// from the navigation stack.
    ///
    /// The dismiss action has no effect on a view that isn't currently
    /// presented. If you need to query whether SwiftUI is currently presenting
    /// a view, read the ``EnvironmentValues/backportIsPresented`` environment value.
    public struct DismissAction {
        var presentation: Binding<PresentationMode>
        public func callAsFunction() {
            presentation.wrappedValue.dismiss()
        }
    }

}
