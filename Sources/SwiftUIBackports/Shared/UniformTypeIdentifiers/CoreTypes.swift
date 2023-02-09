import Foundation
import CoreServices

public extension Backport<Any>.UTType {
    /**
     A generic base type for most things (files, directories.)
     
     **UTI:** public.item
     */
    static var item: Self { .init(kUTTypeItem as String)! }
    
    /**
     A base type for anything containing user-viewable document content
     (documents, pasteboard data, and document packages.)
     
     Types describing files or packages must also conform to `UTType.data` or
     `UTType.package` in order for the system to bind documents to them.
     
     **UTI:** public.content
     */
    static var content: Self { .init(kUTTypeContent as String)! }
    
    /**
     A base type for content formats supporting mixed embedded content
     (i.e., compound documents).
     
     **UTI:** public.composite-content
     
     **conforms to:** public.content
     */
    static var compositeContent: Self { .init(kUTTypeCompositeContent as String)! }
    
    /**
     A data item mountable as a volume
     
     **UTI:** public.disk-image
     */
    static var diskImage: Self { .init(kUTTypeDiskImage as String)! }
    
    /**
     A base type for any sort of simple byte stream, including files and
     in-memory data.
     
     **UTI:** public.data
     
     **conforms to:** public.item
     */
    static var data: Self { .init(kUTTypeData as String)! }
    
    /**
     A file system directory (includes packages _and_ folders.)
     
     **UTI:** public.directory
     
     **conforms to:** public.item
     */
    static var directory: Self { .init(kUTTypeDirectory as String)! }
    
    /**
     Symbolic link and alias file types conform to this type.
     
     **UTI:** com.apple.resolvable
     */
    static var resolvable: Self { .init(kUTTypeResolvable as String)! }
    
    /**
     A symbolic link.
     
     **UTI:** public.symlink
     
     **conforms to:** public.item, com.apple.resolvable
     */
    static var symbolicLink: Self { .init(kUTTypeSymLink as String)! }
    
    /**
     An executable item.
     
     **UTI:** public.executable
     
     **conforms to:** public.item
     */
    static var executable: Self { .init(kUTTypeExecutable as String)! }
    
    /**
     A volume mount point (resolvable, resolves to the root directory of a
     volume.)
     
     **UTI:** com.apple.mount-point
     
     **conforms to:** public.item, com.apple.resolvable
     */
    static var mountPoint: Self { .init(kUTTypeMountPoint as String)! }
    
    /**
     A fully-formed alias file.
     
     **UTI:** com.apple.alias-file
     
     **conforms to:** public.data, com.apple.resolvable
     */
    static var aliasFile: Self { .init(kUTTypeAliasFile as String)! }
    
    /**
     A URL bookmark.
     
     **UTI:** com.apple.bookmark
     
     **conforms to:** public.data, com.apple.resolvable
     */
    static var urlBookmarkData: Self { .init(kUTTypeURLBookmarkData as String)! }
    
    /**
     Any URL.
     
     **UTI:** public.url
     
     **conforms to:** public.data
     */
    static var url: Self { .init(kUTTypeURL as String)! }
    
    /**
     A URL with the scheme `"file:"`.
     
     **UTI:** public.file-url
     
     **conforms to:** public.url
     */
    static var fileURL: Self { .init(kUTTypeFileURL as String)! }
    
    /**
     The base type for all text-encoded data, including text with markup
     (HTML, RTF, etc.).
     
     **UTI:** public.text
     
     **conforms to:** public.data, public.content
     */
    static var text: Self { .init(kUTTypeText as String)! }
    
    /**
     Text with no markup and an unspecified encoding.
     
     **UTI:** public.plain-text
     
     **conforms to:** public.text
     */
    static var plainText: Self { .init(kUTTypePlainText as String)! }
    
    /**
     Plain text encoded as UTF-8.
     
     **UTI:** public.utf8-plain-text
     
     **conforms to:** public.plain-text
     */
    static var utf8PlainText: Self { .init(kUTTypeUTF8PlainText as String)! }
    
    /**
     Plain text encoded as UTF-16 with a BOM, or if a BOM is not present,
     using "external representation" byte order (big-endian).
     
     **UTI:** public.utf16-external-plain-text
     
     **conforms to:** public.plain-text
     */
    static var utf16ExternalPlainText: Self { .init(kUTTypeUTF16ExternalPlainText as String)! }
    
