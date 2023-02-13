import SwiftBackports

#if os(iOS)

import UIKit

public typealias PlatformImage = UIImage
public typealias PlatformScreen = UIScreen

internal typealias PlatformView = UIView
internal typealias PlatformScrollView = UIScrollView
internal typealias PlatformViewController = UIViewController

extension UIScreen {
    @nonobjc
    public static var mainScreen: UIScreen { .main }
}

extension UIImage {
    public var png: Data? { pngData() }
    public func jpg(quality: CGFloat) -> Data? { jpegData(compressionQuality: quality) }
}

extension CGContext {
    internal static var current: CGContext? {
        UIGraphicsGetCurrentContext()
    }
}


#elseif os(macOS)

import AppKit

public typealias PlatformImage = NSImage
public typealias PlatformScreen = NSScreen

internal typealias PlatformView = NSView
internal typealias PlatformScrollView = NSScrollView
internal typealias PlatformViewController = NSViewController

extension NSScreen {
    public static var mainScreen: NSScreen { NSScreen.main! }
    public var scale: CGFloat { backingScaleFactor }
}

extension NSImage {
    public var png: Data? {
        return NSBitmapImageRep(data: tiffRepresentation!)?.representation(using: .png, properties: [:])
    }

    public func jpg(quality: CGFloat) -> Data? {
        return NSBitmapImageRep(data: tiffRepresentation!)?.representation(using: .jpeg, properties: [.compressionFactor: quality])
    }
}

extension CGContext {
    internal static var current: CGContext? {
        NSGraphicsContext.current?.cgContext
    }
}
#endif
