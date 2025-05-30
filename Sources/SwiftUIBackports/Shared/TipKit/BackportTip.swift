//
//  BackportTip.swift
//  SwiftUIBackports
//
//  Created by Cristopher Bautista on 5/27/25.
//

import Foundation
import SwiftUI

// MARK: - Public protocol (iOS 14+)

/// Independent counterpart to `TipKit.Tip`.
///
/// Conform to this protocol instead of `Tip`.
/// When the project is built for iOS 17+ the bridge extension at the end
/// exposes `asAnyTip`, so you can call TipKit modifiers/controls without
/// changing your code.
public protocol BackportTip: Identifiable, Hashable, Sendable {
    // MARK: Visual — independent of SwiftUI < 17
    var id: String { get }
    /// Tip title.
    var title: String { get }
    /// Additional message. *Optional*.
    var message: String? { get }
    /// Image name (SF Symbol or asset). *Optional*.
    var imageName: String? { get }
}

// MARK: — Default values provided

public extension BackportTip {
    var message: String? { nil }
    var imageName: String? { nil }
    // MARK: Rules and actions
    
    /// Rule set that controls when the tip should be shown.
    var rules: [BackportTipRule] { [] }
    /// Actions that the user can trigger.
    var actions: [Backport<Any>.TipAction] { [] }
}

public extension BackportTip {
    /// Invalidates the tip (it will no longer be shown).
    func invalidate(reason: Backport<Any>.Tips.InvalidationReason = .tipClosed) {
        Backport.Tips.invalidate(self, reason: reason)
    }
    
    var shouldDisplay: Bool {
        Backport.Tips.shouldDisplay(self)
    }
}

// MARK: - Tip Actions

public protocol BackportTipAction: Identifiable, Hashable, Sendable {
    var id: String { get }
    var index: Int? { get }
    var handler: @Sendable () -> Void { get }
    var label: @Sendable () -> Text { get }
}

public extension BackportTipAction {
    // MARK: Equatable
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.index == rhs.index
    }
    
    // MARK: Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(index)
    }
}

public extension Backport where Wrapped == Any {
    private struct TipState: Codable, Hashable {
        var displayCount: Int = 0
        var invalidated: Bool = false
    }
    
    public enum Tips {
        
        public enum ConfigurationOption: Equatable {
            case datastoreLocation(_ storeLocation: DatastoreLocation)
            case displayFrequency(_ displayFrequency: DisplayFrequency)
            
            public enum DisplayFrequency: Equatable {
                case immediate
                case hourly
                case daily
                case weekly
                case monthly
            }
            
            public enum DatastoreLocation: Equatable {
                case applicationDefault
                case groupContainer(identifier: String)
                case url(_ url: URL)
            }
        }
        
        public enum InvalidationReason: Hashable, Sendable {
            case actionPerformed
            case displayCountExceeded
            case displayDurationExceeded
            case tipClosed
        }
        
        // MARK: – Internal storage -----------------------------------------
        
        private static let storeKey = "BackportTipStore"
        private static var datastore: [String: TipState] = [:]
        private static var didConfigure = false
        #if DEBUG
        public static var forceBackportTip = false // Debug purpose
        #else
        static let forceBackportTip = false
        #endif
        
        /// Configures TipKit if available; otherwise does nothing.
        /// Call once, e.g. inside `.task` in your root view.
        public static func configure(_ configuration: [ConfigurationOption] = []) throws {
            if forceBackportTip == false,
               #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                guard !didConfigure else { return }
                do {
                    try TipKit.Tips.configure(configuration.toTipKit())
                    didConfigure = true
                } catch {
                    debugPrint("TipKit configure error:", error)
                }
            } else if datastore == nil {
                try loadStore()
            }
        }
        
        /// Clears all persisted tip information.
        public static func resetDatastore() throws {
            // Native TipKit if exists
            if forceBackportTip == false,
               #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                do {
                    try TipKit.Tips.resetDatastore()
                } catch let error as TipKitError where error == .tipsDatastoreAlreadyConfigured {
                    // already configured—no action needed
                  } catch {
                    // some other failure: log or rethrow
                    print("Unexpected TipKit.configure error:", error)
                    throw error
                }
            } else {
                // Debug helper to clear UserDefaults.
                UserDefaults.standard.removeObject(forKey: storeKey)
                datastore = [:]
            }
        }
        
        /// Records an invalidation for the given tip.
        static func invalidate<T: BackportTip>(
            _ tip: T,
            reason: Backport<Any>.Tips.InvalidationReason
        ) {
            // Real TipKit (iOS 17+ only)
            if forceBackportTip == false,
               #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                tip.asAnyTip.invalidate(reason: reason.toTipKit)
            } else {
                // Minimal custom persistence (UserDefaults)
                var s = datastore[tip.id] ?? .init()
                s.invalidated = true
                datastore[tip.id] = s
                saveStore()
            }
        }
        
        // MARK: – Public API ------------------------------------------------
        
        /// Evaluates rules to decide whether the tip should show.
        public static func shouldDisplay<T: BackportTip>(_ tip: T) -> Bool {
            // Manual rule — developer decides when to show
            if tip.rules.contains(.manual) { return false }
            if datastore.isEmpty {
                try? loadStore()
            }
            let state = datastore[tip.id] ?? .init()
            // Max-display
            let max = tip.rules.firstMaxDisplayCount
            if let max, state.displayCount >= max { return false }
            
            // whenUserDefaultEquals
            for rule in tip.rules {
                if case let .whenUserDefaultEquals(key, expected) = rule {
                    guard let value = UserDefaults.standard.value(forKey: key) as? AnyHashable,
                          value == expected else { return false }
                }
            }
            return !state.invalidated
        }
        
        /// Call on appear once the tip is actually displayed.
        public static func recordDisplay<T: BackportTip>(_ tip: T) {
            var s = datastore[tip.id] ?? .init()
            s.displayCount += 1
            datastore[tip.id] = s
            saveStore()
        }
        
        private static func loadStore() throws {
            if let data = UserDefaults.standard.data(forKey: storeKey) {
                datastore = try JSONDecoder().decode([String: TipState].self, from: data)
            } else {
                datastore = [:]
            }
        }
        
        private static func saveStore() {
            if let data = try? JSONEncoder().encode(datastore) {
                UserDefaults.standard.set(data, forKey: storeKey)
            }
        }
    }
    
    /// Represents a button inside the tip.
    public struct TipAction: BackportTipAction {
        // Public properties
        public let id: String
        public let index: Int?
        public let handler: @Sendable () -> Void
        public let label: @Sendable () -> Text
        
        /// Initializer
        public init(
            id: String = UUID().uuidString,
            index: Int? = nil,
            handler: @Sendable @escaping () -> Void = {},
            label: @escaping @Sendable () -> Text
        ) {
            self.id = id
            self.index = index
            self.handler = handler
            self.label = label
        }
        
        // MARK: Hashable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(index)
        }
    }
}

