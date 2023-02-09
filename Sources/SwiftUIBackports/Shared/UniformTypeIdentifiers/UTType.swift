import Foundation
import CoreServices

extension Backport<Any> {
    /**
     A structure representing a type in a type hierarchy.

     Types may represent files on disk, abstract data types with no on-disk
     representation, or even entirely unrelated hierarchical classification
     systems such as hardware.

     Older API that does not use `UTType` typically uses an untyped `String`
     or `CFString` to refer to a type by its identifier. To get the identifier of
     a type for use with these APIs, use the `identifier` property of this type.
     */
    @available(iOS, introduced: 11, deprecated: 14, message: "Use UniformTypeIdentifiers.UTType instead")
    @available(macOS, introduced: 10.5, deprecated: 11, message: "Use UniformTypeIdentifiers.UTType instead")
    @available(watchOS, introduced: 5, deprecated: 7, message: "Use UniformTypeIdentifiers.UTType instead")
    @available(tvOS, introduced: 11, deprecated: 14, message: "Use UniformTypeIdentifiers.UTType instead")
    public struct UTType: Codable, Hashable, CustomStringConvertible, CustomDebugStringConvertible, Sendable {
        /**
         The receiver's identifier.

         A type is _identified by_ its Uniform Type Identifier (UTI), a
         reverse-DNS string such as `"public.jpeg"` or `"com.adobe.pdf"`. The
         type itself _has_ a UTI, but is not itself the UTI. This terminology is
         not consistently used across Apple's documentation.

         Older API that does not use `UTType` typically uses an untyped `String`
         or `CFString` to refer to a type by its identifier.
         */
        public let identifier: String

        /**
         If available, the preferred (first available) tag of class
         `.filenameExtension`.

         Many uses of types require the generation of a filename (e.g. when
         saving a file to disk.) If not `nil`, the value of this property is the
         best available filename extension for the given type, according to its
         declaration. The value of this property is equivalent to, but more
         efficient than:

         ```
         type.tags[.filenameExtension]?.first
         ```
         */
        public var preferredFilenameExtension: String? {
            UTTypeCopyPreferredTagWithClass(
                identifier as CFString,
                Backport.UTTagClass.filenameExtension.rawValue as CFString
            )?.takeRetainedValue() as? String
        }

        /**
         If available, the preferred (first available) tag of class
         `.mimeType`.

         If not `nil`, the value of this property is the best available MIME
         type for the given type, according to its declaration. The value of this
         property is equivalent to, but more efficient than:

         ```
         type.tags[.mimeType]?.first
         ```
         */
        public var preferredMIMEType: String? {
            UTTypeCopyPreferredTagWithClass(
                identifier as CFString,
                Backport.UTTagClass.mimeType.rawValue as CFString
            )?.takeRetainedValue() as? String
        }

        /**
         Whether or not the receiver is a type known to the system.

         A type cannot be both declared _and_ dynamic. You cannot construct an
         instance of `UTType` that is neither declared nor dynamic.
         */
        public var isDeclared: Bool {
            UTTypeIsDeclared(identifier as CFString)
        }

        /**
         Whether or not the receiver is a dynamically generated type.

         Dynamic types are recognized by the system, but may not be directly
         declared or claimed by an application. They are used when a file is
         encountered whose metadata has no corresponding type known to the
         system.

         A type cannot be both declared _and_ dynamic. You cannot construct an
         instance of `UTType` that is neither declared nor dynamic.
         */
        public var isDynamic: Bool {
            UTTypeIsDynamic(identifier as CFString)
        }

        /**
         The reference URL of the type.

         A reference URL is a human-readable document describing a type. Most
         types do not specify reference URLs.

         - Warning: This URL is not validated in any way by the system, nor is
         its scheme or structure guaranteed in any way.
         */
        public var referenceURL: URL? {
            UTTypeCopyDeclaringBundleURL(identifier as CFString)?.takeRetainedValue() as? URL
        }

