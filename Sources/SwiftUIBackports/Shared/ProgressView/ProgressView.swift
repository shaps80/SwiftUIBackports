import SwiftUI

@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, deprecated: 14.0)
@available(watchOS, deprecated: 7.0)
public extension Backport where Content == Any {
    struct ProgressView<Label: View, CurrentValueLabel: View>: View {
        @Environment(\.backportProgressViewStyle) private var style
        let config: Backport<Any>.ProgressViewStyleConfiguration

        public var body: some View {
            Group {
                if let style = style {
                    style.makeBody(configuration: config)
                } else {
                    DefaultProgressViewStyle().makeBody(configuration: config)
                }
            }
        }
    }
}

@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, deprecated: 14.0)
@available(watchOS, unavailable)
public extension Backport.ProgressView where Content == Any, CurrentValueLabel == EmptyView {
    /// Creates a progress view for showing indeterminate progress, without a
    /// label.
    init() where Label == EmptyView {
        self.init(config: .init(fractionCompleted: nil, preferredKind: .circular))
    }

    /// Creates a progress view for showing indeterminate progress that displays
    /// a custom label.
    ///
    /// - Parameters:
    ///     - label: A view builder that creates a view that describes the task
    ///       in progress.
    init(@ViewBuilder label: () -> Label) {
        config = .init(fractionCompleted: nil, label: .init(content: label()), preferredKind: .circular)
    }

    /// Creates a progress view for showing indeterminate progress that
    /// generates its label from a localized string.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings. To initialize a
    /// indeterminate progress view with a string variable, use
    /// the corresponding initializer that takes a `StringProtocol` instance.
    ///
    /// - Parameters:
    ///     - titleKey: The key for the progress view's localized title that
    ///       describes the task in progress.
    init(_ titleKey: LocalizedStringKey) where Label == Text {
        config = .init(fractionCompleted: nil, label: .init(content: Text(titleKey)), preferredKind: .circular)
    }

    /// Creates a progress view for showing indeterminate progress that
    /// generates its label from a string.
    ///
    /// - Parameters:
    ///     - title: A string that describes the task in progress.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(verbatim:)``. See ``Text`` for more
    /// information about localizing strings. To initialize a progress view with
    /// a localized string key, use the corresponding initializer that takes a
    /// `LocalizedStringKey` instance.
    init<S>(_ title: S) where Label == Text, S: StringProtocol {
        config = .init(fractionCompleted: nil, label: .init(content: Text(title)), preferredKind: .circular)
    }
}

@available(iOS, deprecated: 14)
@available(macOS, deprecated: 11)
@available(tvOS, deprecated: 14.0)
@available(watchOS, deprecated: 7.0)
extension Backport.ProgressView where Content == Any {

    /// Creates a progress view for showing determinate progress.
    ///
    /// If the value is non-`nil`, but outside the range of `0.0` through
    /// `total`, the progress view pins the value to those limits, rounding to
    /// the nearest possible bound. A value of `nil` represents indeterminate
    /// progress, in which case the progress view ignores `total`.
    ///
    /// - Parameters:
    ///     - value: The completed amount of the task to this point, in a range
    ///       of `0.0` to `total`, or `nil` if the progress is indeterminate.
    ///     - total: The full amount representing the complete scope of the
    ///       task, meaning the task is complete if `value` equals `total`. The
    ///       default value is `1.0`.
    public init<V>(value: V?, total: V = 1.0) where Label == EmptyView, CurrentValueLabel == EmptyView, V: BinaryFloatingPoint {
        if let value = value {
            config = .init(fractionCompleted: Double(value) / Double(total), preferredKind: .linear, max: Double(total))
        } else {
            config = .init(fractionCompleted: nil, preferredKind: .linear)
        }
    }

    /// Creates a progress view for showing determinate progress, with a
    /// custom label.
    ///
    /// If the value is non-`nil`, but outside the range of `0.0` through
    /// `total`, the progress view pins the value to those limits, rounding to
    /// the nearest possible bound. A value of `nil` represents indeterminate
    /// progress, in which case the progress view ignores `total`.
    ///
    /// - Parameters:
    ///     - value: The completed amount of the task to this point, in a range
    ///       of `0.0` to `total`, or `nil` if the progress is indeterminate.
    ///     - total: The full amount representing the complete scope of the
    ///       task, meaning the task is complete if `value` equals `total`. The
    ///       default value is `1.0`.
    ///     - label: A view builder that creates a view that describes the task
    ///       in progress.
    public init<V>(value: V?, total: V = 1.0, @ViewBuilder label: () -> Label) where CurrentValueLabel == EmptyView, V: BinaryFloatingPoint {
        if let value = value {
            config = .init(fractionCompleted: Double(value) / Double(total), label: .init(content: label()), preferredKind: .linear)
        } else {
            config = .init(fractionCompleted: nil, label: .init(content: label()), preferredKind: .linear, max: Double(total))
        }
    }

