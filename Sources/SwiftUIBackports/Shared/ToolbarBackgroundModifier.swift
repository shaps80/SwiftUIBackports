import SwiftUI

internal struct ToolbarBackgroundModifier: ViewModifier {
    @Environment(\.toolbarViews) private var toolbarViews
    @Environment(\.toolbarVisibility) private var toolbarVisibility

    @Backport.StateObject private var wrapper: ControllerWrapper = .init()

    func body(content: Content) -> some View {
        content
            .controller { controller in
                wrapper.controller = controller
            }
            .backport.task {
                updateNavigationBar()
                updateBottomBar()
                updateTabBar()
            }
    }

    private func updateNavigationBar() {
        guard toolbarVisibility.navigationBar != nil || toolbarViews.navigationBar != nil else { return }
        guard let bar = wrapper.controller?.navigationController?.navigationBar else { return }
        let appearance = UINavigationBarAppearance()

        if let visibilty = toolbarVisibility.navigationBar, visibilty == .hidden {
            appearance.configureWithTransparentBackground()
        } else if let view = toolbarViews.navigationBar {
            appearance.backgroundImage = Backport.ImageRenderer(
                content: view
                    .frame(width: bar.bounds.width, height: bar.bounds.height)
                    .edgesIgnoringSafeArea(.all)
            ).uiImage
        } else {
            appearance.configureWithDefaultBackground()
        }

        bar.standardAppearance = appearance
        bar.compactAppearance = appearance
        bar.scrollEdgeAppearance = appearance
        if #available(iOS 15.0, *) {
            bar.compactScrollEdgeAppearance = appearance
        }
    }

    private func updateBottomBar() {
        guard toolbarVisibility.bottomBar != nil || toolbarViews.bottomBar != nil else { return }
        guard let bar = wrapper.controller?.navigationController?.toolbar else { return }
        let appearance = UIToolbarAppearance()

        if let visibilty = toolbarVisibility.bottomBar, visibilty == .hidden {
            appearance.configureWithTransparentBackground()
        } else {
            appearance.configureWithDefaultBackground()
        }

        bar.standardAppearance = appearance
        bar.compactAppearance = appearance
        if #available(iOS 15.0, *) {
            bar.scrollEdgeAppearance = appearance
        }
        if #available(iOS 15.0, *) {
            bar.compactScrollEdgeAppearance = appearance
        }
    }

    private func updateTabBar() {
        guard toolbarVisibility.tabBar != nil || toolbarViews.tabBar != nil else { return }
        guard let bar = wrapper.controller?.tabBarController?.tabBar else { return }
        let appearance = UITabBarAppearance()

        if let visibilty = toolbarVisibility.tabBar, visibilty == .hidden {
            appearance.configureWithTransparentBackground()
        } else if let view = toolbarViews.tabBar {
            appearance.backgroundImage = Backport.ImageRenderer(
                content: view
                    .frame(width: bar.bounds.width, height: bar.bounds.height)
                    .edgesIgnoringSafeArea(.all)
            ).uiImage
        } else {
            appearance.configureWithDefaultBackground()
        }

        bar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            bar.scrollEdgeAppearance = appearance
        }
    }
}

private final class ControllerWrapper: ObservableObject {
    weak var controller: UIViewController?
}
