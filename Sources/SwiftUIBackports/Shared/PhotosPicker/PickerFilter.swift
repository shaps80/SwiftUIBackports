#if os(iOS)
import SwiftUI
import PhotosUI

@available(iOS, introduced: 13, deprecated: 16)
public extension Backport where Wrapped == Any {
    /// A filter that restricts which types of assets to show
    struct PHPickerFilter: Equatable, Hashable {
        let predicate: NSPredicate

        /// The filter for images.
        public static var images: Self {
            .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaType.image]))
        }

        /// The filter for videos.
        public static var videos: Self {
            .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaType.video]))
        }

        /// The filter for live photos.
        public static var livePhotos: Self {
            .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaSubtype.photoLive]))
        }

        /// The filter for Depth Effect photos.
        public static var depthEffectPhotos: Self {
            .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaSubtype.photoDepthEffect]))
        }

        /// The filter for panorama photos.
        public static var panoramas: Self {
            .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaSubtype.photoPanorama]))
        }

        /// The filter for screenshots.
        public static var screenshots: Self {
            .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaSubtype.photoScreenshot]))
        }

        /// The filter for Slow-Mo videos.
        public static var slomoVideos: Self {
            .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaSubtype.videoHighFrameRate]))
        }

        /// The filter for time-lapse videos.
        public static var timelapseVideos: Self {
            .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaSubtype.videoTimelapse]))
        }

        /// The filter for Cinematic videos.
        @available(iOS 15.0, *)
        public static var cinematicVideos: Self {
            .init(predicate: NSPredicate(format: "(mediaSubtypes & %d) != 0", argumentArray: [PHAssetMediaSubtype.videoCinematic]))
        }

        /// Returns a new filter based on the asset playback style.
        #warning("NEEDS TESTING!")
        public static func playbackStyle(_ playbackStyle: PHAsset.PlaybackStyle) -> Self {
            .init(predicate: NSPredicate(format: "(playbackStyle & %d) != 0", argumentArray: [playbackStyle.rawValue]))
        }

        /// Returns a new filter formed by OR-ing the filters in a given array.
        public static func any(of subfilters: [Self]) -> Self {
            .init(predicate: NSCompoundPredicate(orPredicateWithSubpredicates: subfilters.map { $0.predicate }))
        }

        /// Returns a new filter formed by AND-ing the filters in a given array.
        public static func all(of subfilters: [Self]) -> Self {
            .init(predicate: NSCompoundPredicate(andPredicateWithSubpredicates: subfilters.map { $0.predicate }))
        }

        /// Returns a new filter formed by negating the given filter.
        public static func not(_ filter: Self) -> Self {
            .init(predicate: NSCompoundPredicate(notPredicateWithSubpredicate: filter.predicate))
        }
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
