#if os(iOS)
import SwiftUI

internal extension UIView {
    func ancestor<ViewType: UIView>(ofType type: ViewType.Type) -> ViewType? {
        var view = superview

        while let s = view {
            if let typed = s as? ViewType {
                return typed
            }
            view = s.superview
        }

        return nil
    }

    var host: UIView? {
        var view = superview

        while let s = view {
            if NSStringFromClass(type(of: s)).contains("ViewHost") {
                return s
            }
            view = s.superview
        }

        return nil
    }

    func sibling<ViewType: UIView>(ofType type: ViewType.Type) -> ViewType? {
        guard let superview = superview, let index = superview.subviews.firstIndex(of: self) else { return nil }

        var views = superview.subviews
        views.remove(at: index)

        for subview in views.reversed() {
            if let typed = subview.child(ofType: type) {
                return typed
            }
        }

        return nil
    }

    func child<ViewType: UIView>(ofType type: ViewType.Type) -> ViewType? {
        for subview in subviews {
            if let typed = subview as? ViewType {
                return typed
            } else if let typed = subview.child(ofType: type) {
                return typed
            }
        }

        return nil
    }
}

public struct Inspector {
    public var hostView: UIView
    public var sourceView: UIView
    public var sourceController: UIViewController

    func ancestor<ViewType: UIView>(ofType: ViewType.Type) -> ViewType? {
        hostView.ancestor(ofType: ViewType.self)
    }

    func sibling<ViewType: UIView>(ofType: ViewType.Type) -> ViewType? {
        hostView.sibling(ofType: ViewType.self)
    }
}

public extension View {
    private func inject<Content>(_ content: Content) -> some View where Content: View {
        overlay(content.frame(width: 0, height: 0))
    }

    func inspect<ViewType: UIView>(selector: @escaping (_ inspector: Inspector) -> ViewType?, customize: @escaping (ViewType) -> Void) -> some View {
        inject(InspectionView(selector: selector, customize: customize))
    }
}

private struct InspectionView<ViewType: UIView>: View {
    let selector: (Inspector) -> ViewType?
    let customize: (ViewType) -> Void

    var body: some View {
        Representable(parent: self)
    }
}

private extension InspectionView {
    struct Representable: UIViewRepresentable {
        let parent: InspectionView

        func makeUIView(context: Context) -> UIView { .init() }
        func updateUIView(_ view: UIView, context: Context) {
            DispatchQueue.main.async {
                guard let host = view.host else { return }

                let inspector = Inspector(
                    hostView: host,
                    sourceView: view,
                    sourceController: view.parentController
                    ?? view.window?.rootViewController
                    ?? UIViewController()
                )

                guard let targetView = parent.selector(inspector) else { return }
                parent.customize(targetView)
            }
        }
    }
}

private class SourceView: UIView {
    required init() {
        super.init(frame: .zero)
        isHidden = true
        isUserInteractionEnabled = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#endif
