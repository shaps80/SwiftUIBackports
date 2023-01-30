import Photos
import SwiftUI

/// Fetches a single asset
@propertyWrapper
struct FetchAsset: DynamicProperty {

    @ObservedObject
    internal private(set) var observer: AssetObserver

    /// Represents the fetched asset
    public var wrappedValue: MediaAsset {
        MediaAsset(asset: observer.asset)
    }

}

internal extension FetchAsset {

    /// Instantiates the fetch with an existing `PHAsset`
    /// - Parameter asset: The asset
    init(_ asset: PHAsset) {
        let observer = AssetObserver(asset: asset)
        self.init(observer: observer)
    }

}

/// Represents the result of a `FetchAsset` request.
struct MediaAsset {

    public private(set) var asset: PHAsset?

    public init(asset: PHAsset?) {
        self.asset = asset
    }

}

internal final class AssetObserver: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {

    @Published
    internal var asset: PHAsset?

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    init(asset: PHAsset) {
        self.asset = asset
        super.init()
        PHPhotoLibrary.shared().register(self)
    }

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let asset = asset else { return }
        self.asset = changeInstance.changeDetails(for: asset)?.objectAfterChanges
    }

}
