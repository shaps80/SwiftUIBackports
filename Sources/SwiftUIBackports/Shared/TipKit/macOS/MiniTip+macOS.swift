import SwiftUI

#if os(macOS)
@available(macOS 11, *)
struct MiniTip_macOS: View {
    typealias Configuration = Backport<Any>.MiniTipViewStyle.Configuration

    @Environment(\.tipCorner) private var corner
    @Environment(\.tipAssetSize) private var assetSize
    @Environment(\.tipBackgroundStyle) private var backgroundStyle
    @Environment(\.tipBackgroundColor) private var backgroundColor
    @State private var isHovering: Bool = false

    let configuration: Configuration
    
    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            configuration.tip.image?
                .resizable()
                .scaledToFit()
                .frame(width: assetSize.width, height: assetSize.height)
                .foregroundColor(.accentColor)
                .font(.body.weight(.regular))

            VStack(alignment: .leading, spacing: configuration.tip.image == nil ? 0 : 24) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 2) {
                        configuration.tip.title
                            .font(.body.weight(.bold))

                        configuration.tip.message
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }

                    Spacer()

                    if configuration.placement == .popover {
                        CloseButton_macOS(configuration: configuration)
                    }
                }

                let actions = configuration.tip.actions
                if !actions.isEmpty {
                    VStack {
                        HStack {
                            ForEach(actions.indices, id: \.self) { index in
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
                                .tag(action.id)
                                .id(action.id)
                            }
                        }
                        .padding(.bottom, 2)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.vertical, 9)
        .padding(.horizontal, 13)
        .background(style: backgroundStyle, color: backgroundColor, placement: configuration.placement)
        .clipShape(RoundedRectangle(cornerRadius: corner.radius, style: .continuous), style: .init(antialiased: corner.antialiased))
        .backport.overlay(alignment: .topLeading) {
            if isHovering && configuration.placement == .inline {
                CloseButton_macOS(configuration: configuration)
                    .offset(x: -6, y: -8)
            }
        }
        .padding(.vertical, 4)
        .onHover { isHovering = $0 }
        .transition(.identity)
    }
}
#endif
