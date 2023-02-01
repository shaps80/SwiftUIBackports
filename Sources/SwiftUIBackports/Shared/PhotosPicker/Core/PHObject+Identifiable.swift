#if os(iOS)
import SwiftUI
import PhotosUI

extension PHObject: Identifiable {
    public var id: String { localIdentifier }
}
#endif
