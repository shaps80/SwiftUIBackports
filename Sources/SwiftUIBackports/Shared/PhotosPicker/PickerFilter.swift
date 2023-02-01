#if os(iOS)
import SwiftUI
import PhotosUI
import CoreServices

@available(iOS, introduced: 13, deprecated: 16)
public extension Backport where Wrapped == Any {
    /// A filter that restricts which types of assets to show
    struct PHPickerFilter {
        internal let mediaTypes: [CFString]
        internal let filter: Any?

        @available(iOS 13, *)
        internal init(mediaTypes: [CFString]) {
            self.mediaTypes = mediaTypes
            self.filter = nil
        }

        @available(iOS 14, *)
        internal init(filter: PhotosUI.PHPickerFilter) {
            self.filter = filter
            self.mediaTypes = []
        }

        @available(iOS 14, *)
        var photosFilter: PhotosUI.PHPickerFilter {
            filter as! PhotosUI.PHPickerFilter
        }
    }
}

@available(iOS 13, *)
public extension Backport<Any>.PHPickerFilter {
    /// The filter for images.
    static var images: Self {
        if #available(iOS 14, *) {
            return .init(filter: .images)
        } else {
            return .init(mediaTypes: [kUTTypeImage])
        }
    }

    /// The filter for videos.
    static var videos: Self {
        if #available(iOS 14, *) {
            return .init(filter: .videos)
        } else {
            return .init(mediaTypes: [kUTTypeMovie])
        }
    }

    /// The filter for live photos.
    static var livePhotos: Self {
        if #available(iOS 14, *) {
            return .init(filter: .livePhotos)
        } else {
            return .init(mediaTypes: [kUTTypeLivePhoto, kUTTypeImage])
        }
    }
}

@available(iOS 14, *)
public extension Backport<Any>.PHPickerFilter {
    /// Returns a new filter formed by AND-ing the filters in a given array.
    static func any(of subfilters: [Self]) -> Self {
        .init(filter: .any(of: subfilters.map { $0.photosFilter }))
    }
}

@available(iOS 15, *)
public extension Backport<Any>.PHPickerFilter {
    /// The filter for panorama photos.
    static var panoramas: Self {
        .init(filter: .panoramas)
    }

    /// The filter for screenshots.
    static var screenshots: Self {
        .init(filter: .screenshots)
    }

    /// The filter for Slow-Mo videos.
    static var slomoVideos: Self {
        .init(filter: .slomoVideos)
    }

    /// The filter for time-lapse videos.
    static var timelapseVideos: Self {
        .init(filter: .timelapseVideos)
    }

    /// Returns a new filter based on the asset playback style.
    static func playbackStyle(_ playbackStyle: PHAsset.PlaybackStyle) -> Self {
        .init(filter: .playbackStyle(playbackStyle))
    }

    /// Returns a new filter formed by AND-ing the filters in a given array.
    static func all(of subfilters: [Self]) -> Self {
        .init(filter: .all(of: subfilters.map { $0.photosFilter }))
    }

    /// Returns a new filter formed by negating the given filter.
    static func not(_ filter: Self) -> Self {
        .init(filter: .not(filter.photosFilter))
    }
}

@available(iOS 16, *)
public extension Backport<Any>.PHPickerFilter {
    /// The filter for Depth Effect photos.
    static var depthEffectPhotos: Self {
        .init(filter: .depthEffectPhotos)
    }

    /// The filter for Cinematic videos.
    static var cinematicVideos: Self {
        .init(filter: .cinematicVideos)
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
