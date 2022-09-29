import SwiftUI

public struct ProposedViewSize: Equatable, Sendable {
    public var width: CGFloat?
    public var height: CGFloat?
    
    public static let zero = Self(width: 0, height: 0)
    public static let infinity = Self(width: .infinity, height: .infinity)
    public static let unspecified = Self(width: nil, height: nil)
    
    public init(_ size: CGSize) {
        self.width = size.width
        self.height = size.height
    }
    
    public init(width: CGFloat?, height: CGFloat?) {
        self.width = width
        self.height = height
    }
    
    public func replacingUnspecifiedDimensions(by size: CGSize) -> CGSize {
        .init(
            width: width ?? size.width, 
            height: height ?? size.height
        )
    }
}
