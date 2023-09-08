import SwiftUI
import SwiftBackports

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
extension Backport<Any> {
    /// The tip style for a minitip view.
    public struct MiniTipViewStyle: BackportTipViewStyle {
        public func makeBody(configuration: Configuration) -> some View {
            ConfiguredMiniTipView(configuration: configuration)
        }
    }
}

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
struct ConfiguredMiniTipView: View {
    typealias Configuration = Backport<Any>.MiniTipViewStyle.Configuration
    @Tip var tip: Backport<Any>.AnyTip
    let configuration: Configuration

    init(configuration: Configuration) {
        _tip = .init(tip: .init(configuration.tip))
        self.configuration = configuration
    }

    var body: some View {
        Group {
            if (configuration.placement == .inline && tip.shouldDisplay) || configuration.placement == .popover {
#if os(iOS)
                MiniTip_iOS(configuration: configuration)
#endif

#if os(macOS)
                MiniTip_macOS(configuration: configuration)
#endif
            }
        }
    }
}