    /**
     Plain text encoded as UTF-16, in native byte order, with an optional
     BOM.
     
     **UTI:** public.utf16-plain-text
     
     **conforms to:** public.plain-text
     */
    static var utf16PlainText: Self { .init(kUTTypeUTF16PlainText as String)! }
    
    /**
     Text containing delimited values.
     
     **UTI:** public.delimited-values-text
     
     **conforms to:** public.text
     */
    static var delimitedText: Self { .init(kUTTypeDelimitedText as String)! }
    
    /**
     Text containing comma-separated values (.csv).
     
     **UTI:** public.comma-separated-values-text
     
     **conforms to:** public.delimited-values-text
     */
    static var commaSeparatedText: Self { .init(kUTTypeCommaSeparatedText as String)! }
    
    /**
     Text containing tab-separated values.
     
     **UTI:** public.tab-separated-values-text
     
     **conforms to:** public.delimited-values-text
     */
    static var tabSeparatedText: Self { .init(kUTTypeTabSeparatedText as String)! }
    
    /**
     UTF-8 encoded text containing tab-separated values.
     
     **UTI:** public.utf8-tab-separated-values-text
     
     **conforms to:** public.tab-separated-values-text, public.utf8-plain-text
     */
    static var utf8TabSeparatedText: Self { .init(kUTTypeUTF8TabSeparatedText as String)! }
    
    /**
     Rich Text Format data.
     
     **UTI:** public.rtf
     
     **conforms to:** public.text
     */
    static var rtf: Self { .init(kUTTypeRTF as String)! }
    
    /**
     Any version of HTML.
     
     **UTI:** public.html
     
     **conforms to:** public.text
     */
    static var html: Self { .init(kUTTypeHTML as String)! }
    
    /**
     Generic XML.
     
     **UTI:** public.xml
     
     **conforms to:** public.text
     */
    static var xml: Self { .init(kUTTypeXML as String)! }
    
    /**
     Yet Another Markup Language.
     
     **UTI:** public.yaml
     
     **conforms to:** public.text
     */
    static var yaml: Self { .init(tag: "application/x-yaml", tagClass: .mimeType, conformingTo: nil)! }
    
    /**
     Abstract type for source code of any language.
     
     **UTI:** public.source-code
     
     **conforms to:** public.plain-text
     */
    static var sourceCode: Self { .init(kUTTypeSourceCode as String)! }
    
    /**
     Assembly language source (.s)
     
     **UTI:** public.assembly-source
     
     **conforms to:** public.source-code
     */
    static var assemblyLanguageSource: Self { .init(kUTTypeAssemblyLanguageSource as String)! }
    
    /**
     C source code (.c)
     
     **UTI:** public.c-source
     
     **conforms to:** public.source-code
     */
    static var cSource: Self { .init(kUTTypeCSource as String)! }
    
    /**
     Objective-C source code (.m)
     
     **UTI:** public.objective-c-source
     
     **conforms to:** public.source-code
     */
    static var objectiveCSource: Self { .init(kUTTypeObjectiveCSource as String)! }
    
    /**
     Swift source code (.swift)
     
     **UTI:** public.swift-source
     
     **conforms to:** public.source-code
     */
    static var swiftSource: Self { .init(kUTTypeSwiftSource as String)! }
    
    /**
     C++ source code (.cp, etc.)
     
     **UTI:** public.c-plus-plus-source
     
     **conforms to:** public.source-code
     */
    static var cPlusPlusSource: Self { .init(kUTTypeCPlusPlusSource as String)! }
    
    /**
     Objective-C++ source code.
     
     **UTI:** public.objective-c-plus-plus-source
     
     **conforms to:** public.source-code
     */
    static var objectiveCPlusPlusSource: Self { .init(kUTTypeObjectiveCPlusPlusSource as String)! }
    
    /**
     A C header.
     
     **UTI:** public.c-header
     
     **conforms to:** public.source-code
     */
    static var cHeader: Self { .init(kUTTypeCHeader as String)! }
    
    /**
     A C++ header.
     
     **UTI:** public.c-plus-plus-header
     
     **conforms to:** public.source-code
     */
    static var cPlusPlusHeader: Self { .init(kUTTypeCPlusPlusHeader as String)! }
    
