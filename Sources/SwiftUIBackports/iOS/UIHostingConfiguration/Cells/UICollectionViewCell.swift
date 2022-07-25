import SwiftUI
import ObjectiveC

#if os(iOS) || os(tvOS)

extension UICollectionViewCell {
    
    private static var configuredViewAssociatedKey: Void?
    
    fileprivate var configuredView: UIView? {
        get { objc_getAssociatedObject(self, &Self.configuredViewAssociatedKey) as? UIView }
        set { objc_setAssociatedObject(self, &Self.configuredViewAssociatedKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
}

@available(iOS, deprecated: 14)
@available(tvOS, deprecated: 14)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension Backport where Wrapped: UICollectionViewCell {

    /// The current content configuration of the cell.
    ///
    /// Setting a content configuration replaces the existing contentView of the
    /// cell with a new content view instance from the configuration.
    public var contentConfiguration: BackportUIContentConfiguration? {
        get { nil } // we can't really support anything here, so for now we'll return nil
        nonmutating set {
            content.configuredView?.removeFromSuperview()

            guard let configuration = newValue else { return }
            let contentView = content.contentView

            let configuredView = configuration.makeContentView()
            configuredView.translatesAutoresizingMaskIntoConstraints = false

            content.clipsToBounds = false
            contentView.clipsToBounds = false
            contentView.preservesSuperviewLayoutMargins = false
            contentView.addSubview(configuredView)

            let insets = Mirror(reflecting: configuration)
                .children.first(where: { $0.label == "insets" })?.value as? ProposedInsets
            ?? .unspecified

            insets.top.flatMap { contentView.directionalLayoutMargins.top = $0 }
            insets.bottom.flatMap { contentView.directionalLayoutMargins.bottom = $0 }
            insets.leading.flatMap { contentView.directionalLayoutMargins.leading = $0 }
            insets.trailing.flatMap { contentView.directionalLayoutMargins.trailing = $0 }

            NSLayoutConstraint.activate([
                configuredView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
                configuredView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                configuredView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
                configuredView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            ])

            var background: AnyView? {
                Mirror(reflecting: configuration)
                    .children.first(where: { $0.label == "background" })?.value as? AnyView
            }

            background.flatMap {
                let host = UIHostingController(rootView: $0, ignoreSafeArea: true)
                content.backgroundView = host.view
            }

            background.flatMap {
                let host = UIHostingController(rootView: $0, ignoreSafeArea: true)
                content.selectedBackgroundView = host.view
            }

            content.configuredView = configuredView
        }
    }

}
#endif
