import SwiftUI
import SwiftBackports

public struct DefaultShareLinkLabel: View {
    let text: Text
    private static let shareIcon = "square.and.arrow.up"
    
    init() {
        text = .init("Share")
    }
    
    init<S: StringProtocol>(_ title: S) {
        text = .init(title)
    }
    
    init(_ titleKey: LocalizedStringKey) {
        text = .init(titleKey)
    }
    
    init(_ title: Text) {
        text = title
    }
    
    public var body: some View {
        if #available(iOS 14, macOS 11, watchOS 7, tvOS 14, *) {
            Label {
                text
            } icon: {
                Image(systemName: Self.shareIcon)
            }
        } else {
            Backport.Label {
                text
            } icon: {
                #if os(macOS)
                // no icon on earlier macOS versions
                if #available(macOS 11, *) {
                    Image(systemName: Self.shareIcon)
                }
                #else
                Image(systemName: Self.shareIcon)
                #endif
            }
        }
    }
}
