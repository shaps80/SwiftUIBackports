#if os(iOS)
import PhotosUI

/// Represents a `PHFetchResult` that can be used as a `RandomAccessCollection` in a SwiftUI view such as `List`, `ForEach`, etc...
internal struct MediaResults<Result>: RandomAccessCollection where Result: PHObject {

    /// Represents the underlying results
    public private(set) var result: PHFetchResult<Result>

    /// Instantiates a new instance with the specified result
    public init(_ result: PHFetchResult<Result>) {
        self.result = result
    }

    public var startIndex: Int { 0 }
    public var endIndex: Int { result.count }
    public subscript(position: Int) -> Result { result.object(at: position) }

}

/// An observer used to observe changes on a `PHFetchResult`
internal final class ResultsObserver<Result>: NSObject, ObservableObject, PHPhotoLibraryChangeObserver where Result: PHObject {

    @Published
    internal var result: PHFetchResult<Result>

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    init(result: PHFetchResult<Result>) {
        self.result = result
        super.init()
        PHPhotoLibrary.shared().register(self)
    }

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        result = changeInstance.changeDetails(for: result)?.fetchResultAfterChanges ?? result
    }

}
#endif
