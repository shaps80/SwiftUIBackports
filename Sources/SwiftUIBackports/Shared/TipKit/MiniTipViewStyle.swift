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

        @State private var isHovering: Bool = false

        public func makeBody(configuration: Configuration) -> some View {
#if os(iOS)
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline) {
                        configuration.tip.title
                            .font(.body.weight(.semibold))

                        Spacer()
                        Button {
                            dismiss()
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

                            let action = actions[index]
                            Button {
                                action.handler?()
                                configuration.action(action)
                            } label: {
                                action.label
                            }
                            .disabled(action.disabled)
                        }
                    }
                    .padding(.bottom, 3)
                    .foregroundColor(.accentColor)
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.vertical, 14)
            .padding(.horizontal, 13)
            .background(style: backgroundStyle, color: backgroundColor, placement: configuration.placement)
            .clipShape(RoundedRectangle(cornerRadius: corner.radius, style: .continuous), style: .init(antialiased: corner.antialiased))
            .buttonStyle(.plain)
#endif

#if os(macOS)
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 2) {
                    configuration.tip.title
                        .font(.body.weight(.bold))

                    configuration.tip.message
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }

                let actions = configuration.tip.actions
                if !actions.isEmpty {
                    HStack {
                        ForEach(actions.indices, id: \.self) { index in
                            let action = actions[index]
                            Button {
                                action.handler?()
                                configuration.action(action)
                            } label: {
                                action.label
                            }
                            .disabled(action.disabled)
                            .tag(action.id)
                            .id(action.id)
                        }
                    }
                    .padding(.bottom, 2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.vertical, 9)
            .padding(.horizontal, 13)
            .background(style: backgroundStyle, color: backgroundColor, placement: configuration.placement)
            .clipShape(RoundedRectangle(cornerRadius: corner.radius, style: .continuous), style: .init(antialiased: corner.antialiased))
            .backport.overlay(alignment: .topLeading) {
                if isHovering {
                    Button {
                        dismiss()
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
                    .offset(x: -6, y: -8)
                }
            }
            .padding(.vertical, configuration.placement == .inline ? 8 : 0)
            .onHover { isHovering = $0 }
#endif
        }
    }
}

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
private struct TipStyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: any BackportTipViewStyle { Backport.MiniTipViewStyle() }
}

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
internal extension EnvironmentValues {
    var tipStyle: any BackportTipViewStyle {
        get { self[TipStyleEnvironmentKey.self] }
        set { self[TipStyleEnvironmentKey.self] = newValue }
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
