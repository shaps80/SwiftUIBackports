import SwiftUI

#if os(iOS) || os(tvOS)
@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension Backport where Content == Any {

    /**
     A content configuration suitable for hosting a hierarchy of SwiftUI views.
     Use a value of this type, which conforms to the UIContentConfiguration protocol, with a UICollectionViewCell or UITableViewCell to host a hierarchy of SwiftUI views in a collection or table view, respectively. For example, the following shows a stack with an image and text inside the cell:

         myCell.contentConfiguration = UIHostingConfiguration {
            HStack {
                Image(systemName: "star").foregroundStyle(.purple)
                Text("Favorites")
                Spacer()
            }
         }

     You can also customize the background of the containing cell. The following example draws a blue background:

         myCell.contentConfiguration = UIHostingConfiguration {
            HStack {
                Image(systemName: "star").foregroundStyle(.purple)
                Text("Favorites")
                Spacer()
            }
         }
         .background {
            Color.blue
         }
     */
    public struct UIHostingConfiguration<Label, Background>: BackportUIContentConfiguration where Label: View, Background: View {

        var content: Label
        var background: AnyView?
        var insets: ProposedInsets
        var minSize: ProposedSize

        /// Sets the background contents for the hosting configuration's enclosing
        /// cell.
        ///
        /// The following example sets a custom view to the background of the cell:
        ///
        ///     UIHostingConfiguration {
        ///         Text("My Contents")
        ///     }
        ///     .background {
        ///         MyBackgroundView()
        ///     }
        ///
        /// - Parameter background: The contents of the SwiftUI hierarchy to be
        ///   shown inside the background of the cell.
        public func background<B>(@ViewBuilder background: () -> B) -> Backport.UIHostingConfiguration<Label, B> where B: View {
            .init(content: self.content, background: AnyView(background()), insets: insets, minSize: minSize)
        }

        /// Sets the background contents for the hosting configuration's enclosing
        /// cell.
        ///
        /// The following example sets a custom view to the background of the cell:
        ///
        ///     UIHostingConfiguration {
        ///         Text("My Contents")
        ///     }
        ///     .background(Color.blue)
        ///
        /// - Parameter style: The shape style to be used as the background of the
        ///   cell.
        public func background<S>(_ style: S) -> Backport.UIHostingConfiguration<Label, S> where S: ShapeStyle {
            .init(content: self.content, background: AnyView(style), insets: insets, minSize: minSize)
        }

        /// Initializes and returns a new instance of the content view using this configuration.
        public func makeContentView() -> UIView {
            let view = UIHostingController(
                rootView: ZStack {
                    background
                    content
                },
                ignoreSafeArea: true
            ).view!

            view.backgroundColor = .clear
            view.clipsToBounds = false

            return view
        }

    }
    
}

extension Backport.UIHostingConfiguration {

    /// Sets the margins around the content of the configuration.
    ///
    /// Use this modifier to replace the default margins applied to the root of
    /// the configuration. The following example creates 20 points of space
    /// between the content and the background on the horizontal edges.
    ///
    ///     UIHostingConfiguration {
    ///         Text("My Contents")
    ///     }
    ///     .margins(.horizontal, 20.0)
    ///
    /// - Parameters:
    ///    - edges: The edges to apply the insets. Any edges not specified will
    ///      use the system default values. The default value is
    ///      ``Edge/Set/all``.
    ///    - length: The amount to apply.
    public func margins(_ edges: Edge.Set = .all, _ length: CGFloat) -> Self {
        var view = self
        if edges.contains(.leading) { view.insets.leading = length }
        if edges.contains(.trailing) { view.insets.trailing = length }
        if edges.contains(.top) { view.insets.top = length }
        if edges.contains(.bottom) { view.insets.bottom = length }
        return view
    }

    /// Sets the margins around the content of the configuration.
    ///
    /// Use this modifier to replace the default margins applied to the root of
    /// the configuration. The following example creates 10 points of space
    /// between the content and the background on the leading edge and 20 points
    /// of space on the trailing edge:
    ///
    ///     UIHostingConfiguration {
    ///         Text("My Contents")
    ///     }
    ///     .margins(.horizontal, 20.0)
    ///
    /// - Parameters:
    ///    - edges: The edges to apply the insets. Any edges not specified will
    ///      use the system default values. The default value is
    ///      ``Edge/Set/all``.
    ///    - insets: The insets to apply.
    public func margins(_ edges: Edge.Set = .all, _ insets: EdgeInsets) -> Self {
        var view = self
        if edges.contains(.leading) { view.insets.leading = insets.leading }
        if edges.contains(.trailing) { view.insets.trailing = insets.trailing }
        if edges.contains(.top) { view.insets.top = insets.top }
        if edges.contains(.bottom) { view.insets.bottom = insets.bottom }
        return view
    }

    /// Sets the minimum size for the configuration.
    ///
    /// Use this modifier to indicate that a configuration's associated cell can
    /// be resized to a specific minimum. The following example allows the cell
    /// to be compressed to zero size:
    ///
    ///     UIHostingConfiguration {
    ///         Text("My Contents")
    ///     }
    ///     .minSize(width: 0, height: 0)
    ///
    /// - Parameter width: The value to use for the width dimension. A value of
    ///   `nil` indicates that the system default should be used.
    /// - Parameter height: The value to use for the height dimension. A value
    ///   of `nil` indicates that the system default should be used.
//    public func minSize(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
//        var view = self
//        view.minSize = .init(width: width, height: height)
//        return view
//    }

}

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension Backport.UIHostingConfiguration where Content == Any, Background == EmptyView {

    /// Creates a hosting configuration with the given contents.
    ///
    /// - Parameter content: The contents of the SwiftUI hierarchy to be shown
    ///   inside the cell.
    public init(@ViewBuilder content: () -> Label) {
        self.init(content: content(), background: nil, insets: .init(), minSize: .unspecified)
    }

}
#endif
