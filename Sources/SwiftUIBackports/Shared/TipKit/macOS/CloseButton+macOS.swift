import SwiftUI

#if os(macOS)
@available(macOS 11, *)
struct CloseButton_macOS: View {
    typealias Configuration = Backport<Any>.MiniTipViewStyle.Configuration

    @Environment(\.backportDismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme
    let configuration: Configuration

    var body: some View {
        Button {
            dismissTip(configuration: configuration)
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(Color(scheme == .dark ? .underPageBackgroundColor : .windowBackgroundColor))
                    .frame(width: 21, height: 21)
                    .shadow(color: .primary.opacity(0.5), radius: 1, x: 0.0, y: 0.0)

                Image(systemName: "xmark")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.primary.opacity(scheme == .dark ? 1 : 0.8))
            }
        }
        .buttonStyle(.plain)
    }

    private func dismissTip(configuration: Configuration) {
        if configuration.placement == .popover {
            dismiss()
        } else {
            withAnimation {
                configuration.tip.invalidate(reason: .tipClosed)
            }
        }
    }
}
#endif
