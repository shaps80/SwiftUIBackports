import SwiftUI
import SwiftBackports

struct InspectorView<Content: View, Inspector: View>: View {
    @Environment(\.inspectorDimensions) private var dimensions
    @Environment(\.horizontalSizeClass) private var sizeClass

    @Binding var isPresented: Bool
    @State private var showInSheet: Bool = false

    let content: Content
    @ViewBuilder let inspector: Inspector

    private func contentWidth(in geo: GeometryProxy) -> CGFloat {
        guard sizeClass == .regular else { return geo.size.width }
        return isPresented ? geo.size.width - dimensions.ideal : geo.size.width
    }

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                let width = contentWidth(in: geo)
                content
                    .frame(minWidth: width, idealWidth: width, maxWidth: width)

                if sizeClass == .regular {
                    Divider()
                        .edgesIgnoringSafeArea(.all)

                    inspector
                        .frame(
                            minWidth: dimensions.min,
                            idealWidth: dimensions.ideal,
                            maxWidth: dimensions.max
                        )
                        .environment(\.horizontalSizeClass, .compact)
                }
            }
        }
        .animation(.spring(), value: isPresented)
        .sheet(isPresented: $showInSheet) { inspector }
        .backport.onChange(of: sizeClass) { newValue in
            showInSheet = newValue == .compact && isPresented
        }
        .backport.onChange(of: isPresented) { newValue in
            showInSheet = sizeClass == .compact && isPresented
        }
        .onAppear {
            showInSheet = sizeClass == .compact && isPresented
        }
    }
}

private extension View {
    @ViewBuilder
    func extendedPresentation() -> some View {
        if #available(iOS 15, macOS 12, *) {
            self
                .backport.presentationBackgroundInteraction(.enabled)
                .backport.presentationDetents([.medium])
        } else {
            self
        }
    }
}