    /**
     A base type for any scripting language source.
     
     **UTI:** public.script
     
     **conforms to:** public.source-code
     */
    static var script: Self { .init(kUTTypeScript as String)! }
    
    /**
     An AppleScript text-based script (.applescript).
     
     **UTI:** com.apple.applescript.text
     
     **conforms to:** public.script
     */
    static var appleScript: Self { .init(kUTTypeAppleScript as String)! }
    
    /**
     An Open Scripting Architecture binary script (.scpt).
     
     **UTI:** com.apple.applescript.script
     
     **conforms to:** public.data, public.script
     */
    static var osaScript: Self { .init(kUTTypeOSAScript as String)! }
    
    /**
     An Open Scripting Architecture script bundle (.scptd).
     
     **UTI:** com.apple.applescript.script-bundle
     
     **conforms to:** com.apple.bundle, com.apple.package, public.script
     */
    static var osaScriptBundle: Self { .init(kUTTypeOSAScriptBundle as String)! }
    
    /**
     JavaScript source code
     
     **UTI:** com.netscape.javascript-source
     
     **conforms to:** public.source-code, public.executable
     */
    static var javaScript: Self { .init(kUTTypeJavaScript as String)! }
    
    /**
     The base type for shell scripts.
     
     **UTI:** public.shell-script
     
     **conforms to:** public.script
     */
    static var shellScript: Self { .init(kUTTypeShellScript as String)! }
    
    /**
     A Perl script.
     
     **UTI:** public.perl-script
     
     **conforms to:** public.shell-script
     */
    static var perlScript: Self { .init(kUTTypePerlScript as String)! }
    
    /**
     A Python script.
     
     **UTI:** public.python-script
     
     **conforms to:** public.shell-script
     */
    static var pythonScript: Self { .init(kUTTypePythonScript as String)! }
    
    /**
     A Ruby script.
     
     **UTI:** public.ruby-script
     
     **conforms to:** public.shell-script
     */
    static var rubyScript: Self { .init(kUTTypeRubyScript as String)! }
    
    /**
     A PHP script.
     
     **UTI:** public.php-script
     
     **conforms to:** public.shell-script
     */
    static var phpScript: Self { .init(kUTTypePHPScript as String)! }
    
    /**
     A makefile.
     
     **UTI:** public.make-source
     
     **conforms to:** public.script
     */
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    static var makefile: Self { .init(tag: "make", tagClass: .filenameExtension, conformingTo: nil)! }
    
    /**
     JavaScript object notation (JSON) data
     
     **UTI:** public.json
     
     **conforms to:** public.text
     
     - Note: JSON almost (but doesn't quite) conforms to
     com.netscape.javascript-source.
     */
    static var json: Self { .init(kUTTypeJSON as String)! }
    
    /**
     A base type for property lists.
     
     **UTI:** com.apple.property-list
     
     **conforms to:** public.data
     */
    static var propertyList: Self { .init(kUTTypePropertyList as String)! }
    
    /**
     An XML property list.
     
     **UTI:** com.apple.xml-property-list
     
     **conforms to:** public.xml, com.apple.property-list
     */
    static var xmlPropertyList: Self { .init(kUTTypeXMLPropertyList as String)! }
    
    /**
     A binary property list.
     
     **UTI:** com.apple.binary-property-list
     
     **conforms to:** com.apple.property-list
     */
    static var binaryPropertyList: Self { .init(kUTTypeBinaryPropertyList as String)! }
    
    /**
     An Adobe PDF document.
     
     **UTI:** com.adobe.pdf
     
     **conforms to:** public.data, public.composite-content
     */
    static var pdf: Self { .init(kUTTypePDF as String)! }
    
    /**
     A Rich Text Format Directory document (RTF with content embedding
     in its on-disk format.)
     
     **UTI:** com.apple.rtfd
     
     **conforms to:** com.apple.package, public.composite-content
     */
    static var rtfd: Self { .init(kUTTypeRTFD as String)! }
    
    /**
     A flattened RTFD document (formatted for the pasteboard.)
     
     **UTI:** com.apple.flat-rtfd
     
     **conforms to:** public.data, public.composite-content
     */
    static var flatRTFD: Self { .init(kUTTypeFlatRTFD as String)! }
    
