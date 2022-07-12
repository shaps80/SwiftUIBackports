import SwiftUI

extension Backport where Wrapped == Any {

    public struct AutomaticLabeledContentStyle: BackportLabeledContentStyle {
        @Namespace private var namespace

        public func makeBody(configuration: Configuration) -> some View {
            VStack(alignment: .leading, spacing: 2) {
                configuration.label
                    .foregroundColor(.secondary)
                configuration.content
            }
        }
    }

}

extension BackportLabeledContentStyle where Self == Backport<Any>.AutomaticLabeledContentStyle {
    static var automatic: Self { .init() }
}
