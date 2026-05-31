import SwiftUI
import SwiftBackports

@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
@MainActor
public extension Backport where Wrapped: View {
    /// Sets the available detents for the enclosing sheet.
    ///
    /// By default, sheets support the ``PresentationDetent/large`` detent.
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
    ///                     .presentationDetents([.medium, .large])
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter detents: A set of supported detents for the sheet.
    ///   If you provide more than one detent, people can drag the sheet
    ///   to resize it.
    @ViewBuilder
    @available(iOS, introduced: 15, deprecated: 16, message: "Presentation detents are only supported in iOS 15+")
    func presentationDetents(_ detents: Set<Backport<Any>.PresentationDetent>) -> some View {
        #if os(iOS)
        wrapped.background(Backport<Any>.Representable(detents: detents, selection: nil))
        #else
        wrapped
        #endif
    }


    /// Sets the available detents for the enclosing sheet, giving you
    /// programmatic control of the currently selected detent.
    ///
    /// By default, sheets support the ``PresentationDetent/large`` detent.
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///         @State private var settingsDetent = PresentationDetent.medium
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents:(
    ///                         [.medium, .large],
    ///                         selection: $settingsDetent
    ///                      )
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - detents: A set of supported detents for the sheet.
    ///     If you provide more that one detent, people can drag the sheet
    ///     to resize it.
    ///   - selection: A ``Binding`` to the currently selected detent.
    ///     Ensure that the value matches one of the detents that you
    ///     provide for the `detents` parameter.
    @ViewBuilder
    @available(iOS, introduced: 15, deprecated: 16, message: "Presentation detents are only supported in iOS 15+")
    func presentationDetents(_ detents: Set<Backport<Any>.PresentationDetent>, selection: Binding<Backport<Any>.PresentationDetent>) -> some View {
        #if os(iOS)
        wrapped.background(Backport<Any>.Representable(detents: detents, selection: selection))
        #else
        wrapped
        #endif
    }
}

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
public extension Backport<Any> {

    /// A type that represents a height where a sheet naturally rests.
    struct PresentationDetent: Hashable, Comparable {

        public struct Identifier: RawRepresentable, Hashable {
            public var rawValue: String
            public init(rawValue: String) {
                self.rawValue = rawValue
            }

            public static var medium: Identifier {
                .init(rawValue: "com.apple.UIKit.medium")
            }

            public static var large: Identifier {
                .init(rawValue: "com.apple.UIKit.large")
            }

            /// Raw-value prefix used to encode the value of a
            /// ``Backport/PresentationDetent/height(_:)`` detent.
            fileprivate static let heightPrefix = "com.apple.UIKit.height."

            /// Raw-value prefix used to encode the value of a
            /// ``Backport/PresentationDetent/fraction(_:)`` detent.
            fileprivate static let fractionPrefix = "com.apple.UIKit.fraction."
        }

        public let id: Identifier

        /// The system detent for a sheet that's approximately half the height of
        /// the screen, and is inactive in compact height.
        public static var medium: PresentationDetent {
            .init(id: .medium)
        }

        /// The system detent for a sheet at full height.
        public static var large: PresentationDetent {
            .init(id: .large)
        }

        /// A custom detent with the specified height.
        ///
        /// Resolved through
        /// ``UISheetPresentationController/Detent/custom(identifier:resolver:)``
        /// with a constant resolver.
        ///
        /// Marked `@available(iOS 16, *)` because the underlying
        /// `Detent.custom(...)` API was only added in iOS 16; iOS 15's
        /// `UISheetPresentationController` has no equivalent. Exposing this
        /// factory through the `Backport` namespace gives callers that adopt
        /// `.backport.*` API shapes consistent factory names once their
        /// deployment target reaches iOS 16, without forcing them to switch
        /// to a different module just for these two detents.
        ///
        /// - Parameter height: The height of the detent in points.
        @available(iOS 16, *)
        public static func height(_ height: CGFloat) -> PresentationDetent {
            .init(id: .init(rawValue: "\(Identifier.heightPrefix)\(height)"))
        }

        /// A custom detent with a height that's a fraction of the available
        /// detent height.
        ///
        /// Resolved through
        /// ``UISheetPresentationController/Detent/custom(identifier:resolver:)``
        /// using `fraction * context.maximumDetentValue`.
        ///
        /// Marked `@available(iOS 16, *)` because the underlying
        /// `Detent.custom(...)` API was only added in iOS 16; iOS 15's
        /// `UISheetPresentationController` has no equivalent. See
        /// ``height(_:)`` for the rationale around the `Backport` namespace.
        ///
        /// - Parameter fraction: The fraction of the available detent height.
        @available(iOS 16, *)
        public static func fraction(_ fraction: CGFloat) -> PresentationDetent {
            .init(id: .init(rawValue: "\(Identifier.fractionPrefix)\(fraction)"))
        }

        fileprivate static var none: PresentationDetent {
            return .init(id: .init(rawValue: ""))
        }

        /// Decoded numeric value when the identifier was created via
        /// ``height(_:)``, otherwise `nil`.
        internal var heightValue: CGFloat? {
            guard id.rawValue.hasPrefix(Identifier.heightPrefix) else { return nil }
            let suffix = id.rawValue.dropFirst(Identifier.heightPrefix.count)
            return Double(suffix).map { CGFloat($0) }
        }

