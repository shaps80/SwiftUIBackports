import SwiftUI

public struct Backport<Content> {
    let content: Content

    public init(_ content: Content) {
        self.content = content
    }
}

public extension View {
    var backport: Backport<Self> { .init(self) }
}

public extension NSObjectProtocol {
    var backport: Backport<Self> { Backport(self) }
}