        public var description: String { identifier }
        public var debugDescription: String {
            [
                "\(identifier) (\(isDynamic ? "dynamic" : "not dynamic")",
                "\(isDeclared ? "declared" : "not declared"))"
            ].joined(separator: ",")
        }

        public var localizedDescription: String? {
            UTTypeCopyDescription(identifier as CFString)?.takeRetainedValue() as? String
        }

        /**
         The tag specification dictionary of the type.

         The system does not store tag information for non-standard tag classes.
         It normalizes string values into arrays containing those strings. For
         instance, a value of:

         ```
         {
         "public.mime-type": "x/y",
         "nonstandard-tag-class": "abc",
         }
         ```

         Is normalized to:

         ```
         {
         "public.mime-type": [ "x/y" ]
         }
         ```

         If you are simply looking for the preferred filename extension or MIME
         type of a type, it is more efficient for you to use the
         `preferredFilenameExtension` and `preferredMIMEType` properties
         respectively.
         */
        public var tags: [Backport.UTTagClass: [String]] {
            let params = UTTypeCopyDeclaration(identifier as CFString)?.takeRetainedValue() as? [CFString: Any]
            let spec = params?[kUTTypeTagSpecificationKey] as? [String: Any]
            let mimeTypes = spec?[Backport.UTTagClass.mimeType.rawValue] as? [String] ?? []
            let extensions = spec?[Backport.UTTagClass.filenameExtension.rawValue] as? [String] ?? []
            return [.mimeType: mimeTypes, .filenameExtension: extensions]
        }

        public var supertypes: Set<Self> {
            let params = UTTypeCopyDeclaration(identifier as CFString)?.takeRetainedValue() as? [String: Any]
            let types = params?[String(kUTTypeConformsToKey)] as? [String] ?? []
            return .init(types.compactMap(Self.init))
        }

        /**
         Create an array of types given a type tag.

         - Parameters:
         - tag: The tag, such as a filename extension, for which a set of
         types is desired.
         - tagClass: The class of the tag, such as `.filenameExtension`.
         - supertype: Another type that the resulting types must
         conform to. If `nil`, no conformance is required.

         - Returns: An array of types, or the empty array if no such types were
         available. If no types are known to the system with the specified
         tag but the inputs were otherwise valid, a dynamic type may be
         provided.
         */
        public static func types(tag: String, tagClass: Backport.UTTagClass, conformingTo type: Self?) -> [Self] {
            let identifiers = UTTypeCreateAllIdentifiersForTag(
                tagClass.rawValue as CFString, tag as CFString,
                type?.identifier as CFString?
            )?.takeRetainedValue() as? [String]
            return identifiers?.compactMap(Self.init) ?? []
        }

        /**
         Tests for a conformance relationship between the receiver and another
         type.

         - Parameters:
         - type: The type against which conformance should be tested.

         - Returns: If the two types are equal, returns `true`. If the receiver
         conforms, directly or indirectly, to `type`, returns `true`.
         Otherwise, returns `false`.

         - SeeAlso: isSupertype(of:)
         - SeeAlso: isSubtype(of:)
         */
        public func conforms(to type: UTType) -> Bool {
            UTTypeConformsTo(
                identifier as CFString,
                type.identifier as CFString
            )
        }

        /**
         Tests if the receiver is a supertype of another type.

         - Parameters:
         - type: The type against which conformance should be tested.

         - Returns: If `type` conforms, directly or indirectly, to the receiver
         and is not equal to it, returns `true`. Otherwise, returns `false`.

         - SeeAlso: conforms(to:)
         - SeeAlso: isSubtype(of:)
         */
        public func isSupertype(of type: UTType) -> Bool {
            type.conforms(to: self) && self != type
        }

