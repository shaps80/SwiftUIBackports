import SwiftUI

public final class ImageRenderer<Content>: ObservableObject where Content: View {
    public var content: Content
    public var label: String?
    public var proposedSize: ProposedViewSize = .unspecified
    public var scale: CGFloat = UIScreen.main.scale
    public var isOpaque: Bool = false
    public var colorMode: ColorRenderingMode = .nonLinear
    
    public init(content: Content) {
        self.content = content
    }
}

//public extension ImageRenderer {
//    func render(rasterizationScale: CGFloat = 1, renderer: (CGSize, (CGContext) -> Void) -> Void) {
//
//    }
//}

public extension ImageRenderer {
    var cgImage: CGImage? {
        #if os(macOS)
        nsImage?.cgImage
        #else
        uiImage?.cgImage
        #endif
    }
    
    #if os(macOS)
    
    var nsImage: NSImage? {
        nil
    }
    
    #else
    
    var uiImage: UIImage? {
        let controller = UIHostingController(rootView: content)
        let size = controller.view.intrinsicContentSize
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.backgroundColor = .clear
        
        let format = UIGraphicsImageRendererFormat(for: controller.traitCollection)
        format.opaque = isOpaque
        format.preferredRange = colorMode.range
        format.scale = scale
        
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        
        let image = renderer.image { context in
            controller.view.drawHierarchy(in: context.format.bounds, afterScreenUpdates: true)
        }
        
        image.accessibilityLabel = label
        objectWillChange.send()
        
        return image
    }
    
    #endif
}

#if os(macOS)
#else
extension ColorRenderingMode {
    var range: UIGraphicsImageRendererFormat.Range {
        switch self {
        case .extendedLinear: return .extended
        case .linear: return .standard
        default: return .automatic
        }
    }
}
#endif
