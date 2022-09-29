#if os(iOS)

import UIKit

public typealias PlatformImage = UIImage

internal typealias PlatformView = UIView
internal typealias PlatformViewController = UIViewController

#elseif os(macOS)

import AppKit

public typealias PlatformImage = NSImage

internal typealias PlatformView = NSView
internal typealias PlatformViewController = NSViewController

#endif