        /**
         Tests if the receiver is a subtype of another type.

         - Parameters:
         - type: The type against which conformance should be tested.

         - Returns: If the receiver conforms, directly or indirectly, to `type`
         and is not equal to it, returns `true`. Otherwise, returns `false`.

         - SeeAlso: conforms(to:)
         - SeeAlso: isSupertype(of:)
         */
        public func isSubtype(of type: UTType) -> Bool {
            conforms(to: type) && self != type
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            UTTypeEqual(lhs.identifier as CFString, rhs.identifier as CFString)
        }
    }
}

public extension Backport<Any>.UTType {
    /**
     Create a type given a type identifier.

     - Parameters:
     - identifier: The type identifier.

     - Returns: A type, or `nil` if the type identifier is not known to the
     system.
     */
    init?(_ identifier: String) {
        guard UTTypeIsDeclared(identifier as CFString) else { return nil }
        self.identifier = identifier
    }

    /**
     Create a type given a MIME type.

     - Parameters:
     - mimeType: The MIME type for which a type is desired.
     - supertype: Another type that the resulting type must conform to.
     Typically, you would pass `.data`.

     - Returns: A type. If no types are known to the system with the
     specified MIME type and conformance but the inputs were otherwise
     valid, a dynamic type may be provided. If the inputs were not valid,
     returns `nil`.

     This method is equivalent to:

     ```
     UTType(tag: mimeType, tagClass: .mimeType, conformingTo: supertype)
     ```
     */
    init?(mimeType: String, conformingTo type: Self) {
        guard let identifier = UTTypeCreatePreferredIdentifierForTag(
            Backport.UTTagClass.mimeType.rawValue as CFString,
            mimeType as CFString,
            type.identifier as CFString
        )?.takeRetainedValue() as? String else { return nil }
        self.identifier = identifier
    }

    /**
     Create a type given a filename extension.

     - Parameters:
     - filenameExtension: The filename extension for which a type is
     desired.
     - supertype: Another type that the resulting type must conform to.
     Typically, you would pass `.data` or `.package`.

     - Returns: A type. If no types are known to the system with the
     specified filename extension and conformance but the inputs were
     otherwise valid, a dynamic type may be provided. If the inputs were
     not valid, returns `nil`.

     This method is equivalent to:

     ```
     UTType(tag: filenameExtension, tagClass: .filenameExtension, conformingTo: supertype)
     ```

     To get the type of a file on disk, use `URLResourceValues.contentType`.
     You should not attempt to derive the type of a file system object based
     solely on its filename extension.
     */
    init?(filenameExtension: String, conformingTo type: Self) {
        guard let identifier = UTTypeCreatePreferredIdentifierForTag(
            Backport.UTTagClass.filenameExtension.rawValue as CFString,
            filenameExtension as CFString,
            type.identifier as CFString
        )?.takeRetainedValue() as? String else { return nil }
        self.identifier = identifier
    }

    /**
     Create a type given a type tag.

     - Parameters:
     - tag: The tag, such as a filename extension, for which a type is
     desired.
     - tagClass: The class of the tag, such as `.filenameExtension`.
     - supertype: Another type that the resulting type must conform to.
     If `nil`, no conformance is required.

     - Returns: A type. If no types are known to the system with the
     specified tag but the inputs were otherwise valid, a dynamic type
     may be provided. If the inputs were not valid, returns `nil`.
     */
    init?(tag: String, tagClass: Backport.UTTagClass, conformingTo type: Self?) {
        guard let identifier = UTTypeCreatePreferredIdentifierForTag(
            tagClass.rawValue as CFString,
            tag as CFString,
            type?.identifier as CFString?
        )?.takeRetainedValue() as? String else { return nil }
        self.identifier = identifier
    }

