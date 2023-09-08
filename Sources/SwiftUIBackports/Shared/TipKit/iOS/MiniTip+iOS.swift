import SwiftUI

#if os(iOS)
@available(iOS 13, *)
struct MiniTip_iOS: View {
    typealias Configuration = Backport<Any>.MiniTipViewStyle.Configuration

    @Environment(\.tipAssetSize) private var assetSize
    @Environment(\.tipBackgroundStyle) private var backgroundStyle
    @Environment(\.tipBackgroundColor) private var backgroundColor
    @Environment(\.tipCorner) private var corner

    let configuration: Configuration
    
    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            configuration.tip.image?
                .resizable()
                .scaledToFit()
                .frame(width: assetSize.width, height: assetSize.height)
                .foregroundColor(.accentColor)
                .padding(.top, 6)
                .font(.body.weight(.regular))

            VStack(alignment: .leading, spacing: configuration.tip.image == nil ? 10 : 16) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline) {
                        configuration.tip.title
                            .font(.body.weight(.semibold))

                        Spacer()

                    }

                    configuration.tip.message
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }

                let actions = configuration.tip.actions
                if !actions.isEmpty {
                    VStack(alignment: .leading, spacing: 11) {
                        ForEach(actions.indices, id: \.self) { index in
                            Divider()
                                .padding(.trailing, -13)

                            let action = actions[index]
                            Button {
                                configuration.action(action)
                                action.handler?()
                                configuration.tip.invalidate(reason: .actionPerformed)
                            } label: {
                                action.label
                                    .font(.body.weight(index == 0 ? .semibold : .regular))
                            }
                            .disabled(action.disabled)
                        }
                    }
                    .padding(.bottom, 2)
                    .foregroundColor(.accentColor)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.vertical, 12)
        .padding(.horizontal, 13)
        .background(style: backgroundStyle, color: backgroundColor, placement: configuration.placement)
        .clipShape(RoundedRectangle(cornerRadius: corner.radius, style: .continuous), style: .init(antialiased: corner.antialiased))
        .buttonStyle(.plain)
        .transition(.identity)
    }
}
#endif
