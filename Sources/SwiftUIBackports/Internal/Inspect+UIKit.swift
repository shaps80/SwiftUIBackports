import SwiftUI

#if os(iOS)
internal typealias PlatformView = UIView
internal typealias PlatformViewController = UIViewController
#elseif os(macOS)
internal typealias PlatformView = NSView
internal typealias PlatformViewController = NSViewController
#endif

#if os(iOS) || os(macOS)
internal extension PlatformView {
    func ancestor<ViewType: PlatformView>(ofType type: ViewType.Type) -> ViewType? {
        var view = superview

        while let s = view {
            if let typed = s as? ViewType {
                return typed
            }
            view = s.superview
        }

        return nil
    }

    var host: PlatformView? {
        var view = superview

        while let s = view {
            if NSStringFromClass(type(of: s)).contains("ViewHost") {
                return s
            }
            view = s.superview
        }

        return nil
    }

    func sibling<ViewType: PlatformView>(ofType type: ViewType.Type) -> ViewType? {
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

    func child<ViewType: PlatformView>(ofType type: ViewType.Type) -> ViewType? {
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

internal struct Inspector {
    var hostView: PlatformView
    var sourceView: PlatformView
    var sourceController: PlatformViewController

    func ancestor<ViewType: PlatformView>(ofType: ViewType.Type) -> ViewType? {
        hostView.ancestor(ofType: ViewType.self)
    }

    func sibling<ViewType: PlatformView>(ofType: ViewType.Type) -> ViewType? {
        hostView.sibling(ofType: ViewType.self)
    }
}

extension View {
    private func inject<Content>(_ content: Content) -> some View where Content: View {
        overlay(content.frame(width: 0, height: 0))
    }

    func inspect<ViewType: PlatformView>(selector: @escaping (_ inspector: Inspector) -> ViewType?, customize: @escaping (ViewType) -> Void) -> some View {
        inject(InspectionView(selector: selector, customize: customize))
    }
}

private struct InspectionView<ViewType: PlatformView>: View {
    let selector: (Inspector) -> ViewType?
    let customize: (ViewType) -> Void

    var body: some View {
        Representable(parent: self)
    }
}

private class SourceView: PlatformView {
    required init() {
        super.init(frame: .zero)
        isHidden = true
        #if os(iOS)
        isUserInteractionEnabled = false
        #endif
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif

#if os(iOS)
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
#elseif os(macOS)
private extension InspectionView {
    struct Representable: NSViewRepresentable {
        let parent: InspectionView

        func makeNSView(context: Context) -> NSView {
            .init(frame: .zero)
        }

        func updateNSView(_ view: NSView, context: Context) {
            DispatchQueue.main.async {
                guard let host = view.host else { return }

                let inspector = Inspector(
                    hostView: host,
                    sourceView: view,
                    sourceController: view.parentController ?? NSViewController(nibName: nil, bundle: nil)
                )

                guard let targetView = parent.selector(inspector) else { return }
                parent.customize(targetView)
            }
        }
    }
}
#endif