    /**
     The WebKit webarchive format.
     
     **UTI:** com.apple.webarchive
     
     **conforms to:** public.data, public.composite-content
     */
    static var webArchive: Self { .init(kUTTypeWebArchive as String)! }
    
    /**
     A base type for abstract image data.
     
     **UTI:** public.image
     
     **conforms to:** public.data, public.content
     */
    static var image: Self { .init(kUTTypeImage as String)! }
    
    /**
     A JPEG image.
     
     **UTI:** public.jpeg
     
     **conforms to:** public.image
     */
    static var jpeg: Self { .init(kUTTypeJPEG as String)! }
    
    /**
     A TIFF image.
     
     **UTI:** public.tiff
     
     **conforms to:** public.image
     */
    static var tiff: Self { .init(kUTTypeTIFF as String)! }
    
    /**
     A GIF image.
     
     **UTI:** com.compuserve.gif
     
     **conforms to:** public.image
     */
    static var gif: Self { .init(kUTTypeGIF as String)! }
    
    /**
     A PNG image.
     
     **UTI:** public.png
     
     **conforms to:** public.image
     */
    static var png: Self { .init(kUTTypePNG as String)! }
    
    /**
     Apple icon data
     
     **UTI:** com.apple.icns
     
     **conforms to:** public.image
     */
    static var icns: Self { .init(kUTTypeAppleICNS as String)! }
    
    /**
     A Windows bitmap.
     
     **UTI:** com.microsoft.bmp
     
     **conforms to:** public.image
     */
    static var bmp: Self { .init(kUTTypeBMP as String)! }
    
    /**
     Windows icon data
     
     **UTI:** com.microsoft.ico
     
     **conforms to:** public.image
     */
    static var ico: Self { .init(kUTTypeICO as String)! }
    
    /**
     A base type for raw image data (.raw).
     
     **UTI:** public.camera-raw-image
     
     **conforms to:** public.image
     */
    static var rawImage: Self { .init(kUTTypeRawImage as String)! }
    
    /**
     A Scalable Vector Graphics image.
     
     **UTI:** public.svg-image
     
     **conforms to:** public.image
     */
    static var svg: Self { .init(kUTTypeScalableVectorGraphics as String)! }
    
    /**
     A Live Photo.
     
     **UTI:** com.apple.live-photo
     */
    static var livePhoto: Self { .init(kUTTypeLivePhoto as String)! }
    
    /**
     A High Efficiency Image File Format image.
     
     **UTI:** public.heif
     
     **conforms to:** public.heif-standard
     */
    static var heif: Self { .init(tag: "image/heif", tagClass: .mimeType, conformingTo: nil)! }
    
    /**
     A High Efficiency Image Coding image.
     
     **UTI:** public.heic
     
     **conforms to:** public.heif-standard
     */
    static var heic: Self { .init(tag: "image/heic", tagClass: .mimeType, conformingTo: nil)! }
    
    /**
     The WebP image format.
     
     **UTI:** org.webmproject.webp
     
     **conforms to:** public.image
     */
    static var webP: Self { .init(tag: "image/webp", tagClass: .mimeType, conformingTo: nil)! }
    
    /**
     A base type for 3D content.
     
     **UTI:** public.3d-content
     
     **conforms to:** public.content
     */
    static var threeDContent: Self { .init(kUTType3DContent as String)! }
    
    /**
     Universal Scene Description content.
     
     **UTI:** com.pixar.universal-scene-description
     
     **conforms to:** public.3d-content, public.data
     */
    static var usd: Self { .init(tag: "usd", tagClass: .filenameExtension, conformingTo: nil)! }
    
    /**
     Universal Scene Description Package content.
     
     **UTI:** com.pixar.universal-scene-description-mobile
     
     **conforms to:** public.3d-content, public.data
     */
    static var usdz: Self { .init(tag: "usdz", tagClass: .filenameExtension, conformingTo: nil)! }
    
    /**
     A Reality File.
     
     **UTI:** com.apple.reality
     
     **conforms to:** public.data
     */
    static var realityFile: Self { .init(tag: "model/vnd.reality", tagClass: .mimeType, conformingTo: nil)! }
    
    /**
     A SceneKit serialized scene.
     
     **UTI:** com.apple.scenekit.scene
     
     **conforms to:** public.3d-content, public.data
     */
    static var sceneKitScene: Self { .init(tag: "scn", tagClass: .filenameExtension, conformingTo: nil)! }
    
