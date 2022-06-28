import SwiftUI

@available(iOS, deprecated: 15.0)
public extension Backport where Content == Any {

    /// Loads and displays an image from the specified URL.
    ///
    /// Until the image loads, SwiftUI displays a default placeholder. When
    /// the load operation completes successfully, SwiftUI updates the
    /// view to show the loaded image. If the operation fails, SwiftUI
    /// continues to display the placeholder. The following example loads
    /// and displays an icon from an example server:
    ///
    ///     AsyncImage(url: URL(string: "https://example.com/icon.png"))
    ///
    /// If you want to customize the placeholder or apply image-specific
    /// modifiers --- like ``Image/resizable(capInsets:resizingMode:)`` ---
    /// to the loaded image, use the ``init(url:scale:content:placeholder:)``
    /// initializer instead.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to display.
    ///   - scale: The scale to use for the image. The default is `1`. Set a
    ///     different value when loading images designed for higher resolution
    ///     displays. For example, set a value of `2` for an image that you
    ///     would name with the `@2x` suffix if stored in a file on disk.
    @ViewBuilder
    static func AsyncImage(url: URL?, scale: CGFloat = 1) -> some View {
        _AsyncImage(url: url, scale: scale)
    }

    /// Loads and displays a modifiable image from the specified URL using
    /// a custom placeholder until the image loads.
    ///
    /// Until the image loads, SwiftUI displays the placeholder view that
    /// you specify. When the load operation completes successfully, SwiftUI
    /// updates the view to show content that you specify, which you
    /// create using the loaded image. For example, you can show a green
    /// placeholder, followed by a tiled version of the loaded image:
    ///
    ///     AsyncImage(url: URL(string: "https://example.com/icon.png")) { image in
    ///         image.resizable(resizingMode: .tile)
    ///     } placeholder: {
    ///         Color.green
    ///     }
    ///
    /// If the load operation fails, SwiftUI continues to display the
    /// placeholder. To be able to display a different view on a load error,
    /// use the ``init(url:scale:transaction:content:)`` initializer instead.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to display.
    ///   - scale: The scale to use for the image. The default is `1`. Set a
    ///     different value when loading images designed for higher resolution
    ///     displays. For example, set a value of `2` for an image that you
    ///     would name with the `@2x` suffix if stored in a file on disk.
    ///   - content: A closure that takes the loaded image as an input, and
    ///     returns the view to show. You can return the image directly, or
    ///     modify it as needed before returning it.
    ///   - placeholder: A closure that returns the view to show until the
    ///     load operation completes successfully.
    @ViewBuilder
    static func AsyncImage<I: View, P: View>(url: URL?, scale: CGFloat = 1, @ViewBuilder content: @escaping (Image) -> I, @ViewBuilder placeholder: @escaping () -> P) -> some View {
        _AsyncImage(url: url, scale: scale, content: content, placeholder: placeholder)
    }

    /// Loads and displays a modifiable image from the specified URL in phases.
    ///
    /// If you set the asynchronous image's URL to `nil`, or after you set the
    /// URL to a value but before the load operation completes, the phase is
    /// ``AsyncImagePhase/empty``. After the operation completes, the phase
    /// becomes either ``AsyncImagePhase/failure(_:)`` or
    /// ``AsyncImagePhase/success(_:)``. In the first case, the phase's
    /// ``AsyncImagePhase/error`` value indicates the reason for failure.
    /// In the second case, the phase's ``AsyncImagePhase/image`` property
    /// contains the loaded image. Use the phase to drive the output of the
    /// `content` closure, which defines the view's appearance:
    ///
    ///     AsyncImage(url: URL(string: "https://example.com/icon.png")) { phase in
    ///         if let image = phase.image {
    ///             image // Displays the loaded image.
    ///         } else if phase.error != nil {
    ///             Color.red // Indicates an error.
    ///         } else {
    ///             Color.blue // Acts as a placeholder.
    ///         }
    ///     }
    ///
    /// To add transitions when you change the URL, apply an identifier to the
    /// ``AsyncImage``.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to display.
    ///   - scale: The scale to use for the image. The default is `1`. Set a
    ///     different value when loading images designed for higher resolution
    ///     displays. For example, set a value of `2` for an image that you
    ///     would name with the `@2x` suffix if stored in a file on disk.
    ///   - transaction: The transaction to use when the phase changes.
    ///   - content: A closure that takes the load phase as an input, and
    ///     returns the view to display for the specified phase.
    @ViewBuilder
    static func AsyncImage<Content: View>(url: URL?, scale: CGFloat = 1, transaction: Transaction = Transaction(), @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) -> some View {
        _AsyncImage(url: url, scale: scale, transaction: transaction, content: content)
    }

