import SwiftUI

#if os(macOS)

extension View {
    func inspector() -> some View {
        print("This modifier does nothing on macOS")
        return self
    }
}

extension NSView {
    internal var owningViewController: NSViewController? {
        var responder: NSResponder? = self

        while !(responder is NSViewController) && superview != nil {
            if let next = responder?.nextResponder {
                responder = next
            }
        }

        return responder as? NSViewController
    }
}

private struct Inspector: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView { _View() }
    func updateNSView(_ view: NSView, context: Context) { }
}

private extension Inspector {
    final class _View: NSView {
        override func viewWillMove(toWindow newWindow: NSWindow?) {
            super.viewWillMove(toWindow: newWindow)
        }
    }
}


#elseif os(iOS)

extension View {
    func inspector() -> some View {
        background(Inspector())
    }
}

private struct Inspector: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView { _View() }
    func updateUIView(_ view: UIView, context: Context) { }
}

private extension Inspector {
    final class _View: UIView {
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
        }
    }
}


extension UIView {
    internal var owningViewController: UIViewController? {
        var responder: UIResponder? = self

        while !(responder is UIViewController) && responder != nil && superview != nil {
            if let next = responder?.next {
                responder = next
            } else {
                return nil
            }
        }

        return responder as? UIViewController
    }
}

#endif
