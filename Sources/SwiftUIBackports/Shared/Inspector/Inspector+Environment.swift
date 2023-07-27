import SwiftUI

struct InspectorDimensionsEnvironmentKey: EnvironmentKey {
    static var defaultValue: (min: CGFloat?, ideal: CGFloat, max: CGFloat?) = (300, 300, 300)
}

internal extension EnvironmentValues {
    var inspectorDimensions: InspectorDimensionsEnvironmentKey.Value {
        get { self[InspectorDimensionsEnvironmentKey.self] }
        set { self[InspectorDimensionsEnvironmentKey.self] = newValue }
    }
}
