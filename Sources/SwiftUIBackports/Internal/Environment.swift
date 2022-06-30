import SwiftUI

/*
 The following code is designed to try and best-guess what SwifUI may be inteferring
 in order to support some features. Use these carefully and wherever possible,
 with reasonable fallbacks. See examples below for ideas.
 */

internal extension EnvironmentValues {
    var hasToolbarPlacement: Bool {
        "\(self)".contains("ToolbarItemPlacementKey")
    }
}

#if DEBUG
extension EnvironmentValues: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(self)"
            .trimmingCharacters(in: .init(["[", "]"]))
            .replacingOccurrences(of: "EnvironmentPropertyKey", with: "")
            .replacingOccurrences(of: ", ", with: "\n")
    }
}

struct EnvironmentOutputModifier: ViewModifier {
    @Environment(\.self) private var environment

    func body(content: Content) -> some View {
        content
            .onAppear {
                print(environment.debugDescription)
            }
    }
}
extension View {
    func printEnvironment() -> some View {
        modifier(EnvironmentOutputModifier())
    }
}
#endif