// MARK: - Tip Rules (TipKit subset)

/// Basic presentation rules (you can extend them as needed).
public enum BackportTipRule: Hashable, Sendable {
    /// Shown at most *n* times.
    case maxDisplayCount(Int)
    /// Shown only when `UserDefaults[key] == value`.
    case whenUserDefaultEquals(key: String, value: AnyHashable)
    /// Manual mode; never shown automatically.
    case manual
}

// MARK: - Bridge with TipKit (compiles only on iOS 17+)

#if canImport(TipKit)
import TipKit

@available(macOS 14.0, iOS 17.0, tvOS 17.1, visionOS 1.0, *)
@available(watchOS, unavailable)
public extension BackportTip {
    
    /// Converts the back-port tip into a real `AnyTip`.
    var asAnyTip: AnyTip {
        AnyTip(BackportTipWrapper(base: self))
    }
}

@available(macOS 15.4, iOS 18.4, tvOS 18.4, visionOS 2.4, *)
public extension BackportTip {
    
    /// Converts the back-port tip into a real `AnyTip`.
    var asTip: Tip {
        BackportTipWrapper(base: self)
    }
}

@available(iOS 17.0, *)
extension TipKit.AnyTip: Equatable {
    public static func == (lhs: AnyTip, rhs: AnyTip) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.message == rhs.message &&
        lhs.image == rhs.image
    }
}

/// Private implementation that adapts any `BackportTip` to the `TipKit.Tip` protocol.
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
fileprivate struct BackportTipWrapper: Tip {
    let base: any BackportTip
    
    // MARK: Tip conformance
    var id: String { String(describing: base.id) }
    
    var title: Text { Text(base.title) }
    var message: Text? { base.message.map(Text.init) }
    var image: Image? { base.imageName.map(Image.init(systemName:)) }
    
    // Note: TipKit still doesn’t expose actions or rules for dynamic construction.
}

@available(iOS 17.0, *)
extension Tips.Action: BackportTipAction {}
#endif

extension Notification.Name {
    static let backportTipDidClose = Notification.Name("BackportTipDidClose")
}

#if canImport(TipKit)
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
private extension Backport<Any>.Tips.InvalidationReason {
    var toTipKit: Tips.InvalidationReason {
        switch self {
            case .tipClosed:
                return .tipClosed
            case .actionPerformed:
                return .actionPerformed
            case .displayCountExceeded:
                return .displayCountExceeded
            case .displayDurationExceeded:
                if #available(iOS 18.0, *) {
                    return .displayDurationExceeded
                } else {
                    return .displayCountExceeded
                }
        }
    }
}
#endif

private extension Array where Element == BackportTipRule {
    var firstMaxDisplayCount: Int? {
        first { if case let .maxDisplayCount(n) = $0 { return true }; return false }
            .flatMap {
                if case let .maxDisplayCount(n) = $0 { return n }
                return nil
            }
    }
}
@available(iOS 17.0, *)
private extension Array where Element == Backport<Any>.Tips.ConfigurationOption {
    func toTipKit() throws -> [TipKit.Tips.ConfigurationOption] {
        try self.map{ try $0.toTipKit()}
    }
}

@available(iOS 17.0, *)
extension Backport<Any>.Tips.ConfigurationOption {
    func toTipKit()throws -> TipKit.Tips.ConfigurationOption {
        switch self {
            case .displayFrequency(let frequency):
                return .displayFrequency(frequency.toTipKit)
            case .datastoreLocation(let storeLocation):
                return try .datastoreLocation(storeLocation.toTipKit())
        }
    }
}
@available(iOS 17.0, *)
extension Backport<Any>.Tips.ConfigurationOption.DisplayFrequency {
    var toTipKit: TipKit.Tips.ConfigurationOption.DisplayFrequency {
        switch self {
            case .immediate:
                return .immediate
            case .hourly:
                return .hourly
            case .daily:
                return .daily
            case .weekly:
                return .weekly
            case .monthly:
                return .monthly
        }
    }
}

@available(iOS 17.0, *)
extension Backport<Any>.Tips.ConfigurationOption.DatastoreLocation {
    func toTipKit() throws -> TipKit.Tips.ConfigurationOption.DatastoreLocation {
        switch self {
            case .applicationDefault:
                return .applicationDefault
            case .groupContainer(let identifier):
                return try .groupContainer(identifier: identifier)
            case .url(let url):
                return .url(url)
        }
    }
}

