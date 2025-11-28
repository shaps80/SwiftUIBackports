import SwiftUI

extension Backport<Any> {
    public struct ForEach<Content: View, Data, ID>: View {
        private var content: AnyView

        public init<V>(subviewOf view: V, @ViewBuilder content: @escaping (Subview) -> Content) where Data == ForEachSubviewCollection<Content>, ID == Subview.ID, Content: View, V: View {
            self.content = .init(
                view.variadic { children in
                    ForEachSubviewCollection(children: children, content: content)
                }
            )
        }

        public var body: some View { content }
    }
}

extension Backport<Any> {
    public struct ForEachSubviewCollection<Content>: View, RandomAccessCollection, Sendable where Content: View {
        public typealias SubSequence = Slice<ForEachSubviewCollection<Content>>
        public typealias Iterator = IndexingIterator<ForEachSubviewCollection<Content>>
        public typealias Indices = Range<Int>
        public typealias Index = Int
        public typealias Element = Subview

        public nonisolated var startIndex: Int { children.startIndex }
        public nonisolated var endIndex: Int { children.endIndex }

        public nonisolated func index(before i: Int) -> Int {
            children.index(before: i)
        }

        public nonisolated func index(after i: Int) -> Int {
            children.index(after: i)
        }

        public nonisolated subscript(index: Int) -> Subview {
            .init(children[index])
        }

        nonisolated fileprivate let children: _VariadicView.Children
        let content: (Subview) -> Content

        public var body: some View {
            SwiftUI.ForEach(children, id: \.id) {
                content(Subview($0))
            }
        }
    }
}
