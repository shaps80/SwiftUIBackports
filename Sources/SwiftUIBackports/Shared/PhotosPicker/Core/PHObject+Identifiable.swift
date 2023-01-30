import SwiftUI
import Photos

extension PHObject: Identifiable {
    public var id: String { localIdentifier }
}