    /**
     An AR reference object.
     
     **UTI:** com.apple.arobject
     
     **conforms to:** public.data
     */
    static var arReferenceObject: Self { .init(tag: "arobject", tagClass: .filenameExtension, conformingTo: nil)! }
    
    /**
     A media format which may contain both video and audio.
     
     This type corresponds to what users would label a "movie".
     
     **UTI:** public.movie
     
     **conforms to:** public.audiovisual-content
     */
    static var movie: Self { .init(kUTTypeMovie as String)! }
    
    /**
     Pure video data with no audio data.
     
     **UTI:** public.video
     
     **conforms to:** public.movie
     */
    static var video: Self { .init(kUTTypeVideo as String)! }
    
    /**
     Pure audio data with no video data.
     
     **UTI:** public.audio
     
     **conforms to:** public.audiovisual-content
     */
    static var audio: Self { .init(kUTTypeAudio as String)! }
    
    /**
     A QuickTime movie.
     
     **UTI:** com.apple.quicktime-movie
     
     **conforms to:** public.movie
     */
    static var quickTimeMovie: Self { .init(kUTTypeQuickTimeMovie as String)! }
    
    /**
     An MPEG-1 or MPEG-2 movie.
     
     **UTI:** public.mpeg
     
     **conforms to:** public.movie
     */
    static var mpeg: Self { .init(kUTTypeMPEG as String)! }
    
    /**
     An MPEG-2 video.
     
     **UTI:** public.mpeg-2-video
     
     **conforms to:** public.video
     */
    static var mpeg2Video: Self { .init(kUTTypeMPEG2Video as String)! }
    
    /**
     The MPEG-2 Transport Stream movie format.
     
     **UTI:** public.mpeg-2-transport-stream
     
     **conforms to:** public.movie
     */
    static var mpeg2TransportStream: Self { .init(kUTTypeMPEG2TransportStream as String)! }
    
    /**
     MP3 audio.
     
     **UTI:** public.mp3
     
     **conforms to:** public.audio
     */
    static var mp3: Self { .init(kUTTypeMP3 as String)! }
    
    /**
     MPEG-4 movie
     
     **UTI:** public.mpeg-4
     
     **conforms to:** public.movie
     */
    static var mpeg4Movie: Self { .init(kUTTypeMPEG4 as String)! }
    
    /**
     An MPEG-4 audio layer file.
     
     **UTI:** public.mpeg-4-audio
     
     **conforms to:** public.mpeg-4, public.audio
     */
    static var mpeg4Audio: Self { .init(kUTTypeMPEG4Audio as String)! }
    
    /**
     The Apple protected MPEG4 format (.m4p, iTunes music store format.)
     
     **UTI:** com.apple.protected-mpeg-4-audio
     
     **conforms to:** public.audio
     */
    static var appleProtectedMPEG4Audio: Self { .init(kUTTypeAppleProtectedMPEG4Audio as String)! }
    
    /**
     An Apple protected MPEG-4 movie.
     
     **UTI:** com.apple.protected-mpeg-4-video
     
     **conforms to:** com.apple.m4v-video
     */
    static var appleProtectedMPEG4Video: Self { .init(kUTTypeAppleProtectedMPEG4Video as String)! }
    
    /**
     The AVI movie format.
     
     **UTI:** public.avi
     
     **conforms to:** public.movie
     */
    static var avi: Self { .init(kUTTypeAVIMovie as String)! }
    
    /**
     The AIFF audio format
     
     **UTI:** public.aiff-audio
     
     **conforms to:** public.aifc-audio
     */
    static var aiff: Self { .init(kUTTypeAudioInterchangeFileFormat as String)! }
    
    /**
     The Microsoft waveform audio format (.wav).
     
     **UTI:** com.microsoft.waveform-audio
     
     **conforms to:** public.audio
     */
    static var wav: Self { .init(kUTTypeWaveformAudio as String)! }
    
    /**
     The MIDI audio format.
     
     **UTI:** public.midi-audio
     
     **conforms to:** public.audio
     */
    static var midi: Self { .init(kUTTypeMIDIAudio as String)! }
    
    /**
     The base type for playlists.
     
     **UTI:** public.playlist
     */
    static var playlist: Self { .init(kUTTypePlaylist as String)! }
    
