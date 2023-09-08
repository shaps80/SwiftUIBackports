import SwiftUI

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
extension Backport<Any> {
    /// The tip style for a minitip view.
    public struct MiniTipViewStyle: BackportTipViewStyle {
        @Environment(\.backportDismiss) private var dismiss
        @Environment(\.colorScheme) private var scheme
        @Environment(\.tipCorner) private var corner
        @Environment(\.tipAssetSize) private var assetSize
        @Environment(\.tipBackgroundStyle) private var backgroundStyle
        @Environment(\.tipBackgroundColor) private var backgroundColor
        @Environment(\.font) private var font

        @State private var isHovering: Bool = false

        /**
         This should be broken up into multiple pieces.

             1. Top level should be a conditional view that accepts a tip or a tip.id
                This will enable us to show/hide the tip depending on some rule

             2. Then for each platform we should create a separate dedicated view since the
                layouts differ in many ways. This can then also accept a configuration
         */

        public func makeBody(configuration: Configuration) -> some View {
            Group {
                if (configuration.placement == .inline && configuration.tip.shouldDisplay) || configuration.placement == .popover {
#if os(iOS)
                    iOS(configuration: configuration)
#endif

#if os(macOS)
                    macOS(configuration: configuration)
#endif
                }
            }
        }

#if os(macOS)
        private func macOS(configuration: Configuration) -> some View {
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
                            closeButton(configuration: configuration)
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
                    closeButton(configuration: configuration)
                        .offset(x: -6, y: -8)
                }
            }
            .padding(.vertical, 4)
            .onHover { isHovering = $0 }
            .transition(.identity)
        }
#endif

#if os(iOS)
        private func iOS(configuration: Configuration) -> some View {
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
                            Button {
                                dismissTip(configuration: configuration)
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color(.quaternaryLabel))
                                    .font(.body.weight(.semibold))
                            }
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
#endif

#if os(macOS)
        private func closeButton(configuration: Configuration) -> some View {
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
#endif

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
}

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
private extension View {
    @ViewBuilder
    func background(style: any ShapeStyle, color: Color, placement: Backport<Any>.TipViewStyleConfiguration.Placement) -> some View {
        backport.background {
            if #available(iOS 16.4, tvOS 16.4, macOS 13.3, watchOS 9.4, *) {
                Rectangle()
                    .foregroundStyle(placement == .inline ? AnyShapeStyle(style) : AnyShapeStyle(.clear))
#if os(iOS)
                    .presentationBackground(AnyShapeStyle(style))
#endif
                    .presentationCompactAdaptation(.popover)
            } else if #available(iOS 15, macOS 12, *) {
                Rectangle()
                    .foregroundStyle(AnyShapeStyle(style))
            } else {
                Rectangle()
                    .foregroundColor(color)
            }
        }
    }
}
