import SwiftUI
import CoreServices
import SwiftBackports

public extension NSItemProvider {
    func loadObject<T>(of type: T.Type) async throws -> T where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSItemProviderReading {
        try await withCheckedThrowingContinuation { continuation in
            _ = loadObject(ofClass: T.self) { (value: _ObjectiveCBridgeable?, error: Error?) in
                switch (value, error) {
                case let (.some(value as T), nil):
                    continuation.resume(returning: value)
                case let (_, .some(error)):
                    continuation.resume(throwing: error)
                    return
                default:
                    return
                }
            }
        }
    }
}

extension NSData: NSItemProviderReading {
    public static var readableTypeIdentifiersForItemProvider: [String] { [String(kUTTypeData)] }
    public static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self { NSData(data: data) as! Self }
}
