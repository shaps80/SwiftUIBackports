#if os(iOS)
import SwiftUI
import PhotosUI
import SwiftBackports

extension PHObject: Identifiable {
    public var id: String { localIdentifier }
}
#endif
