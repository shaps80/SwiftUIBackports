#if os(iOS)
import SwiftUI
import PhotosUI
import SwiftBackports

extension PHObject: @retroactive Identifiable {
    public var id: String { localIdentifier }
}
#endif
