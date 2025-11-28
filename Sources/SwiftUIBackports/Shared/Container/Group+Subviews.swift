import SwiftUI

extension Backport<Any> {
    public struct Group<Content: View>: View {
        private var content: Content

        public init<Base, Result>(
            subviews view: Base,
            @ViewBuilder transform: @escaping (SubviewsCollection) -> Result
        ) where Content == GroupElementsOfContent<Base, Result>, Base: View, Result: View {
            content = GroupElementsOfContent(view, subviews: transform)
        }

        public var body: some View {
            content
        }
    }

    public struct GroupElementsOfContent<Subviews, Content>: View, Sendable where Subviews: View, Content: View {
        private var content: AnyView
        private var subviews: (SubviewsCollection) -> Content

        public init<Source: View>(_ source: Source, @ViewBuilder subviews: @escaping (SubviewsCollection) -> Content) {
            self.content = .init(source.variadic { subviews(SubviewsCollection(children: $0)) })
            self.subviews = subviews
        }

        public var body: some View {
            content
        }
    }
}

extension Backport<Any> {
    public struct SubviewsCollection: RandomAccessCollection, View, Sendable {
        public typealias SubSequence = SubviewsCollectionSlice
        public typealias Iterator = IndexingIterator<SubviewsCollection>
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

        public nonisolated subscript(position: Int) -> Subview {
            .init(children[position])
        }

        public nonisolated subscript(bounds: Range<Int>) -> SubviewsCollectionSlice {
            .init(children: children[bounds])
        }

        nonisolated fileprivate let children: _VariadicView.Children

        public var body: some View {
            SwiftUI.ForEach(children, id: \.id) { $0.id($0.id) }
        }
    }

    public struct SubviewsCollectionSlice: RandomAccessCollection, View, Sendable {
        public typealias SubSequence = SubviewsCollectionSlice
        public typealias Element = Subview
        public typealias Iterator = IndexingIterator<SubviewsCollectionSlice>
        public typealias Indices = Range<Int>
        public typealias Index = Int

        public nonisolated var startIndex: Int { children.startIndex }
        public nonisolated var endIndex: Int { children.endIndex }

        public nonisolated subscript(position: Int) -> Subview {
            .init(children[position])
        }

        public nonisolated subscript(bounds: Range<Int>) -> SubviewsCollectionSlice {
            .init(children: children[bounds])
        }

        fileprivate let children: _VariadicView.Children.SubSequence

        public var body: some View {
            SwiftUI.ForEach(children, id: \.id) { $0 }
        }
    }
}
