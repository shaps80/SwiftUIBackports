#if os(iOS)
import SwiftUI
import UIKit
import Foundation

@available(iOS 13, *)
struct MiniTip_iOS: View {
    typealias Configuration = Backport<Any>.MiniTipViewStyle.Configuration

    @Environment(\.tipAssetSize) private var assetSize
    @Environment(\.tipBackgroundStyle) private var backgroundStyle
    @Environment(\.tipBackgroundColor) private var backgroundColor
    @Environment(\.tipCorner) private var corner

    let configuration: Configuration
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            makeImage(named: configuration.tip.imageName)?
                .resizable()
                .scaledToFit()
                .frame(width: assetSize.width, height: assetSize.height)
                .foregroundColor(Color.accentColor)
                .padding(Edge.Set.top, 6)
                .font(Font.body.weight(.regular))
                .padding(.trailing, 12)
            
            let actions = configuration.tip.actions
            VStack(alignment: .leading, spacing: makeImage(named: configuration.tip.imageName) == nil ? 10 : 16) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(configuration.tip.title)
                            .font(.body.weight(.semibold))

                        Spacer()
                    }

                    if let message = configuration.tip.message {
                        Text(message + " *Legacy*")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                }
                /*
                 TODO: Work with this
                if !actions.isEmpty {
                    VStack(alignment: .leading, spacing: 11) {
                        ForEach(actions.indices, id: \.self) { idx in
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
                 */
            }
            if actions.isEmpty {
                Button {
                    NotificationCenter.default.post(
                        name: .backportTipDidClose,
                        object: configuration.tip
                    )
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.bold())
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.vertical, 12)
        .padding(.horizontal, 13)
        .background(
            style: backgroundStyle,
            color: backgroundColor,
            placement: configuration.placement
        )
        .clipShape(RoundedRectangle(cornerRadius: corner.radius, style: .continuous), style: .init(antialiased: corner.antialiased))
        .buttonStyle(.plain)
        .transition(.identity)
    }
    
    private func makeImage(named name: String?) -> Image? {
        guard let name else { return nil }
        if name.isSFSymbol {
            return Image(systemName: name)
        } else if name.isAssetImage {
            return Image(name)
        } else {
            return nil
        }
    }
}
#endif
