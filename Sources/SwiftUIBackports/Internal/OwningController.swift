import SwiftBackports

#if os(iOS)
import UIKit

public extension UIView {

    var parentController: UIViewController? {
        if let responder = self.next as? UIViewController {
            return responder
        } else if let responder = self.next as? UIView {
            return responder.parentController
        } else {
            return nil
        }
    }

}
#endif

#if os(macOS)
import AppKit

public extension NSView {

    var parentController: NSViewController? {
        if let responder = self.nextResponder as? NSViewController {
            return responder
        } else if let responder = self.nextResponder as? NSView {
            return responder.parentController
        } else {
            return nil
        }
    }

}
#endif
