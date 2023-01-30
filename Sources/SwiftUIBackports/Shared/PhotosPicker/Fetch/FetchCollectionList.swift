import Photos
import SwiftUI

@propertyWrapper
internal struct FetchCollectionList<Result>: DynamicProperty where Result: PHCollectionList {

    @ObservedObject
    internal private(set) var observer: ResultsObserver<Result>

    public var wrappedValue: MediaResults<Result> {
        get { MediaResults(observer.result) }
        set { observer.result = newValue.result }
    }

}

internal extension FetchCollectionList {

    /// Instantiates a fetch with an existing `PHFetchResult<Result>` instance
    init(_ result: PHFetchResult<PHAsset>) {
        observer = ResultsObserver(result: result as! PHFetchResult<Result>)
    }

    /// Instantiates a fetch with a custom `PHFetchOptions` instance
    init(_ options: PHFetchOptions?) {
        let result = PHCollectionList.fetchTopLevelUserCollections(with: options)
        self.init(observer: ResultsObserver(result: result as! PHFetchResult<Result>))
    }

    /// Instantiates a fetch by applying the specified sort and filter options
    /// - Parameters:
    ///   - filter: The predicate to apply when filtering the results
    init(filter: NSPredicate? = nil) {
        let options = PHFetchOptions()
        options.predicate = filter
        self.init(options)
    }

    /// Instantiates a fetch by applying the specified sort and filter options
    /// - Parameters:
    ///   - fetchLimit: The fetch limit to apply to the fetch, this may improve performance but limits results
    ///   - filter: The predicate to apply when filtering the results
    ///   - sort: The keyPaths to apply when sorting the results
    init<Value>(fetchLimit: Int = 0,
                       filter: NSPredicate? = nil,
                       sort: [(KeyPath<PHCollectionList, Value>, ascending: Bool)]) {
        let options = PHFetchOptions()
        options.fetchLimit = fetchLimit
        options.sortDescriptors = sort.map { NSSortDescriptor(keyPath: $0.0, ascending: $0.ascending) }
        options.predicate = filter
        self.init(options)
    }

}

internal extension FetchCollectionList {

    /// Fetches all lists of the specified type and subtyle
    /// - Parameters:
    ///   - list: The list type to filter by
    ///   - kind: The list subtype to filter by
    ///   - options: Any additional options to apply to the request
    init(list: PHCollectionListType,
                kind: PHCollectionListSubtype = .any,
                options: PHFetchOptions? = nil) {
        let result = PHCollectionList.fetchCollectionLists(with: list, subtype: kind, options: options)
        self.init(observer: ResultsObserver(result: result as! PHFetchResult<Result>))
    }

    /// Fetches all lists of the specified type and subtyle
    /// - Parameters:
    ///   - list: The list type to filter by
    ///   - kind: The list subtype to filter by
    ///   - fetchLimit: The fetch limit to apply to the fetch, this may improve performance but limits results
    ///   - filter: The predicate to apply when filtering the results
    init(list: PHCollectionListType,
                kind: PHCollectionListSubtype = .any,
                fetchLimit: Int = 0,
                filter: NSPredicate) {
        let options = PHFetchOptions()
        options.fetchLimit = fetchLimit
        options.predicate = filter
        self.init(list: list, kind: kind, options: options)
    }

    /// Fetches all lists of the specified type and subtyle
    /// - Parameters:
    ///   - list: The list type to filter by
    ///   - kind: The list subtype to filter by
    ///   - fetchLimit: The fetch limit to apply to the fetch, this may improve performance but limits results
    ///   - filter: The predicate to apply when filtering the results
    ///   - sort: The keyPaths to apply when sorting the results
    init<Value>(list: PHCollectionListType,
                       kind: PHCollectionListSubtype = .any,
                       fetchLimit: Int = 0,
                       filter: NSPredicate? = nil,
                       sort: [(KeyPath<PHCollectionList, Value>, ascending: Bool)]) {
        let options = PHFetchOptions()
        options.fetchLimit = fetchLimit
        options.sortDescriptors = sort.map { NSSortDescriptor(keyPath: $0.0, ascending: $0.ascending) }
        options.predicate = filter
        self.init(list: list, kind: kind, options: options)
    }

}
