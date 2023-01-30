import Photos
import SwiftUI

/// Fetches a set of asset collections from the `Photos` framework
@propertyWrapper
internal struct FetchAssetCollection<Result>: DynamicProperty where Result: PHAssetCollection {

    @ObservedObject
    internal private(set) var observer: ResultsObserver<Result>

    /// Represents the results of the fetch
    public var wrappedValue: MediaResults<Result> {
        get { MediaResults(observer.result) }
        set { observer.result = newValue.result }
    }

}

internal extension FetchAssetCollection {

    /// Instantiates a fetch with an existing `PHFetchResult<Result>` instance
    init(result: PHFetchResult<Result>) {
        self.init(observer: ResultsObserver(result: result))
    }

    /// Instantiates a fetch with a custom `PHFetchOptions` instance
    init(_ options: PHFetchOptions? = nil) {
        let result = PHAssetCollection.fetchTopLevelUserCollections(with: options)
        self.init(observer: ResultsObserver(result: result as! PHFetchResult<Result>))
    }

    /// Instantiates a fetch with a filter and sort options
    /// - Parameters:
    ///   - filter: The predicate to apply when filtering the results
    ///   - sort: The keyPaths to apply when sorting the results
    init<Value>(filter: NSPredicate? = nil,
                       sort: [(KeyPath<PHAssetCollection, Value>, ascending: Bool)]) {
        let options = PHFetchOptions()
        options.sortDescriptors = sort.map { NSSortDescriptor(keyPath: $0.0, ascending: $0.ascending) }
        options.predicate = filter
        self.init(options)
    }

}

internal extension FetchAssetCollection {

    /// Instantiates a fetch for the specified album type and subtype
    /// - Parameters:
    ///   - album: The album type to fetch
    ///   - kind: The album subtype to fetch
    ///   - options: Any additional options to apply to the fetch
    init(album: PHAssetCollectionType,
                kind: PHAssetCollectionSubtype = .any,
                options: PHFetchOptions? = nil) {
        let result = PHAssetCollection.fetchAssetCollections(with: album, subtype: kind, options: options)
        self.init(observer: ResultsObserver(result: result as! PHFetchResult<Result>))
    }

    /// Instantiates a fetch for the specified album type and subtype
    /// - Parameters:
    ///   - album: The album type to fetch
    ///   - kind: The album subtype to fetch
    ///   - fetchLimit: The fetch limit to apply to the fetch, this may improve performance but limits results
    ///   - filter: The predicate to apply when filtering the results
    init(album: PHAssetCollectionType,
                kind: PHAssetCollectionSubtype = .any,
                fetchLimit: Int = 0,
                filter: NSPredicate? = nil) {
        let options = PHFetchOptions()
        options.fetchLimit = fetchLimit
        options.predicate = filter
        self.init(album: album, kind: kind, options: options)
    }

    /// Instantiates a fetch for the specified album type and subtype
    /// - Parameters:
    ///   - album: The album type to fetch
    ///   - kind: The album subtype to fetch
    ///   - fetchLimit: The fetch limit to apply to the fetch, this may improve performance but limits results
    ///   - filter: The predicate to apply when filtering the results
    ///   - sort: The keyPaths to apply when sorting the results
    init<Value>(album: PHAssetCollectionType,
                       kind: PHAssetCollectionSubtype = .any,
                       fetchLimit: Int = 0,
                       filter: NSPredicate? = nil,
                       sort: [(KeyPath<PHAssetCollection, Value>, ascending: Bool)]) {
        let options = PHFetchOptions()
        options.fetchLimit = fetchLimit
        options.sortDescriptors = sort.map { NSSortDescriptor(keyPath: $0.0, ascending: $0.ascending) }
        options.predicate = filter
        self.init(album: album, kind: kind, options: options)
    }

}