        /// Decoded fraction when the identifier was created via
        /// ``fraction(_:)``, otherwise `nil`.
        internal var fractionValue: CGFloat? {
            guard id.rawValue.hasPrefix(Identifier.fractionPrefix) else { return nil }
            let suffix = id.rawValue.dropFirst(Identifier.fractionPrefix.count)
            return Double(suffix).map { CGFloat($0) }
        }

        /// Approximate ordering key used to sort detents into the ascending
        /// order expected by `UISheetPresentationController.detents`.
        ///
        /// Heights and fractions sort by numeric value; `.medium` and `.large`
        /// are placed at conservative defaults so a mixed array sorts in a
        /// reasonable order without resolving the runtime screen size.
        ///
        /// Note that even ignoring the custom-detent factories, the previous
        /// implementation of `<` violated `Comparable`'s irreflexivity
        /// requirement (`lhs < lhs` returned `true` for everything except
        /// `.large < .medium`); replacing it with a numeric key restores the
        /// expected `x < x == false` semantics.
        private var sortKey: Double {
            if let value = heightValue { return Double(value) }
            if let value = fractionValue { return Double(value) * 600 }
            if id == .medium { return 400 }
            if id == .large { return 800 }
            return 0
        }

        public static func < (lhs: PresentationDetent, rhs: PresentationDetent) -> Bool {
            lhs.sortKey < rhs.sortKey
        }
    }
}

#if os(iOS)
@available(iOS 15, *)
private extension Backport<Any> {
    struct Representable: UIViewControllerRepresentable {
        let detents: Set<Backport<Any>.PresentationDetent>
        let selection: Binding<Backport<Any>.PresentationDetent>?

        func makeUIViewController(context: Context) -> Backport.Representable.Controller {
            Controller(detents: detents, selection: selection)
        }

        func updateUIViewController(_ controller: Backport.Representable.Controller, context: Context) {
            controller.update(detents: detents, selection: selection)
        }
    }
}

@available(iOS 15, *)
private extension Backport.Representable {
    final class Controller: UIViewController, UISheetPresentationControllerDelegate {

        var detents: Set<Backport<Any>.PresentationDetent>
        var selection: Binding<Backport<Any>.PresentationDetent>?
        var largestUndimmed: Backport<Any>.PresentationDetent?
        weak var _delegate: UISheetPresentationControllerDelegate?

        init(detents: Set<Backport<Any>.PresentationDetent>, selection: Binding<Backport<Any>.PresentationDetent>?) {
            self.detents = detents
            self.selection = selection
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            if let controller = parent?.sheetPresentationController {
                if controller.delegate !== self && _delegate == nil {
                    _delegate = controller.delegate
                    controller.delegate = self
                }
            }
            update(detents: detents, selection: selection)
        }

        override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
            super.willTransition(to: newCollection, with: coordinator)
            update(detents: detents, selection: selection)
        }

        func update(detents: Set<Backport<Any>.PresentationDetent>, selection: Binding<Backport<Any>.PresentationDetent>?) {
            self.detents = detents
            self.selection = selection

            if let controller = parent?.sheetPresentationController {
                controller.animateChanges {
                    controller.detents = detents.sorted().map { detent in
                        Self.systemDetent(for: detent)
                    }

                    if let selection = selection {
                        controller.selectedDetentIdentifier = .init(selection.wrappedValue.id.rawValue)
                    }

                    controller.prefersScrollingExpandsWhenScrolledToEdge = true
                }

                UIView.animate(withDuration: 0.25) {
                    if let undimmed = controller.largestUndimmedDetentIdentifier {
                        controller.presentingViewController.view?.tintAdjustmentMode = (selection?.wrappedValue ?? .large) >= .init(id: .init(rawValue: undimmed.rawValue)) ? .automatic : .normal
                    } else {
                        controller.presentingViewController.view?.tintAdjustmentMode = .automatic
                    }
                }
            }
        }

        func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
            guard
                let selection = selection,
                let id = sheetPresentationController.selectedDetentIdentifier?.rawValue,
                selection.wrappedValue.id.rawValue != id
            else { return }

            selection.wrappedValue = .init(id: .init(rawValue: id))
        }

        override func responds(to aSelector: Selector!) -> Bool {
            if super.responds(to: aSelector) { return true }
            if _delegate?.responds(to: aSelector) ?? false { return true }
            return false
        }

        override func forwardingTarget(for aSelector: Selector!) -> Any? {
            if super.responds(to: aSelector) { return self }
            return _delegate
        }

        /// Resolves a ``Backport/PresentationDetent`` to the system
        /// `UISheetPresentationController.Detent` that should be applied.
        ///
        /// On iOS 16+, `.height` and `.fraction` are bridged via
        /// `Detent.custom(identifier:resolver:)`, preserving the identifier so
        /// that ``selection`` round-trips correctly. On iOS 15 the only
        /// reachable cases are ``Backport/PresentationDetent/medium`` and
        /// ``Backport/PresentationDetent/large``; the custom factories are
        /// `@available(iOS 16, *)` so they cannot appear in `detents` there.
        static func systemDetent(for detent: Backport<Any>.PresentationDetent) -> UISheetPresentationController.Detent {
            if #available(iOS 16, *) {
                if let height = detent.heightValue {
                    return .custom(identifier: .init(detent.id.rawValue)) { _ in height }
                }
                if let fraction = detent.fractionValue {
                    return .custom(identifier: .init(detent.id.rawValue)) { context in
                        fraction * context.maximumDetentValue
                    }
                }
            }
            switch detent {
            case .medium:
                return .medium()
            default:
                return .large()
            }
        }
    }
}
#endif
