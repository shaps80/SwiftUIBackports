#if os(iOS)
import SwiftUI
import PhotosUI
import CoreServices

@available(iOS, introduced: 13, deprecated: 16)
public extension Backport where Wrapped == Any {
    /// A filter that restricts which types of assets to show
    struct PHPickerFilter: Equatable, Hashable {
        internal let predicate: NSPredicate

        internal init(predicate: NSPredicate) {
            self.predicate = predicate
        }
    }
}

@available(iOS 13, *)
public extension Backport<Any>.PHPickerFilter {
    /// The filter for images.
    static var images: Self {
        .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaType.image]))
    }

    /// The filter for videos.
    static var videos: Self {
        .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaType.video]))
    }

    /// The filter for live photos.
    static var livePhotos: Self {
        .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaSubtype.photoLive]))
    }

    /// The filter for Depth Effect photos.
    static var depthEffectPhotos: Self {
        .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaSubtype.photoDepthEffect]))
    }

    /// The filter for panorama photos.
    static var panoramas: Self {
        .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaSubtype.photoPanorama]))
    }

    /// The filter for screenshots.
    static var screenshots: Self {
        .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaSubtype.photoScreenshot]))
    }

    /// The filter for Slow-Mo videos.
    static var slomoVideos: Self {
        .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaSubtype.videoHighFrameRate]))
    }

    /// The filter for time-lapse videos.
    static var timelapseVideos: Self {
        .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaSubtype.videoTimelapse]))
    }

    /// Returns a new filter based on the asset playback style.
    static func playbackStyle(_ playbackStyle: PHAsset.PlaybackStyle) -> Self {
        .init(predicate: NSPredicate(format: "(playbackStyle & %d) != 0", argumentArray: [playbackStyle.rawValue]))
    }

    /// Returns a new filter formed by OR-ing the filters in a given array.
    static func any(of subfilters: [Self]) -> Self {
        .init(predicate: NSCompoundPredicate(orPredicateWithSubpredicates: subfilters.map { $0.predicate }))
    }

    /// Returns a new filter formed by AND-ing the filters in a given array.
    static func all(of subfilters: [Self]) -> Self {
        .init(predicate: NSCompoundPredicate(andPredicateWithSubpredicates: subfilters.map { $0.predicate }))
    }

    /// Returns a new filter formed by negating the given filter.
    static func not(_ filter: Self) -> Self {
        .init(predicate: NSCompoundPredicate(notPredicateWithSubpredicate: filter.predicate))
    }
}

@available(iOS 15.0, *)
public extension Backport<Any>.PHPickerFilter {
    /// The filter for Cinematic videos.
    static var cinematicVideos: Self {
        .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaSubtype.videoCinematic]))
    }
}
#endif

/**
 ----------------------
 Class for Fetch Method
 ----------------------
 PHAsset
 SELF, localIdentifier, creationDate, modificationDate, mediaType, mediaSubtypes, duration, pixelWidth, pixelHeight, isFavorite (or isFavorite), isHidden (or isHidden), burstIdentifier
 ----------------------
 PHAssetCollection
 SELF, localIdentifier, localizedTitle (or title), startDate, endDate, estimatedAssetCount
 ----------------------
 PHCollectionList
 SELF, localIdentifier, localizedTitle (or title), startDate, endDate
 ----------------------
 PHCollection (can fetch a mix of PHCollectionList and PHAssetCollection objects)
 SELF, localIdentifier, localizedTitle (or title), startDate, endDate
 ----------------------
 */
