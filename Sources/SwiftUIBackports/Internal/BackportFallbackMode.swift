import SwiftUI
import SwiftBackports

internal enum BackportFallbackMode {
	case auto // automatically fallback to native SwiftUI SDK
	case disable // disable fallback to native SwiftUI SDK

	var allowFallback: Bool {
		switch self {
			case .auto:
				return true
			case .disable:
				return false
		}
	}
}

private struct EnforceBackportEnvironmentKey: EnvironmentKey {
	static var defaultValue: BackportFallbackMode = .auto
}

internal extension EnvironmentValues {
	/// Controls how backported SwiftUI APIs behave within this view hierarchy.
	///
	/// This environment value determines whether compatible, native SwiftUI
	/// implementations provided by the running OS should be used automatically,
	/// or whether the backported implementations should be preferred exclusively.
	///
	/// Behavior:
	/// - `.auto` (default): When the current OS version provides a native SwiftUI
	///   API compatible with the backported functionality, the native API is used.
	///   Otherwise, the backported implementation is used.
	/// - `.disable`: Native SwiftUI fallbacks are not used, even if available.
	///   The backported implementation remains active.
	///
	/// Use this setting to ensure consistent behavior across OS versions or to
	/// explicitly validate and compare backported behavior against native APIs.
	///
	/// Example:
	/// ```swift
	/// struct RootView: View {
	///     var body: some View {
	///         ContentView()
	///             .environment(\.backportFallbackMode, .auto)     // Prefer native when available
	///         //  .environment(\.backportFallbackMode, .disable)  // Force backports only
	///     }
	/// }
	/// ```
	var backportFallbackMode: BackportFallbackMode {
		get { self[EnforceBackportEnvironmentKey.self] }
		set { self[EnforceBackportEnvironmentKey.self] = newValue }
	}
}

internal extension View {
	/// Sets the backport fallback behavior for this view hierarchy.
	///
	/// Use this modifier to control whether backported SwiftUI APIs should
	/// automatically fall back to the native SwiftUI implementations provided
	/// by the running OS, or remain disabled and use only the backported
	/// implementations.
	///
	/// - Parameter mode: The desired fallback mode:
	///   - `.auto`: Prefer the built-in SwiftUI API when available on the
	///     current platform version, and use the backport otherwise.
	///   - `.disable`: Do not fall back to the built-in SwiftUI API; always
	///     use the backported implementation where applicable.
	///
	/// - Returns: A view that applies the specified backport fallback mode to
	///   itself and its descendants via the environment.
	///
	/// - Note: This setting is propagated through the environment using
	///   `EnvironmentValues.backportFallbackMode`. Apply this modifier near the
	///   root of a view subtree to ensure consistent behavior throughout that
	///   subtree.
	///
	/// - SeeAlso: `EnvironmentValues.backportFallbackMode`, `BackportFallbackMode`
	func backportFallbackMode(_ mode: BackportFallbackMode) -> some View {
		environment(\.backportFallbackMode, mode)
	}
}
