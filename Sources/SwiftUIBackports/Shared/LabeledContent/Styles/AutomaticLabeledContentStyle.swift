import SwiftUI
import SwiftBackports

extension Backport where Wrapped == Any {

    public struct AutomaticLabeledContentStyle: BackportLabeledContentStyle {
        private struct Content: View {
            let configuration: Configuration

            var body: some View {
                if configuration.labelHidden {
                    configuration.content
                } else {
                    HStack(alignment: .firstTextBaseline) {
                        configuration.label
                        Spacer()
                        configuration.content
                            .foregroundColor(.secondary)
                    }
                }
            }
        }

        public func makeBody(configuration: Configuration) -> some View {
            Content(configuration: configuration)
        }
    }

}

extension BackportLabeledContentStyle where Self == Backport<Any>.AutomaticLabeledContentStyle {
    static var automatic: Self { .init() }
}
