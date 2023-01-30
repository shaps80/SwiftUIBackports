#if os(iOS)
import SwiftUI
import PhotosUI

/// An observer used to observe changes on a `PHFetchResult`
internal final class PickerObserver<Result>: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {
    @Published
    internal var result: PHFetchResult<PHAsset>

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    init(maxSelectionCount: Int?, filter: Backport<Any>.PHPickerFilter) {
        let options = PHFetchOptions()
        options.includeAssetSourceTypes = [.typeCloudShared, .typeUserLibrary, .typeiTunesSynced]
        result = PHAsset.fetchAssets(with: options)
        super.init()
        PHPhotoLibrary.shared().register(self)
    }

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        result = changeInstance.changeDetails(for: result)?.fetchResultAfterChanges ?? result
    }
}

/// Represents a `PHFetchResult` that can be used as a `RandomAccessCollection` in a SwiftUI view such as `List`, `ForEach`, etc...
internal struct MediaResults: RandomAccessCollection {
    /// Represents the underlying results
    private let result: PHFetchResult<PHAsset>
    private let playbackStyle: PHAsset.PlaybackStyle

    public var element: [Backport<Any>.PhotosPickerItem] {
        filter { $0.playbackStyle == playbackStyle }
            .map { Backport<Any>.PhotosPickerItem(itemIdentifier: $0.localIdentifier) }
    }

    /// Instantiates a new instance with the specified result
    public init(_ result: PHFetchResult<PHAsset>, playbackStyle: PHAsset.PlaybackStyle) {
        self.result = result
        self.playbackStyle = playbackStyle
    }

    public var startIndex: Int { 0 }
    public var endIndex: Int { result.count }
    public subscript(position: Int) -> PHAsset { result.object(at: position) }
}
#endif
