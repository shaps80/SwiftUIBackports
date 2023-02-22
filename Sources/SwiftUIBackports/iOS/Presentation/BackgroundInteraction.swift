import SwiftUI
import SwiftBackports

@available(iOS, deprecated: 16.4)
@available(tvOS, deprecated: 16.4)
@available(macOS, deprecated: 13.3)
@available(watchOS, deprecated: 9.4)
extension Backport<Any> {
    /// The kinds of interaction available to views behind a presentation.
    ///
    /// Use values of this type with the
    /// ``View/presentationBackgroundInteraction(_:)`` modifier.
    public struct PresentationBackgroundInteraction: Hashable {
        enum Interaction: Hashable {
            case automatic
            case enabled
            case upThrough(detent: Backport.PresentationDetent)
            case disabled
        }

        let interaction: Interaction

        /// The default background interaction for the presentation.
        public static var automatic: Self { .init(interaction: .automatic) }

        /// People can interact with the view behind a presentation.
        public static var enabled: Self { .init(interaction: .enabled) }

        /// People can interact with the view behind a presentation up through a
        /// specified detent.
        ///
        /// At detents larger than the one you specify, SwiftUI disables
        /// interaction.
        ///
        /// - Parameter detent: The largest detent at which people can interact with
        ///   the view behind the presentation.
        public static func enabled(upThrough detent: Backport.PresentationDetent) -> Self { .init(interaction: .upThrough(detent: detent))}

        /// People can't interact with the view behind a presentation.
        public static var disabled: Self { .init(interaction: .disabled) }
    }
}

@available(iOS, deprecated: 16.4)
@available(tvOS, deprecated: 16.4)
@available(macOS, deprecated: 13.3)
@available(watchOS, deprecated: 9.4)
public extension Backport where Wrapped: View {
    /// Controls whether people can interact with the view behind a
    /// presentation.
    ///
    /// On many platforms, SwiftUI automatically disables the view behind a
    /// sheet that you present, so that people can't interact with the backing
    /// view until they dismiss the sheet. Use this modifier if you want to
    /// enable interaction.
    ///
    /// The following example enables people to interact with the view behind
    /// the sheet when the sheet is at the smallest detent, but not at the other
    /// detents:
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
    ///                     .presentationDetents(
    ///                         [.medium, .large])
    ///                     .presentationBackgroundInteraction(
    ///                         .enabled(upThrough: .medium))
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - interaction: A specification of how people can interact with the
    ///     view behind a presentation.
    @ViewBuilder
    func presentationBackgroundInteraction(_ interaction: Backport<Any>.PresentationBackgroundInteraction) -> some View {
        #if os(iOS)
        if #available(iOS 15, *) {
            wrapped.background(Backport<Any>.Representable(interaction: interaction))
        } else {
            wrapped
        }
        #else
        wrapped
        #endif
    }
}

#if os(iOS)
@available(iOS 15, *)
private extension Backport where Wrapped == Any {
    struct Representable: UIViewControllerRepresentable {
        let interaction: Backport<Any>.PresentationBackgroundInteraction

        func makeUIViewController(context: Context) -> Backport.Representable.Controller {
            Controller(interaction: interaction)
        }

        func updateUIViewController(_ controller: Backport.Representable.Controller, context: Context) {
            controller.update(interaction: interaction)
        }
    }
}

@available(iOS 15, *)
private extension Backport.Representable {
    final class Controller: UIViewController, UISheetPresentationControllerDelegate {
        var interaction: Backport<Any>.PresentationBackgroundInteraction
        weak var _delegate: UISheetPresentationControllerDelegate?

        init(interaction: Backport<Any>.PresentationBackgroundInteraction) {
            self.interaction = interaction
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            update(interaction: interaction)
        }

        override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
            super.willTransition(to: newCollection, with: coordinator)
            update(interaction: interaction)
        }

        func update(interaction: Backport<Any>.PresentationBackgroundInteraction) {
            self.interaction = interaction

            if let controller = parent?.sheetPresentationController {
                controller.animateChanges {
                    switch interaction.interaction {
                    case .automatic:
                        controller.largestUndimmedDetentIdentifier = nil
                        controller.presentingViewController.view?.tintAdjustmentMode = .automatic
                    case .disabled:
                        controller.largestUndimmedDetentIdentifier = nil
                        controller.presentingViewController.view?.tintAdjustmentMode = .automatic
                    case .enabled:
                        controller.largestUndimmedDetentIdentifier = .large
                        controller.presentingViewController.view?.tintAdjustmentMode = .normal
                    case .upThrough(let detent):
                        controller.largestUndimmedDetentIdentifier = .init(detent.id.rawValue)

                        let selectedId = controller.selectedDetentIdentifier ?? .large
                        let selected = Backport<Any>.PresentationDetent(id: .init(rawValue: selectedId.rawValue))
                        controller.presentingViewController.view?.tintAdjustmentMode = selected > detent ? .dimmed : .normal
                    }
                }
            }
        }
    }
}
#endif
