import SwiftUI
import SwiftBackports

///// Strategies for adapting a presentation to a different size class.
/////
///// Use values of this type with the ``View/presentationCompactAdaptation(_:)``
///// and ``View/presentationCompactAdaptation(horizontal:vertical:)`` modifiers.
//@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
//public struct PresentationAdaptation {
//
//    /// Use the default presentation adaptation.
//    public static var automatic: PresentationAdaptation { get }
//
//    /// Don't adapt for the size class, if possible.
//    public static var none: PresentationAdaptation { get }
//
//    /// Prefer a popover appearance when adapting for size classes.
//    public static var popover: PresentationAdaptation { get }
//
//    /// Prefer a sheet appearance when adapting for size classes.
//    public static var sheet: PresentationAdaptation { get }
//
//    /// Prefer a full-screen-cover appearance when adapting for size classes.
//    public static var fullScreenCover: PresentationAdaptation { get }
//}
//
//
///// Specifies how to adapt a presentation to compact size classes.
/////
///// Some presentations adapt their appearance depending on the context. For
///// example, a sheet presentation over a vertically-compact view uses a
///// full-screen-cover appearance by default. Use this modifier to indicate
///// a custom adaptation preference. For example, the following code
///// uses a presentation adaptation value of ``PresentationAdaptation/none``
///// to request that the system not adapt the sheet in compact size classes:
/////
/////     struct ContentView: View {
/////         @State private var showSettings = false
/////
/////         var body: some View {
/////             Button("View Settings") {
/////                 showSettings = true
/////             }
/////             .sheet(isPresented: $showSettings) {
/////                 SettingsView()
/////                     .presentationDetents([.medium, .large])
/////                     .presentationCompactAdaptation(.none)
/////             }
/////         }
/////     }
/////
///// If you want to specify different adaptations for each dimension,
///// use the ``View/presentationCompactAdaptation(horizontal:vertical:)``
///// method instead.
/////
///// - Parameter adaptation: The adaptation to use in either a horizontally
/////   or vertically compact size class.
//public func presentationCompactAdaptation(_ adaptation: PresentationAdaptation) -> some View
//
//
///// Specifies how to adapt a presentation to horizontally and vertically
///// compact size classes.
/////
///// Some presentations adapt their appearance depending on the context. For
///// example, a popover presentation over a horizontally-compact view uses a
///// sheet appearance by default. Use this modifier to indicate a custom
///// adaptation preference.
/////
/////     struct ContentView: View {
/////         @State private var showInfo = false
/////
/////         var body: some View {
/////             Button("View Info") {
/////                 showInfo = true
/////             }
/////             .popover(isPresented: $showInfo) {
/////                 InfoView()
/////                     .presentationCompactAdaptation(
/////                         horizontal: .popover,
/////                         vertical: .sheet)
/////             }
/////         }
/////     }
/////
///// If you want to specify the same adaptation for both dimensions,
///// use the ``View/presentationCompactAdaptation(_:)`` method instead.
/////
///// - Parameters:
/////   - horizontalAdaptation: The adaptation to use in a horizontally
/////     compact size class.
/////   - verticalAdaptation: The adaptation to use in a vertically compact
/////     size class. In a size class that is both horizontally and vertically
/////     compact, SwiftUI uses the `verticalAdaptation` value.
//public func presentationCompactAdaptation(horizontal horizontalAdaptation: PresentationAdaptation, vertical verticalAdaptation: PresentationAdaptation) -> some View
//
//
///// Requests that the presentation have a specific corner radius.
/////
///// Use this modifier to change the corner radius of a presentation.
/////
/////     struct ContentView: View {
/////         @State private var showSettings = false
/////
/////         var body: some View {
/////             Button("View Settings") {
/////                 showSettings = true
/////             }
/////             .sheet(isPresented: $showSettings) {
/////                 SettingsView()
/////                     .presentationDetents([.medium, .large])
/////                     .presentationCornerRadius(21)
/////             }
/////         }
/////     }
/////
///// - Parameter cornerRadius: The corner radius, or `nil` to use the system
/////   default.
//public func presentationCornerRadius(_ cornerRadius: CGFloat?) -> some View