    /**
     Gets an active `UTType` corresponding to a type that is declared as
     "exported" by the current process.

     - Parameters:
     - identifier: The type identifier for which a type is desired.
     - parentType: A parent type that the resulting type is expected to
     conform to. If `nil`, conformance to either `.data` or `.package`
     is assumed.

     - Returns: A type.

     Use this method to get types that are exported by your application. If
     `identifier` does not correspond to any type known to the system, the
     result is undefined.

     You would generally use this method by assigning its value to a
     `static let` constant in an extension of `UTType`:

     ```
     extension UTType {
     static let myFileFormat = UTType(exportedAs: "com.example.myfileformat")
     }
     ```
     */
    init(exportedAs identifier: String, conformingTo type: Self? = nil) {
        if let decl = UTTypeCopyDeclaration(identifier as CFString)?.takeRetainedValue() as? [String: Any],
           let identifier = decl[String(kUTTypeIdentifierKey)] as? String {
            let plist = Bundle.main.infoDictionary?[String(kUTExportedTypeDeclarationsKey)] as? [[String: Any]]
            let isRegistered = plist
                .flatMap { $0 }?
                .compactMap { $0[String(kUTTypeIdentifierKey)] as? String }
                .contains { $0 == identifier }
            ?? false

            if isRegistered {
                self.identifier = identifier
            } else {
                assertionFailure(UTTypeError.expectedExport(identifier).localizedDescription)
                self.identifier = ""
            }
        } else {
            assertionFailure(UTTypeError.exportMissing(identifier).localizedDescription)
            self.identifier = ""
        }
    }

    /**
     Gets an active `UTType` corresponding to a type that is declared as
     "imported" by the current process.

     - Parameters:
     - identifier: The type identifier for which a type is desired.
     - parentType: A parent type that the resulting type is expected to
     conform to. If `nil`, conformance to either `.data` or `.package`
     is assumed.

     - Returns: A type whose identifier may or may not be equal to
     `identifier`, but which is functionally equivalent.

     Use this method to get types that are imported by your application. If
     `identifier` does not correspond to any type known to the system, the
     result is undefined.

     You would generally use this method in the body of a `static` computed
     property in an extension of `UTType` as the type can change over time:

     ```
     extension UTType {
     static var competitorFileFormat: UTType { UTType(importedAs: "com.example.competitorfileformat") }
     }
     ```

     In the general case, this method returns a type with the same
     identifier, but if that type has a preferred filename extension and
     _another_ type is the preferred type for that extension, then that
     _other_ type is substituted.
     */
    init(importedAs identifier: String, conformingTo type: Self? = nil) {
        if let decl = UTTypeCopyDeclaration(identifier as CFString)?.takeRetainedValue() as? [String: Any],
           let identifier = decl[String(kUTTypeIdentifierKey)] as? String {
            let plist = Bundle.main.infoDictionary?[String(kUTImportedTypeDeclarationsKey)] as? [[String: Any]]
            let isRegistered = plist
                .flatMap { $0 }?
                .compactMap { $0[String(kUTTypeIdentifierKey)] as? String }
                .contains { $0 == identifier }
            ?? false
            
            if isRegistered {
                self.identifier = identifier
            } else {
                assertionFailure(UTTypeError.expectedImport(identifier).localizedDescription)
                self.identifier = ""
            }
        } else {
            assertionFailure(UTTypeError.importMissing(identifier).localizedDescription)
            self.identifier = ""
        }
    }
}

private enum UTTypeError: LocalizedError {
    case importMissing(String)
    case exportMissing(String)
    case expectedImport(String)
    case expectedExport(String)

    var errorDescription: String? {
        switch self {
        case let .importMissing(identifier):
            return "Type \"\(identifier)\" was expected to be declared and imported in Info.plist, but it was not found."
        case let .exportMissing(identifier):
            return "Type \"\(identifier)\" was expected to be declared and exported in Info.plist, but it was not found."
        case let .expectedImport(identifier):
            return "Type \"\(identifier)\" was expected to be imported in Info.plist, but it was exported instead."
        case let .expectedExport(identifier):
            return "Type \"\(identifier)\" was expected to be exported in Info.plist, but it was imported instead."
        }
    }
}