    /// The current phase of the asynchronous image loading operation.
    ///
    /// When you create an ``AsyncImage`` instance with the
    /// ``AsyncImage/init(url:scale:transaction:content:)`` initializer, you define
    /// the appearance of the view using a `content` closure. SwiftUI calls the
    /// closure with a phase value at different points during the load operation
    /// to indicate the current state. Use the phase to decide what to draw.
    /// For example, you can draw the loaded image if it exists, a view that
    /// indicates an error, or a placeholder:
    ///
    ///     AsyncImage(url: URL(string: "https://example.com/icon.png")) { phase in
    ///         if let image = phase.image {
    ///             image // Displays the loaded image.
    ///         } else if phase.error != nil {
    ///             Color.red // Indicates an error.
    ///         } else {
    ///             Color.blue // Acts as a placeholder.
    ///         }
    ///     }
    enum AsyncImagePhase {
        /// No image is loaded.
        case empty
        /// An image succesfully loaded.
        case success(Image)
        /// An image failed to load with an error.
        case failure(Error)

        /// The loaded image, if any.
        public var image: Image? {
            guard case let .success(image) = self else { return nil }
            return image
        }

        /// The error that occurred when attempting to load an image, if any.
        public var error: Error? {
            guard case let .failure(error) = self else { return nil }
            return error
        }
    }

    // An iOS 13+ async/await backport implementation
    private struct _AsyncImage<Content: View>: View {
        @State private var phase: AsyncImagePhase = .empty

        var url: URL?
        var scale: CGFloat = 1
        var transaction: Transaction = .init()
        var content: (Backport<Any>.AsyncImagePhase) -> Content

        public var body: some View {
            ZStack {
                content(phase)
            }
            .backport.task(id: url) {
                do {
                    guard !Task.isCancelled, let url = url else { return }
                    let (data, _) = try await URLSession.shared.backport.data(from: url)
                    guard !Task.isCancelled else { return }

                    #if os(macOS)
                    if let image = NSImage(data: data) {
                        withTransaction(transaction) {
                            phase = .success(Image(nsImage: image))
                        }
                    }
                    #else
                    if let image = UIImage(data: data, scale: scale) {
                        withTransaction(transaction) {
                            phase = .success(Image(uiImage: image))
                        }
                    }
                    #endif
                } catch {
                    phase = .failure(error)
                }
            }
        }

        init(url: URL?, scale: CGFloat = 1) where Content == AnyView {
            self.url = url
            self.scale = scale
            self.content = { AnyView($0.image) }
        }

        init<I, P>(url: URL?, scale: CGFloat = 1, @ViewBuilder content: @escaping (Image) -> I, @ViewBuilder placeholder: @escaping () -> P) where Content == _ConditionalContent<I, P> {
            self.url = url
            self.scale = scale
            self.transaction = Transaction()
            self.content = { phase -> _ConditionalContent<I, P> in
                if let image = phase.image {
                    return ViewBuilder.buildEither(first: content(image))
                } else {
                    return ViewBuilder.buildEither(second: placeholder())
                }
            }
        }

        init(url: URL?, scale: CGFloat = 1, transaction: Transaction = Transaction(), @ViewBuilder content: @escaping (Backport<Any>.AsyncImagePhase) -> Content) {
            self.url = url
            self.scale = scale
            self.transaction = transaction
            self.content = content
        }
    }

}
