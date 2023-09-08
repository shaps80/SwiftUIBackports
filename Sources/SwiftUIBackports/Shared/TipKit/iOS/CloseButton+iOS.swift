import SwiftUI

#if os(iOS)
@available(iOS 13, *)
struct CloseButton_iOS: View {
    typealias Configuration = Backport<Any>.MiniTipViewStyle.Configuration
    
    @Environment(\.backportDismiss) private var dismiss
    let configuration: Configuration

    var body: some View {
        Button {
            dismissTip(configuration: configuration)
        } label: {
            Image(systemName: "xmark")
                .foregroundColor(Color(.quaternaryLabel))
                .font(.body.weight(.semibold))
        }
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
