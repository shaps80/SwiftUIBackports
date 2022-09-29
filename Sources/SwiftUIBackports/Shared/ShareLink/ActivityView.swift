import SwiftUI

internal extension View {
    func activitySheet(isPresented: Binding<Bool>) -> some View {
        background(ActivityView(isPresented: isPresented))
    }
}

private struct ActivityView: View {
    @Binding var isPresented: Bool
    var body: some View {
        Representable(isPresented: $isPresented)
            .edgesIgnoringSafeArea(.all)
    }
}

#if os(iOS)
private extension ActivityView {
    struct Representable: UIViewRepresentable {
        @Binding var isPresented: Bool
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(parent: self)
        }
        
        func makeUIView(context: Context) -> UIView {
            return context.coordinator.view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            context.coordinator.parent = self
        }
    }
}

private extension ActivityView {
    final class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        var parent: Representable {
            didSet {
                updateControllerLifecycle(
                    from: oldValue.isPresented,
                    to: parent.isPresented
                )
            }
        }
        
        init(parent: Representable) {
            self.parent = parent
        }
        
        let view = UIView()
        private weak var controller: UIActivityViewController?
        
        private func updateControllerLifecycle(from oldValue: Bool, to newValue: Bool) {
            switch (oldValue, newValue) {
            case (false, true):
                presentController()
            case (true, false):
                dismissController()
            case (true, true):
                updateController()
            case (false, false):
                break
            }
        }
        
        private func presentController() {
            let controller = UIActivityViewController(activityItems: ["test"], applicationActivities: nil)
            controller.presentationController?.delegate = self
            controller.popoverPresentationController?.sourceRect = view.bounds
            controller.popoverPresentationController?.sourceView = view
            controller.completionWithItemsHandler = { [weak self] activityType, success, items, error in
                guard let self else { return }
                self.resetItemBinding()
                self.dismissController()
            }
            
            guard let presenting = view.owningController else {
                resetItemBinding()
                return
            }
            
            presenting.present(controller, animated: true)
            self.controller = controller
        }
        
        private func updateController() { }
        
        private func dismissController() {
            guard let controller = controller else { return }
            controller.presentingViewController?.dismiss(animated: true)
        }
        
        private func resetItemBinding() {
            parent.isPresented = false
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            resetItemBinding()
        }
    }
}

private extension UIView {
    var owningController: UIViewController? {
        if let responder = self.next as? UIViewController {
            return responder
        } else if let responder = self.next as? UIView {
            return responder.owningController
        } else {
            return nil
        }
    }
}
#endif
