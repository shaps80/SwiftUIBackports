import SwiftUI

/// Provides optional inset values. `nil` is interpreted as: use system default
internal struct ProposedInsets: Equatable {

    /// The proposed leading margin measured in points.
    ///
    /// A value of `nil` tells the system to use a default value
    public var leading: CGFloat?

    /// The proposed trailing margin measured in points.
    ///
    /// A value of `nil` tells the system to use a default value
    public var trailing: CGFloat?

    /// The proposed top margin measured in points.
    ///
    /// A value of `nil` tells the system to use a default value
    public var top: CGFloat?

    /// The proposed bottom margin measured in points.
    ///
    /// A value of `nil` tells the system to use a default value
    public var bottom: CGFloat?

    /// An insets proposal with all dimensions left unspecified.
    public static var unspecified: ProposedInsets { .init() }

    /// An insets proposal that contains zero for all dimensions.
    public static var zero: ProposedInsets { .init(leading: 0, trailing: 0, top: 0, bottom: 0) }

}
