//import Foundation
//
//public protocol _Transferable {
//    associatedtype Representation: _TransferRepresentation
//    @_TransferRepresentationBuilder<Self> static var transferRepresentation: Representation { get }
//}
//
//public protocol _TransferRepresentation: Sendable {
//    associatedtype Item: _Transferable
//    associatedtype Body: _TransferRepresentation
//    @_TransferRepresentationBuilder<Item> var body: Body { get  }
//}
//
//@resultBuilder
//public struct _TransferRepresentationBuilder<Item> where Item: _Transferable {
//    public static func buildBlock<Content>(_ content: Content) -> Content where Item == Content.Item, Content: _TransferRepresentation {
//        content
//    }
//}
//
//public struct _DataRepresentation<Item>: _TransferRepresentation where Item: _Transferable {
//    public var body: some _TransferRepresentation {
//        fatalError()
//    }
//
//    public init(contentType: String, exporting: @escaping @Sendable (Item) async throws -> Data, importing: @escaping @Sendable (Data) async throws -> Item) {
//
//    }
//
//    public init(exportedContentType: String, exporting: @escaping @Sendable (Item) async throws -> Data) {
//
//    }
//
//    public init(importingContentType: String, importing: @escaping @Sendable (Data) async throws -> Item) {
//
//    }
//}
//
//extension Data: Transferable, @unchecked Sendable {
//    public typealias Representation = Never
//    public static var transferRepresentation: Never {
//        fatalError()
//    }
//}
//
//extension Never: _TransferRepresentation {
//    public typealias Item = Never
//    public var body: Never {
//        fatalError()
//    }
//}
//
//extension Never: _Transferable {
//    public static var transferRepresentation: Never {
//        fatalError()
//    }
//}
//
//import SwiftUI
//import UniformTypeIdentifiers
//
//@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
//extension UIImage: Transferable {
//    public static var transferRepresentation: some TransferRepresentation {
//        DataRepresentation<UIImage>(exportedContentType: .jpeg) { image in
//            image.jpegData(compressionQuality: 1) ?? .init()
//        }
//    }
//}
//
//struct ImageDocumentLayer {
//    init(data: Data) { }
//    func data() -> Data { fatalError() }
//    func pngData() -> Data { fatalError() }
//}
//
//@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
//extension UTType {
//    static var layer: UTType { UTType(exportedAs: "com.example.layer") }
//}
//
//@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
//extension ImageDocumentLayer: Transferable {
//    static var transferRepresentation: some TransferRepresentation {
//        DataRepresentation(exportedContentType: .png) { layer in
//            layer.pngData()
//        }
//    }
//}
