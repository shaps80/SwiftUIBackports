import SwiftUI

extension Backport<Any> {
    @MainActor
    @preconcurrency public struct Subview: View, Identifiable {
        public struct ID: Hashable, @unchecked Sendable {
            var wrapped: AnyHashable
        }

        public let id: ID
        private let content: _VariadicView.Children.Element

        internal init(_ content: _VariadicView.Children.Element) {
            self.id = .init(wrapped: content.id)
            self.content = content
        }

        public var body: some View {
            content
        }
    }
}
