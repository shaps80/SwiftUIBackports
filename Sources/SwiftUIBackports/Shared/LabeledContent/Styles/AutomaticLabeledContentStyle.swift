import SwiftUI

extension Backport where Wrapped == Any {

    public struct AutomaticLabeledContentStyle: BackportLabeledContentStyle {
        public func makeBody(configuration: Configuration) -> some View {
            HStack(alignment: .firstTextBaseline) {
                configuration.label
                Spacer(minLength: 0)
                configuration.content
            }
        }
    }

}

extension BackportLabeledContentStyle where Self == Backport<Any>.AutomaticLabeledContentStyle {
    static var automatic: Self { .init() }
}
