import Foundation

public extension Backport<Any>.UTType {
    static var declared: Set<Self> = {
        var types: Set<Self> = [
            .item,

            /**
             A base type for anything containing user-viewable document content
             (documents, pasteboard data, and document packages.)

             Types describing files or packages must also conform to `UTType.data` or
             `UTType.package` in order for the system to bind documents to them.

             **UTI:** public.content
             */
            .content,

            /**
             A base type for content formats supporting mixed embedded content
             (i.e., compound documents).

             **UTI:** public.composite-content

             **conforms to:** public.content
             */
            .compositeContent,

            /**
             A data item mountable as a volume

             **UTI:** public.disk-image
             */
            .diskImage,

            /**
             A base type for any sort of simple byte stream, including files and
             in-memory data.

             **UTI:** public.data

             **conforms to:** public.item
             */
            .data,

            /**
             A file system directory (includes packages _and_ folders.)

             **UTI:** public.directory

             **conforms to:** public.item
             */
            .directory,

            /**
             Symbolic link and alias file types conform to this type.

             **UTI:** com.apple.resolvable
             */
            .resolvable,

            /**
             A symbolic link.

             **UTI:** public.symlink

             **conforms to:** public.item, com.apple.resolvable
             */
            .symbolicLink,

            /**
             An executable item.

             **UTI:** public.executable

             **conforms to:** public.item
             */
            .executable,

            /**
             A volume mount point (resolvable, resolves to the root directory of a
             volume.)

             **UTI:** com.apple.mount-point

             **conforms to:** public.item, com.apple.resolvable
             */
            .mountPoint,

            /**
             A fully-formed alias file.

             **UTI:** com.apple.alias-file

             **conforms to:** public.data, com.apple.resolvable
             */
            .aliasFile,

            /**
             A URL bookmark.

             **UTI:** com.apple.bookmark

             **conforms to:** public.data, com.apple.resolvable
             */
            .urlBookmarkData,

            /**
             Any URL.

             **UTI:** public.url

             **conforms to:** public.data
             */
            .url,

            /**
             A URL with the scheme `"file:"`.

             **UTI:** public.file-url

             **conforms to:** public.url
             */
            .fileURL,

            /**
             The base type for all text-encoded data, including text with markup
             (HTML, RTF, etc.).

             **UTI:** public.text

             **conforms to:** public.data, public.content
             */
            .text,

            /**
             Text with no markup and an unspecified encoding.

             **UTI:** public.plain-text

             **conforms to:** public.text
             */
            .plainText,

            /**
             Plain text encoded as UTF-8.

             **UTI:** public.utf8-plain-text

             **conforms to:** public.plain-text
             */
            .utf8PlainText,

            /**
             Plain text encoded as UTF-16 with a BOM, or if a BOM is not present,
             using "external representation" byte order (big-endian).

             **UTI:** public.utf16-external-plain-text

             **conforms to:** public.plain-text
             */
            .utf16ExternalPlainText,

            /**
             Plain text encoded as UTF-16, in native byte order, with an optional
             BOM.

             **UTI:** public.utf16-plain-text

             **conforms to:** public.plain-text
             */
            .utf16PlainText,

            /**
             Text containing delimited values.

             **UTI:** public.delimited-values-text

             **conforms to:** public.text
             */
            .delimitedText,

            /**
             Text containing comma-separated values (.csv).

             **UTI:** public.comma-separated-values-text

             **conforms to:** public.delimited-values-text
             */
            .commaSeparatedText,

            /**
             Text containing tab-separated values.

             **UTI:** public.tab-separated-values-text

             **conforms to:** public.delimited-values-text
             */
            .tabSeparatedText,

            /**
             UTF-8 encoded text containing tab-separated values.

             **UTI:** public.utf8-tab-separated-values-text

             **conforms to:** public.tab-separated-values-text, public.utf8-plain-text
             */
            .utf8TabSeparatedText,

            /**
             Rich Text Format data.

             **UTI:** public.rtf

             **conforms to:** public.text
             */
            .rtf,

            /**
             Any version of HTML.

             **UTI:** public.html

             **conforms to:** public.text
             */
            .html,

            /**
             Generic XML.

             **UTI:** public.xml

             **conforms to:** public.text
             */
            .xml,

            /**
             Yet Another Markup Language.

             **UTI:** public.yaml

             **conforms to:** public.text
             */
            .yaml,

            /**
             Abstract type for source code of any language.

             **UTI:** public.source-code

             **conforms to:** public.plain-text
             */
            .sourceCode,

            /**
             Assembly language source (.s)

             **UTI:** public.assembly-source

             **conforms to:** public.source-code
             */
            .assemblyLanguageSource,

            /**
             C source code (.c)

             **UTI:** public.c-source

             **conforms to:** public.source-code
             */
            .cSource,

            /**
             Objective-C source code (.m)

             **UTI:** public.objective-c-source

             **conforms to:** public.source-code
             */
            .objectiveCSource,

            /**
             Swift source code (.swift)

             **UTI:** public.swift-source

             **conforms to:** public.source-code
             */
            .swiftSource,

            /**
             C++ source code (.cp, etc.)

             **UTI:** public.c-plus-plus-source

             **conforms to:** public.source-code
             */
            .cPlusPlusSource,

            /**
             Objective-C++ source code.

             **UTI:** public.objective-c-plus-plus-source

             **conforms to:** public.source-code
             */
            .objectiveCPlusPlusSource,

            /**
             A C header.

             **UTI:** public.c-header

             **conforms to:** public.source-code
             */
            .cHeader,

            /**
             A C++ header.

             **UTI:** public.c-plus-plus-header

             **conforms to:** public.source-code
             */
            .cPlusPlusHeader,

            /**
             A base type for any scripting language source.

             **UTI:** public.script

             **conforms to:** public.source-code
             */
            .script,

            /**
             An AppleScript text-based script (.applescript).

             **UTI:** com.apple.applescript.text

             **conforms to:** public.script
             */
            .appleScript,

            /**
             An Open Scripting Architecture binary script (.scpt).

             **UTI:** com.apple.applescript.script

             **conforms to:** public.data, public.script
             */
            .osaScript,

            /**
             An Open Scripting Architecture script bundle (.scptd).

             **UTI:** com.apple.applescript.script-bundle

             **conforms to:** com.apple.bundle, com.apple.package, public.script
             */
            .osaScriptBundle,

            /**
             JavaScript source code

             **UTI:** com.netscape.javascript-source

             **conforms to:** public.source-code, public.executable
             */
            .javaScript,

            /**
             The base type for shell scripts.

             **UTI:** public.shell-script

             **conforms to:** public.script
             */
            .shellScript,

            /**
             A Perl script.

             **UTI:** public.perl-script

             **conforms to:** public.shell-script
             */
            .perlScript,

            /**
             A Python script.

             **UTI:** public.python-script

             **conforms to:** public.shell-script
             */
            .pythonScript,

            /**
             A Ruby script.

             **UTI:** public.ruby-script

             **conforms to:** public.shell-script
             */
            .rubyScript,

            /**
             A PHP script.

             **UTI:** public.php-script

             **conforms to:** public.shell-script
             */
            .phpScript,

            /**
             JavaScript object notation (JSON) data

             **UTI:** public.json

             **conforms to:** public.text

             - Note: JSON almost (but doesn't quite) conforms to
             com.netscape.javascript-source.
             */
            .json,

            /**
             A base type for property lists.

             **UTI:** com.apple.property-list

             **conforms to:** public.data
             */
            .propertyList,

            /**
             An XML property list.

             **UTI:** com.apple.xml-property-list

             **conforms to:** public.xml, com.apple.property-list
             */
            .xmlPropertyList,

            /**
             A binary property list.

             **UTI:** com.apple.binary-property-list

             **conforms to:** com.apple.property-list
             */
            .binaryPropertyList,

            /**
             An Adobe PDF document.

             **UTI:** com.adobe.pdf

             **conforms to:** public.data, public.composite-content
             */
            .pdf,

            /**
             A Rich Text Format Directory document (RTF with content embedding
             in its on-disk format.)

             **UTI:** com.apple.rtfd

             **conforms to:** com.apple.package, public.composite-content
             */
            .rtfd,

            /**
             A flattened RTFD document (formatted for the pasteboard.)

             **UTI:** com.apple.flat-rtfd

             **conforms to:** public.data, public.composite-content
             */
            .flatRTFD,

            /**
             The WebKit webarchive format.

             **UTI:** com.apple.webarchive

             **conforms to:** public.data, public.composite-content
             */
            .webArchive,

            /**
             A base type for abstract image data.

             **UTI:** public.image

             **conforms to:** public.data, public.content
             */
            .image,

            /**
             A JPEG image.

             **UTI:** public.jpeg

             **conforms to:** public.image
             */
            .jpeg,

            /**
             A TIFF image.

             **UTI:** public.tiff

             **conforms to:** public.image
             */
            .tiff,

            /**
             A GIF image.

             **UTI:** com.compuserve.gif

             **conforms to:** public.image
             */
            .gif,

            /**
             A PNG image.

             **UTI:** public.png

             **conforms to:** public.image
             */
            .png,

            /**
             Apple icon data

             **UTI:** com.apple.icns

             **conforms to:** public.image
             */
            .icns,

            /**
             A Windows bitmap.

             **UTI:** com.microsoft.bmp

             **conforms to:** public.image
             */
            .bmp,

            /**
             Windows icon data

             **UTI:** com.microsoft.ico

             **conforms to:** public.image
             */
            .ico,

            /**
             A base type for raw image data (.raw).

             **UTI:** public.camera-raw-image

             **conforms to:** public.image
             */
            .rawImage,

            /**
             A Scalable Vector Graphics image.

             **UTI:** public.svg-image

             **conforms to:** public.image
             */
            .svg,

            /**
             A Live Photo.

             **UTI:** com.apple.live-photo
             */
            .livePhoto,

            /**
             A High Efficiency Image File Format image.

             **UTI:** public.heif

             **conforms to:** public.heif-standard
             */
            .heif,

            /**
             A High Efficiency Image Coding image.

             **UTI:** public.heic

             **conforms to:** public.heif-standard
             */
            .heic,

            /**
             The WebP image format.

             **UTI:** org.webmproject.webp

             **conforms to:** public.image
             */
            .webP,

            /**
             A base type for 3D content.

             **UTI:** public.3d-content

             **conforms to:** public.content
             */
            .threeDContent,

            /**
             Universal Scene Description content.

             **UTI:** com.pixar.universal-scene-description

             **conforms to:** public.3d-content, public.data
             */
            .usd,

            /**
             Universal Scene Description Package content.

             **UTI:** com.pixar.universal-scene-description-mobile

             **conforms to:** public.3d-content, public.data
             */
            .usdz,

            /**
             A Reality File.

             **UTI:** com.apple.reality

             **conforms to:** public.data
             */
            .realityFile,

            /**
             A SceneKit serialized scene.

             **UTI:** com.apple.scenekit.scene

             **conforms to:** public.3d-content, public.data
             */
            .sceneKitScene,

            /**
             An AR reference object.

             **UTI:** com.apple.arobject

             **conforms to:** public.data
             */
            .arReferenceObject,

            /**
             A media format which may contain both video and audio.

             This type corresponds to what users would label a "movie".

             **UTI:** public.movie

             **conforms to:** public.audiovisual-content
             */
            .movie,

            /**
             Pure video data with no audio data.

             **UTI:** public.video

             **conforms to:** public.movie
             */
            .video,

            /**
             Pure audio data with no video data.

             **UTI:** public.audio

             **conforms to:** public.audiovisual-content
             */
            .audio,

            /**
             A QuickTime movie.

             **UTI:** com.apple.quicktime-movie

             **conforms to:** public.movie
             */
            .quickTimeMovie,

            /**
             An MPEG-1 or MPEG-2 movie.

             **UTI:** public.mpeg

             **conforms to:** public.movie
             */
            .mpeg,

            /**
             An MPEG-2 video.

             **UTI:** public.mpeg-2-video

             **conforms to:** public.video
             */
            .mpeg2Video,

            /**
             The MPEG-2 Transport Stream movie format.

             **UTI:** public.mpeg-2-transport-stream

             **conforms to:** public.movie
             */
            .mpeg2TransportStream,

            /**
             MP3 audio.

             **UTI:** public.mp3

             **conforms to:** public.audio
             */
            .mp3,

            /**
             MPEG-4 movie

             **UTI:** public.mpeg-4

             **conforms to:** public.movie
             */
            .mpeg4Movie,

            /**
             An MPEG-4 audio layer file.

             **UTI:** public.mpeg-4-audio

             **conforms to:** public.mpeg-4, public.audio
             */
            .mpeg4Audio,

            /**
             The Apple protected MPEG4 format (.m4p, iTunes music store format.)

             **UTI:** com.apple.protected-mpeg-4-audio

             **conforms to:** public.audio
             */
            .appleProtectedMPEG4Audio,

            /**
             An Apple protected MPEG-4 movie.

             **UTI:** com.apple.protected-mpeg-4-video

             **conforms to:** com.apple.m4v-video
             */
            .appleProtectedMPEG4Video,

            /**
             The AVI movie format.

             **UTI:** public.avi

             **conforms to:** public.movie
             */
            .avi,

            /**
             The AIFF audio format

             **UTI:** public.aiff-audio

             **conforms to:** public.aifc-audio
             */
            .aiff,

            /**
             The Microsoft waveform audio format (.wav).

             **UTI:** com.microsoft.waveform-audio

             **conforms to:** public.audio
             */
            .wav,

            /**
             The MIDI audio format.

             **UTI:** public.midi-audio

             **conforms to:** public.audio
             */
            .midi,

            /**
             The base type for playlists.

             **UTI:** public.playlist
             */
            .playlist,

            /**
             An M3U or M3U8 playlist

             **UTI:** public.m3u-playlist

             **conforms to:** public.text, public.playlist
             */
            .m3uPlaylist,

            /**
             A user-browsable directory (i.e. not a package.)

             **UTI:** public.folder

             **conforms to:** public.directory
             */
            .folder,

            /**
             The root folder of a volume or mount point.

             **UTI:** public.volume

             **conforms to:** public.folder
             */
            .volume,

            /**
             A packaged directory.

             Bundles differ from packages in that a bundle has an internal file hierarchy
             that `CFBundle` can read, while packages are displayed to the user as if
             they were regular files. A single file system object can be both a package
             and a bundle.

             **UTI:** com.apple.package

             **conforms to:** public.directory
             */
            .package,

            /**
             A directory conforming to one of the `CFBundle` layouts.

             Bundles differ from packages in that a bundle has an internal file hierarchy
             that `CFBundle` can read, while packages are displayed to the user as if
             they were regular files. A single file system object can be both a package
             and a bundle.

             **UTI:** com.apple.bundle

             **conforms to:** public.directory
             */
            .bundle,

            /**
             The base type for bundle-based plugins.

             **UTI:** com.apple.plugin

             **conforms to:** com.apple.bundle, com.apple.package
             */
            .pluginBundle,

            /**
             A Spotlight metadata importer bundle.

             **UTI:** com.apple.metadata-importer

             **conforms to:** com.apple.plugin
             */
            .spotlightImporter,

            /**
             A QuickLook preview generator bundle.

             **UTI:** com.apple.quicklook-generator

             **conforms to:** com.apple.plugin
             */
            .quickLookGenerator,

            /**
             An XPC service bundle.

             **UTI:** com.apple.xpc-service

             **conforms to:** com.apple.bundle, com.apple.package
             */
            .xpcService,

            /**
             A macOS or iOS framework bundle.

             **UTI:** com.apple.framework

             **conforms to:** com.apple.bundle
             */
            .framework,

            /**
             The base type for macOS and iOS applications.

             **UTI:** com.apple.application

             **conforms to:** public.executable
             */
            .application,

            /**
             A bundled application.

             **UTI:** com.apple.application-bundle

             **conforms to:** com.apple.application, com.apple.bundle, com.apple.package
             */
            .applicationBundle,

            /**
             An application extension (.appex).

             **UTI:** com.apple.application-and-system-extension

             **conforms to:** com.apple.xpc-service
             */
            .applicationExtension,

            /**
             A UNIX executable (flat file.)

             **UTI:** public.unix-executable

             **conforms to:** public.data, public.executable
             */
            .unixExecutable,

            /**
             A Windows executable (.exe).

             **UTI:** com.microsoft.windows-executable

             **conforms to:** public.data, public.executable
             */
            .exe,

            /**
             A System Preferences pane.

             **UTI:** com.apple.systempreference.prefpane

             **conforms to:** com.apple.package, com.apple.bundle
             */
            .systemPreferencesPane,

            /**
             an archive of files and directories

             **UTI:** public.archive
             */
            .archive,

            /**
             A GNU zip archive.

             **UTI:** org.gnu.gnu-zip-archive

             **conforms to:** public.data, public.archive
             */
            .gzip,

            /**
             A bzip2 archive.

             **UTI:** public.bzip2-archive

             **conforms to:** public.data, public.archive
             */
            .bz2,

            /**
             A zip archive.

             **UTI:** public.zip-archive

             **conforms to:** com.pkware.zip-archive
             */
            .zip,

            /**
             An Apple Archive.

             **UTI:** com.apple.archive

             **conforms to:** public.data, public.archive
             */
            .appleArchive,

            /**
             A base type for spreadsheet documents.

             **UTI:** public.spreadsheet

             **conforms to:** public.content
             */
            .spreadsheet,

            /**
             A base type for presentation documents.

             **UTI:** public.presentation

             **conforms to:** public.composite-content
             */
            .presentation,

            /**
             A database store.

             **UTI:** public.database
             */
            .database,

            /**
             A base type for messages (email, IM, etc.)

             **UTI:** public.message
             */
            .message,

            /**
             contact information, e.g. for a person, group, organization

             **UTI:** public.contact
             */
            .contact,

            /**
             A vCard file.

             **UTI:** public.vcard

             **conforms to:** public.text, public.contact
             */
            .vCard,

            /**
             A to-do item.

             **UTI:** public.to-do-item
             */
            .toDoItem,

            /**
             A calendar event.

             **UTI:** public.calendar-event
             */
            .calendarEvent,

            /**
             An e-mail message.

             **UTI:** public.email-message

             **conforms to:** public.message
             */
            .emailMessage,

            /**
             A base type for Apple Internet location files.

             **UTI:** com.apple.internet-location

             **conforms to:** public.data
             */
            .internetLocation,

            /**
             Microsoft Internet shortcut files (.url).

             **UTI:** com.apple.internet-location

             **conforms to:** public.data
             */
            .internetShortcut,

            /**
             A base type for fonts.

             **UTI:** public.font
             */
            .font,

            /**
             A bookmark.

             **UTI:** public.bookmark

             - SeeAlso: UTType.urlBookmarkData
             */
            .bookmark,

            /**
             PKCS#12 data.

             **UTI:** com.rsa.pkcs-12

             **conforms to:** public.data
             */
            .pkcs12,

            /**
             An X.509 certificate.

             **UTI:** public.x509-certificate

             **conforms to:** public.data
             */
            .x509Certificate,

            /**
             The EPUB format.

             **UTI:** org.idpf.epub-container

             **conforms to:** public.data, public.composite-content
             */
            .epub,

            /**
             A base type for console logs.

             **UTI:** public.log
             */
            .log,
        ]

        if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) {
            /**
             A makefile.

             **UTI:** public.make-source

             **conforms to:** public.script
             */
            types.insert(.makefile)
        }

        return types
    }()
}