    /**
     An M3U or M3U8 playlist
     
     **UTI:** public.m3u-playlist
     
     **conforms to:** public.text, public.playlist
     */
    static var m3uPlaylist: Self { .init(kUTTypeM3UPlaylist as String)! }
    
    /**
     A user-browsable directory (i.e. not a package.)
     
     **UTI:** public.folder
     
     **conforms to:** public.directory
     */
    static var folder: Self { .init(kUTTypeFolder as String)! }
    
    /**
     The root folder of a volume or mount point.
     
     **UTI:** public.volume
     
     **conforms to:** public.folder
     */
    static var volume: Self { .init(kUTTypeVolume as String)! }
    
    /**
     A packaged directory.
     
     Bundles differ from packages in that a bundle has an internal file hierarchy
     that `CFBundle` can read, while packages are displayed to the user as if
     they were regular files. A single file system object can be both a package
     and a bundle.
     
     **UTI:** com.apple.package
     
     **conforms to:** public.directory
     */
    static var package: Self { .init(kUTTypePackage as String)! }
    
    /**
     A directory conforming to one of the `CFBundle` layouts.
     
     Bundles differ from packages in that a bundle has an internal file hierarchy
     that `CFBundle` can read, while packages are displayed to the user as if
     they were regular files. A single file system object can be both a package
     and a bundle.
     
     **UTI:** com.apple.bundle
     
     **conforms to:** public.directory
     */
    static var bundle: Self { .init(kUTTypeBundle as String)! }
    
    /**
     The base type for bundle-based plugins.
     
     **UTI:** com.apple.plugin
     
     **conforms to:** com.apple.bundle, com.apple.package
     */
    static var pluginBundle: Self { .init(kUTTypePluginBundle as String)! }
    
    /**
     A Spotlight metadata importer bundle.
     
     **UTI:** com.apple.metadata-importer
     
     **conforms to:** com.apple.plugin
     */
    static var spotlightImporter: Self { .init(kUTTypeSpotlightImporter as String)! }
    
    /**
     A QuickLook preview generator bundle.
     
     **UTI:** com.apple.quicklook-generator
     
     **conforms to:** com.apple.plugin
     */
    static var quickLookGenerator: Self { .init(kUTTypeQuickLookGenerator as String)! }
    
    /**
     An XPC service bundle.
     
     **UTI:** com.apple.xpc-service
     
     **conforms to:** com.apple.bundle, com.apple.package
     */
    static var xpcService: Self { .init(kUTTypeXPCService as String)! }
    
    /**
     A macOS or iOS framework bundle.
     
     **UTI:** com.apple.framework
     
     **conforms to:** com.apple.bundle
     */
    static var framework: Self { .init(kUTTypeFramework as String)! }
    
    /**
     The base type for macOS and iOS applications.
     
     **UTI:** com.apple.application
     
     **conforms to:** public.executable
     */
    static var application: Self { .init(kUTTypeApplication as String)! }
    
    /**
     A bundled application.
     
     **UTI:** com.apple.application-bundle
     
     **conforms to:** com.apple.application, com.apple.bundle, com.apple.package
     */
    static var applicationBundle: Self { .init(kUTTypeApplicationBundle as String)! }
    
    /**
     An application extension (.appex).
     
     **UTI:** com.apple.application-and-system-extension
     
     **conforms to:** com.apple.xpc-service
     */
    static var applicationExtension: Self { .init(tag: "appex", tagClass: .filenameExtension, conformingTo: nil)! }
    
    /**
     A UNIX executable (flat file.)
     
     **UTI:** public.unix-executable
     
     **conforms to:** public.data, public.executable
     */
    static var unixExecutable: Self { .init(kUTTypeUnixExecutable as String)! }
    
    /**
     A Windows executable (.exe).
     
     **UTI:** com.microsoft.windows-executable
     
     **conforms to:** public.data, public.executable
     */
    static var exe: Self { .init(kUTTypeExecutable as String)! }
    
    /**
     A System Preferences pane.
     
     **UTI:** com.apple.systempreference.prefpane
     
     **conforms to:** com.apple.package, com.apple.bundle
     */
    static var systemPreferencesPane: Self { .init(kUTTypeSystemPreferencesPane as String)! }
    
    /**
     an archive of files and directories
     
     **UTI:** public.archive
     */
    static var archive: Self { .init(kUTTypeArchive as String)! }
    
