import SwiftUI
import SwiftBackports

@available(iOS, deprecated: 27, message: "Use DynamicViewContent.reorderable instead")
@available(macOS, deprecated: 27, message: "Use DynamicViewContent.reorderable instead")
@available(watchOS, deprecated: 27, message: "Use DynamicViewContent.reorderable instead")
@available(visionOS, deprecated: 27, message: "Use DynamicViewContent.reorderable instead")
@available(tvOS, unavailable)
public extension Backport where Wrapped: DynamicViewContent {
    /// Enables this dynamic content to be reordered within the scope of a
    /// reorder container.
    ///
    /// Use this modifier on dynamic content inside a view with a
    /// ``View/backport/reorderContainer(for:isEnabled:move:)`` modifier.
    ///
    /// - Returns: Dynamic view content enabled for reordering.
    nonisolated func reorderable() -> some DynamicViewContent<Wrapped.Data> {
        wrapped.modifier(ReorderableContentModifier(data: wrapped.data))
    }

    /// Enables this dynamic content to be reordered within the scope of a
    /// reorder container for a specific collection.
    ///
    /// Use this modifier on dynamic content inside a view with a
    /// ``View/backport/reorderContainer(for:in:isEnabled:move:)`` modifier.
    ///
    /// - Parameter collectionID: The collection identifier for this content.
    /// - Returns: Dynamic view content enabled for reordering.
    nonisolated func reorderable(
        collectionID: some Hashable & Sendable
    ) -> some DynamicViewContent<Wrapped.Data> {
        wrapped.modifier(ReorderableContentModifier(data: wrapped.data))
    }
}

nonisolated private struct ReorderableContentModifier<Data: Collection>: ViewModifier {
    var data: Data
    func body(content: Content) -> some View {
        content
    }
}

#if os(iOS)
private struct PreviewItem: Identifiable {
    let id: UUID = .init()
    var color: Color
}

@available(iOS 17, *)
#Preview {
    @Previewable @State var items: [PreviewItem] = [
        .init(color: .purple),
        .init(color: .red),
        .init(color: .orange),
        .init(color: .yellow),
    ]

    HStack {
        ForEach(items) { item in
            RoundedRectangle(cornerRadius: 28)
                .foregroundStyle(item.color.gradient)
        }
        .backport.reorderable()
    }
    .backport.reorderContainer(for: PreviewItem.self) { difference in
        items.apply(difference: difference)
    }
    .padding(15)
    .frame(height: 100)
}

// For preview purpose only! Source: Apple sample code
private extension Array {
    mutating func apply<CollectionID: Hashable & Sendable>(
        difference: Backport<Any>.ReorderDifference<Element.ID, CollectionID>
    ) where Element: Identifiable, Element.ID: Sendable {
        // Find the source card that moved.
        guard let sourceIndex = firstIndex(
            where: { $0.id == difference.sources[0] })
        else { return }
        let movedCard = remove(at: sourceIndex)

        // Find the destination of that card.
        var destination: Int
        switch difference.destination.position {
        case let .before(value):
            guard let index = firstIndex(where: { $0.id == value })
            else { return }
            destination = index
        case .end:
            destination = endIndex
        }
        insert(movedCard, at: destination)
    }
}
#endif
