import SwiftUI
import SwiftBackports

@available(iOS, deprecated: 17, message: "Use SwiftUI.ContentUnavailableView instead")
@available(tvOS, deprecated: 17, message: "Use SwiftUI.ContentUnavailableView instead")
@available(macOS, deprecated: 14, message: "Use SwiftUI.ContentUnavailableView instead")
@available(watchOS, deprecated: 10, message: "Use SwiftUI.ContentUnavailableView instead")
extension Backport<Any> {
    public struct ContentUnavailableView<Label: View, Description: View, Actions: View>: View {
        let label: Label
        let description: Description
        let actions: Actions

        public init(
            @ViewBuilder label: () -> Label,
            @ViewBuilder description: () -> Description = { EmptyView() },
            @ViewBuilder actions: () -> Actions = { EmptyView() }
        ) {
            self.label = label()
            self.description = description()
            self.actions = actions()
        }

        public var body: some View {
            VStack(spacing: 20) {
                VStack {
                    label
                        .backport.labelStyle(.contentUnavailable)

                    description
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }

                if #available(iOS 16, tvOS 16, macOS 13, watchOS 9, *) {
                    ViewThatFits {
                        HStack { actions }
                        VStack { actions }
                    }
                    .font(.subheadline)
                } else {
                    VStack { actions }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .extendBackground()
            .padding()
        }
    }
}

private extension View {
    @ViewBuilder
    func extendBackground() -> some View {
        if #available(iOS 26, tvOS 26, macOS 26, watchOS 26, *) {
            backgroundExtensionEffect()
        } else {
            self
        }
    }
}

public extension Backport<Any>.ContentUnavailableView where Label == Text, Description == Text?, Actions == EmptyView {
    init(
        _ titleKey: LocalizedStringKey,
        description: LocalizedStringKey? = nil
    ) {
        self.label = Text(titleKey)
        self.description = description.flatMap { Text($0) }
        self.actions = EmptyView()
    }
}

public extension Backport<Any>.ContentUnavailableView where Label == Backport<Any>.Label<Text, SwiftUI.Image>, Description == Text?, Actions == EmptyView {
    init(
        _ titleKey: LocalizedStringKey,
        image name: String,
        description: Text? = nil
    ) {
        self.label = .init(titleKey, image: name)
        self.description = description.flatMap { $0 }
        self.actions = EmptyView()
    }

    init(
        _ titleKey: LocalizedStringKey,
        systemImage name: String,
        description: Text? = nil
    ) {
        self.label = Backport.Label(titleKey, systemImage: name)
        self.description = description.flatMap { $0 }
        self.actions = EmptyView()
    }
}

private extension BackportLabelStyle where Self == ContentUnavailableLabelStyle {
    static var contentUnavailable: Self { .init() }
}

private struct ContentUnavailableLabelStyle: BackportLabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 10) {
            configuration.icon
                .foregroundColor(.secondary)
                .font(.largeTitle.weight(.medium))
                .largeImage()

            if #available(iOS 14, tvOS 14, macOS 11, watchOS 7, *) {
                configuration.title
                    .font(.title2.weight(.bold))
            } else {
                configuration.title
                    .font(.title.weight(.semibold))
            }
        }
    }
}

private extension View {
    @ViewBuilder
    func largeImage() -> some View {
#if os(iOS)
        imageScale(.large)
#else
        if #available(macOS 11, *) {
            imageScale(.large)
        } else {
            self
        }
#endif
    }
}

#Preview {
    VStack {
        Backport.ContentUnavailableView {
            Backport.Label("Backport", systemImage: "star")
        } description: {
            Text("A description for the placeholder")
        } actions: {
            Button("Primary") { }
            Button("Secondary") { }
        }
        .background(Color.gray.opacity(0.3))
        .padding()

        Divider()

        if #available(iOS 17, tvOS 17, macOS 14, watchOS 10, *) {
            ContentUnavailableView {
                Label("Native", systemImage: "star")
            } description: {
                Text("A description for the placeholder")
            } actions: {
                Button("Primary") { }
                Button("Secondary") { }
            }
            .background(Color.gray.opacity(0.3))
            .padding()
        }
    }
}
