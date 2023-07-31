import SwiftUI

@available(iOS 13, tvOS 13, macOS 11, watchOS 6, *)
extension Backport<Any> {
    /// The tip style for a minitip view.
    public struct MiniTipViewStyle: BackportTipViewStyle {
        @State private var isHovering: Bool = false
        @Environment(\.colorScheme) private var scheme

        public func makeBody(configuration: Configuration) -> some View {
#if os(iOS)
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline) {
                        configuration.tip.title
                            .font(.body.weight(.semibold))

                        Spacer()
                        Button {

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
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
            .padding(.vertical, 0)
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
            .background(Color.primary.opacity(0.055))
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
            .backport.overlay(alignment: .topLeading) {
                if isHovering {
                    Button {

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
            .padding(.vertical, 8)
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
