#if os(iOS)
import Photos
import SwiftUI
import SwiftBackports

/// Fetches a set of assets from the `Photos` framework
@propertyWrapper
internal struct FetchAssetList<Result>: DynamicProperty where Result: PHAsset {

    @ObservedObject
    internal private(set) var observer: ResultsObserver<Result>

    /// Represents the results of the fetch
    public var wrappedValue: MediaResults<Result> {
        get { MediaResults(observer.result) }
        set { observer.result = newValue.result }
    }

}

internal extension FetchAssetList {

    /// Instantiates a fetch with an existing `PHFetchResult<Result>` instance
    init(_ result: PHFetchResult<PHAsset>) {
        observer = ResultsObserver(result: result as! PHFetchResult<Result>)
    }

    /// Instantiates a fetch with a custom `PHFetchOptions` instance
    init(_ options: PHFetchOptions? = nil) {
        let result = PHAsset.fetchAssets(with: options)
        observer = ResultsObserver(result: result as! PHFetchResult<Result>)
    }

    /// Instantiates a fetch by applying the specified sort and filter options
    /// - Parameters:
    ///   - filter: The predicate to apply when filtering the results
    ///   - sort: The keyPaths to apply when sorting the results
    ///   - sourceTypes: The sourceTypes to include in the results
    ///   - includeAllBurstAssets: If true, burst assets will be included in the results
    ///   - includeHiddenAssets: If true, hidden assets will be included in the results
    init<Value>(filter: NSPredicate? = nil,
                       sort: [(KeyPath<PHAsset, Value>, ascending: Bool)],
                       sourceTypes: PHAssetSourceType = [.typeCloudShared, .typeUserLibrary, .typeiTunesSynced],
                       includeAllBurstAssets: Bool = false,
                       includeHiddenAssets: Bool = false) {
        let options = PHFetchOptions()
        options.sortDescriptors = sort.map { NSSortDescriptor(keyPath: $0.0, ascending: $0.ascending) }
        options.predicate = filter
        options.includeAssetSourceTypes = sourceTypes
        options.includeHiddenAssets = includeHiddenAssets
        options.includeAllBurstAssets = includeAllBurstAssets
        self.init(options)
    }

}

internal extension FetchAssetList {

    /// Fetches all assets in the specified collection
    /// - Parameters:
    ///   - collection: The asset collection to filter by
    ///   - options: Any additional options to apply to the request
    init(in collection: PHAssetCollection,
                options: PHFetchOptions? = nil) {
        let result = PHAsset.fetchAssets(in: collection, options: options)
        self.init(observer: ResultsObserver(result: result as! PHFetchResult<Result>))
    }

    /// Fetches all assets in the specified collection
    /// - Parameters:
    ///   - collection: The asset collection to filter by
    ///   - fetchLimit: The fetch limit to apply to the fetch, this may improve performance but limits results
    ///   - filter: The predicate to apply when filtering the results
    ///   - sourceTypes: The sourceTypes to include in the results
    ///   - includeAllBurstAssets: If true, burst assets will be included in the results
    ///   - includeHiddenAssets: If true, hidden assets will be included in the results
    init(in collection: PHAssetCollection,
                fetchLimit: Int = 0,
                filter: NSPredicate? = nil,
                sourceTypes: PHAssetSourceType = [.typeCloudShared, .typeUserLibrary, .typeiTunesSynced],
                includeAllBurstAssets: Bool = false,
                includeHiddenAssets: Bool = false) {
        let options = PHFetchOptions()
        options.fetchLimit = fetchLimit
        options.predicate = filter
        options.includeAssetSourceTypes = sourceTypes
        options.includeHiddenAssets = includeHiddenAssets
        options.includeAllBurstAssets = includeAllBurstAssets
        self.init(in: collection, options: options)
    }

    /// Fetches all assets in the specified collection
    /// - Parameters:
    ///   - collection: The asset collection to filter by
    ///   - fetchLimit: The fetch limit to apply to the fetch, this may improve performance but limits results
    ///   - filter: The predicate to apply when filtering the results
    ///   - sort: The keyPaths to apply when sorting the results
    ///   - sourceTypes: The sourceTypes to include in the results
    ///   - includeAllBurstAssets: If true, burst assets will be included in the results
    ///   - includeHiddenAssets: If true, hidden assets will be included in the results
    init<Value>(in collection: PHAssetCollection,
                       fetchLimit: Int = 0,
                       filter: NSPredicate? = nil,
                       sort: [(KeyPath<PHAsset, Value>, ascending: Bool)],
                       sourceTypes: PHAssetSourceType = [.typeCloudShared, .typeUserLibrary, .typeiTunesSynced],
                       includeAllBurstAssets: Bool = false,
                       includeHiddenAssets: Bool = false) {
        let options = PHFetchOptions()
        options.fetchLimit = fetchLimit
        options.sortDescriptors = sort.map { NSSortDescriptor(keyPath: $0.0, ascending: $0.ascending) }
        options.predicate = filter
        options.includeAssetSourceTypes = sourceTypes
        options.includeHiddenAssets = includeHiddenAssets
        options.includeAllBurstAssets = includeAllBurstAssets
        self.init(in: collection, options: options)
    }

}
#endif
