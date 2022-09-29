import SwiftUI

public struct SharePreview<Image, Icon> {
    let title: String
    var icon: () -> UIImage? = { nil }
    var image: () -> UIImage? = { nil }
    
    private init() { fatalError() }
}

public extension SharePreview {
    init<S: StringProtocol>(_ title: S) where Image == Never, Icon == Never {
        self.title = title.description
    }
    
    init<S: StringProtocol>(_ title: S, icon: Icon) where Icon: View, Image == Never {
        self.title = title.description
        self.icon = { ImageRenderer(content: icon).uiImage }
    }
    
    init<S: StringProtocol>(_ title: S, image: Image, icon: Icon) where Image: View, Icon: View {
        self.title = title.description
        self.image = { ImageRenderer(content: image).uiImage }
        self.icon = { ImageRenderer(content: icon).uiImage }
    }
}
