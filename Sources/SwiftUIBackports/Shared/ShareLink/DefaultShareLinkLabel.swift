import SwiftUI

public struct DefaultShareLinkLabel: View {
    let text: Text
    
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
        Backport.Label {
            text
        } icon: {
            Image(systemName: "square.and.arrow.up")
        }
    }
}
