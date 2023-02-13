import SwiftUI
import SwiftBackports

@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, deprecated: 14.0)
@available(watchOS, deprecated: 7.0)
extension Backport where Wrapped == Any {

    /// A progress view that visually indicates its progress using a horizontal bar.
    ///
    /// You can also use ``ProgressViewStyle/linear`` to construct this style.
    public struct LinearProgressViewStyle: BackportProgressViewStyle {

        /// Creates a linear progress view style.
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
#if os(macOS)
            VStack(alignment: .leading, spacing: 0) {
                configuration.label
                    .foregroundColor(.primary)

                LinearRepresentable(configuration: configuration)

                configuration.currentValueLabel
                    .foregroundColor(.secondary)
            }
            .controlSize(.small)
#else
            VStack(alignment: .leading, spacing: 5) {
                if configuration.fractionCompleted == nil {
                    CircularProgressViewStyle().makeBody(configuration: configuration)
                } else {
                    configuration.label?
                        .foregroundColor(.primary)

                    #if !os(watchOS)
                    LinearRepresentable(configuration: configuration)
                    #endif

                    configuration.currentValueLabel?
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
#endif
        }
    }
    
}

public extension BackportProgressViewStyle where Self == Backport<Any>.LinearProgressViewStyle {
    static var linear: Self { .init() }
}

#if os(macOS)
private struct LinearRepresentable: NSViewRepresentable {
    let configuration: Backport<Any>.ProgressViewStyleConfiguration

    func makeNSView(context: Context) -> NSProgressIndicator {
        .init()
    }

    func updateNSView(_ view: NSProgressIndicator, context: Context) {
        if let value = configuration.fractionCompleted {
            view.doubleValue = value
            view.maxValue = configuration.max
            
            view.display()
        }

        view.style = .bar
        view.isIndeterminate = configuration.fractionCompleted == nil
        view.isDisplayedWhenStopped = true
        view.startAnimation(nil)
    }
}
#elseif !os(watchOS)
private struct LinearRepresentable: UIViewRepresentable {
    let configuration: Backport<Any>.ProgressViewStyleConfiguration

    func makeUIView(context: Context) -> UIProgressView {
        .init(progressViewStyle: .default)
    }

    func updateUIView(_ view: UIProgressView, context: Context) {
        view.progress = Float(configuration.fractionCompleted ?? 0)
    }
}
#endif