    /**
     A GNU zip archive.
     
     **UTI:** org.gnu.gnu-zip-archive
     
     **conforms to:** public.data, public.archive
     */
    static var gzip: Self { .init(kUTTypeGNUZipArchive as String)! }
    
    /**
     A bzip2 archive.
     
     **UTI:** public.bzip2-archive
     
     **conforms to:** public.data, public.archive
     */
    static var bz2: Self { .init(kUTTypeBzip2Archive as String)! }
    
    /**
     A zip archive.
     
     **UTI:** public.zip-archive
     
     **conforms to:** com.pkware.zip-archive
     */
    static var zip: Self { .init(kUTTypeZipArchive as String)! }
    
    /**
     An Apple Archive.
     
     **UTI:** com.apple.archive
     
     **conforms to:** public.data, public.archive
     */
    static var appleArchive: Self { .init(tag: "aar", tagClass: .filenameExtension, conformingTo: nil)! }
    
    /**
     A base type for spreadsheet documents.
     
     **UTI:** public.spreadsheet
     
     **conforms to:** public.content
     */
    static var spreadsheet: Self { .init(kUTTypeSpreadsheet as String)! }
    
    /**
     A base type for presentation documents.
     
     **UTI:** public.presentation
     
     **conforms to:** public.composite-content
     */
    static var presentation: Self { .init(kUTTypePresentation as String)! }
    
    /**
     A database store.
     
     **UTI:** public.database
     */
    static var database: Self { .init(kUTTypeData as String)! }
    
    /**
     A base type for messages (email, IM, etc.)
     
     **UTI:** public.message
     */
    static var message: Self { .init(kUTTypeMessage as String)! }
    
    /**
     contact information, e.g. for a person, group, organization
     
     **UTI:** public.contact
     */
    static var contact: Self { .init(kUTTypeContact as String)! }
    
    /**
     A vCard file.
     
     **UTI:** public.vcard
     
     **conforms to:** public.text, public.contact
     */
    static var vCard: Self { .init(kUTTypeVCard as String)! }
    
    /**
     A to-do item.
     
     **UTI:** public.to-do-item
     */
    static var toDoItem: Self { .init(kUTTypeToDoItem as String)! }
    
    /**
     A calendar event.
     
     **UTI:** public.calendar-event
     */
    static var calendarEvent: Self { .init(kUTTypeCalendarEvent as String)! }
    
    /**
     An e-mail message.
     
     **UTI:** public.email-message
     
     **conforms to:** public.message
     */
    static var emailMessage: Self { .init(kUTTypeEmailMessage as String)! }
    
    /**
     A base type for Apple Internet location files.
     
     **UTI:** com.apple.internet-location
     
     **conforms to:** public.data
     */
    static var internetLocation: Self { .init(kUTTypeInternetLocation as String)! }
    
    /**
     Microsoft Internet shortcut files (.url).
     
     **UTI:** com.apple.internet-location
     
     **conforms to:** public.data
     */
    static var internetShortcut: Self { .init(tag: "url", tagClass: .filenameExtension, conformingTo: nil)! }
    
    /**
     A base type for fonts.
     
     **UTI:** public.font
     */
    static var font: Self { .init(kUTTypeFont as String)! }
    
    /**
     A bookmark.
     
     **UTI:** public.bookmark
     
     - SeeAlso: Self.urlBookmarkData
     */
    static var bookmark: Self { .init(kUTTypeBookmark as String)! }
    
    /**
     PKCS#12 data.
     
     **UTI:** com.rsa.pkcs-12
     
     **conforms to:** public.data
     */
    static var pkcs12: Self { .init(kUTTypePKCS12 as String)! }
    
    /**
     An X.509 certificate.
     
     **UTI:** public.x509-certificate
     
     **conforms to:** public.data
     */
    static var x509Certificate: Self { .init(kUTTypeX509Certificate as String)! }
    
    /**
     The EPUB format.
     
     **UTI:** org.idpf.epub-container
     
     **conforms to:** public.data, public.composite-content
     */
    static var epub: Self { .init(tag: "application/epub+zip", tagClass: .mimeType, conformingTo: nil)! }
    
    /**
     A base type for console logs.
     
     **UTI:** public.log
     */
    static var log: Self { .init(kUTTypeLog as String)! }
}
