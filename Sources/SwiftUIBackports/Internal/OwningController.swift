#if canImport(UIKit)
import UIKit

public extension UIView {

    var parentController: UIViewController? {
        var responder: UIResponder? = self

        while !(responder is UIViewController) && superview != nil {
            if let next = responder?.next {
                responder = next
            }
        }

        return responder as? UIViewController
    }

}
#endif

#if canImport(AppKit)
import AppKit

public extension NSView {

    var parentController: NSViewController? {
        var responder: NSResponder? = self

        while !(responder is NSViewController) && superview != nil {
            if let next = responder?.next {
                responder = next
            }
        }

        return responder as? NSViewController
    }

}
#endif