    /// Creates a progress view for showing determinate progress, with a
    /// custom label.
    ///
    /// If the value is non-`nil`, but outside the range of `0.0` through
    /// `total`, the progress view pins the value to those limits, rounding to
    /// the nearest possible bound. A value of `nil` represents indeterminate
    /// progress, in which case the progress view ignores `total`.
    ///
    /// - Parameters:
    ///     - value: The completed amount of the task to this point, in a range
    ///       of `0.0` to `total`, or `nil` if the progress is indeterminate.
    ///     - total: The full amount representing the complete scope of the
    ///       task, meaning the task is complete if `value` equals `total`. The
    ///       default value is `1.0`.
    ///     - label: A view builder that creates a view that describes the task
    ///       in progress.
    ///     - currentValueLabel: A view builder that creates a view that
    ///       describes the level of completed progress of the task.
    public init<V>(value: V?, total: V = 1.0, @ViewBuilder label: () -> Label, @ViewBuilder currentValueLabel: () -> CurrentValueLabel) where V: BinaryFloatingPoint {
        if let value = value {
            config = .init(fractionCompleted: Double(value) / Double(total), label: .init(content: label()), currentValueLabel: .init(content: currentValueLabel()), preferredKind: .linear, max: Double(total))
        } else {
            config = .init(fractionCompleted: nil, label: .init(content: label()), currentValueLabel: .init(content: currentValueLabel()), preferredKind: .linear, max: Double(total))
        }
    }

    /// Creates a progress view for showing determinate progress that generates
    /// its label from a localized string.
    ///
    /// If the value is non-`nil`, but outside the range of `0.0` through
    /// `total`, the progress view pins the value to those limits, rounding to
    /// the nearest possible bound. A value of `nil` represents indeterminate
    /// progress, in which case the progress view ignores `total`.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings. To initialize a
    ///  determinate progress view with a string variable, use
    ///  the corresponding initializer that takes a `StringProtocol` instance.
    ///
    /// - Parameters:
    ///     - titleKey: The key for the progress view's localized title that
    ///       describes the task in progress.
    ///     - value: The completed amount of the task to this point, in a range
    ///       of `0.0` to `total`, or `nil` if the progress is
    ///       indeterminate.
    ///     - total: The full amount representing the complete scope of the
    ///       task, meaning the task is complete if `value` equals `total`. The
    ///       default value is `1.0`.
    public init<V>(_ titleKey: LocalizedStringKey, value: V?, total: V = 1.0) where Label == Text, CurrentValueLabel == EmptyView, V: BinaryFloatingPoint {
        if let value = value {
            config = .init(fractionCompleted: Double(value) / Double(total), label: .init(content: Text(titleKey)), preferredKind: .linear, max: Double(total))
        } else {
            config = .init(fractionCompleted: nil, label: .init(content: Text(titleKey)), preferredKind: .linear, max: Double(total))
        }
    }

    /// Creates a progress view for showing determinate progress that generates
    /// its label from a string.
    ///
    /// If the value is non-`nil`, but outside the range of `0.0` through
    /// `total`, the progress view pins the value to those limits, rounding to
    /// the nearest possible bound. A value of `nil` represents indeterminate
    /// progress, in which case the progress view ignores `total`.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(verbatim:)``. See ``Text`` for more
    /// information about localizing strings. To initialize a determinate
    /// progress view with a localized string key, use the corresponding
    /// initializer that takes a `LocalizedStringKey` instance.
    ///
    /// - Parameters:
    ///     - title: The string that describes the task in progress.
    ///     - value: The completed amount of the task to this point, in a range
    ///       of `0.0` to `total`, or `nil` if the progress is
    ///       indeterminate.
    ///     - total: The full amount representing the complete scope of the
    ///       task, meaning the task is complete if `value` equals `total`. The
    ///       default value is `1.0`.
    public init<S, V>(_ title: S, value: V?, total: V = 1.0) where Label == Text, CurrentValueLabel == EmptyView, S: StringProtocol, V: BinaryFloatingPoint {
        if let value = value {
            config = .init(fractionCompleted: Double(value) / Double(total), label: .init(content: Text(title)), preferredKind: .linear, max: Double(total))
        } else {
            config = .init(fractionCompleted: nil, label: .init(content: Text(title)), preferredKind: .linear, max: Double(total))
        }
    }
}
