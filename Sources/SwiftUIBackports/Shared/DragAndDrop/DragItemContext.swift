import Foundation

final class DragItemContext {
    let itemID: AnyHashable

    init(itemID: AnyHashable) {
        self.itemID = itemID
    }
}
