import SwiftUI
import SwiftBackports

@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, deprecated: 14.0)
@available(watchOS, deprecated: 7.0)
extension Backport where Wrapped == Any {

    /// A progress view that visually indicates its progress using a circular gauge.
    ///
    /// You can also use ``ProgressViewStyle/circular`` to construct this style.
    public struct CircularProgressViewStyle: BackportProgressViewStyle {

        /// Creates a circular progress view style.
        public init() { }

        /// Creates a view representing the body of a progress view.
        ///
        /// - Parameter configuration: The properties of the progress view being
        ///   created.
        ///
        /// The view hierarchy calls this method for each progress view where this
        /// style is the current progress view style.
        ///
        /// - Parameter configuration: The properties of the progress view, such as
        ///  its preferred progress type.
        public func makeBody(configuration: Configuration) -> some View {
            VStack {
                #if !os(watchOS)
                CircularRepresentable(configuration: configuration)
                #endif

                configuration.label?
                    .foregroundColor(.secondary)
            }
        }
    }

}

public extension BackportProgressViewStyle where Self == Backport<Any>.CircularProgressViewStyle {
    static var circular: Self { .init() }
}

#if os(macOS)
private struct CircularRepresentable: NSViewRepresentable {
    let configuration: Backport<Any>.ProgressViewStyleConfiguration

    func makeNSView(context: Context) -> NSProgressIndicator {
        .init()
    }

    func updateNSView(_ view: NSProgressIndicator, context: Context) {
        if let value = configuration.fractionCompleted {
            view.doubleValue = value
            view.maxValue = configuration.max
        }

        view.isIndeterminate = configuration.fractionCompleted == nil
        view.style = .spinning
        view.isDisplayedWhenStopped = true
        view.startAnimation(nil)
    }
}
#elseif !os(watchOS)
private struct CircularRepresentable: UIViewRepresentable {
    let configuration: Backport<Any>.ProgressViewStyleConfiguration

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        .init(style: .medium)
    }

    func updateUIView(_ view: UIActivityIndicatorView, context: Context) {
        view.hidesWhenStopped = false
        view.startAnimating()
    }
}
#endif
