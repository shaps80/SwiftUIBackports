import SwiftUI

public extension View {
    @MainActor
    func variadic<R: View>(@ViewBuilder _ transform: @escaping (_VariadicView.Children) -> R) -> some View {
        _VariadicView.Tree(Helper(transform: transform)) { self }
    }
}

@MainActor
struct Helper<R: View>: _VariadicView.MultiViewRoot {
    var transform: (_VariadicView.Children) -> R

    func body(children: _VariadicView.Children) -> some View {
        transform(children)
    }
}
