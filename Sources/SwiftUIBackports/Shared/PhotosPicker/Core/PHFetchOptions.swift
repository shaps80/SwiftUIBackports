#if os(iOS)
import Foundation
import PhotosUI
import SwiftBackports

internal extension PHFetchOptions {

    /// The maximum number of objects to include in the fetch result.
    func fetchLimit(_ fetchLimit: Int) -> Self {
        self.fetchLimit = fetchLimit
        return self
    }

    /// The set of source types for which to include assets in the fetch result.
    func includeAssetSourceTypes(_ sourceTypes: PHAssetSourceType) -> Self {
        self.includeAssetSourceTypes = sourceTypes
        return self
    }

    /// Determines whether the fetch result includes all assets from burst photo sequences.
    func includeHiddenAssets(_ includeHiddenAssets: Bool) -> Self {
        self.includeHiddenAssets = includeHiddenAssets
        return self
    }

    /// Determines whether the fetch result includes all assets from burst photo sequences.
    func includeAllBurstAssets(_ includeAllBurstAssets: Bool) -> Self {
        self.includeAllBurstAssets = includeAllBurstAssets
        return self
    }

    /// Appends the specified sort to the current list of descriptors.
    /// - Parameters:
    ///   - keyPath: The keyPath sort by
    ///   - ascending: If true, the results will be in ascending order
    func sort<Root, Value>(by keyPath: KeyPath<Root, Value>, ascending: Bool = true) -> Self {
        var descriptors = sortDescriptors ?? []
        descriptors.append(NSSortDescriptor(keyPath: keyPath, ascending: ascending))
        self.sortDescriptors = descriptors
        return self
    }

    /// Appends the specified predicate to the current list of predicates.
    /// - Parameter predicate: The predicate to append
    func filter(_ predicate: NSPredicate) -> Self {
        let predicates = [predicate, self.predicate].compactMap { $0 }
        self.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        return self
    }

    /// Replaces the sort descriptors.
    /// - Parameter sortDescriptors: The descriptors to sort results
    func sortDescriptors(_ sortDescriptors: [NSSortDescriptor]) -> Self {
        self.sortDescriptors = sortDescriptors
        return self
    }

    /// Replaces the predicate.
    /// - Parameter predicate: The predicate to filter results
    func predicate(_ predicate: NSPredicate) -> Self {
        self.predicate = predicate
        return self
    }

}
#endif
