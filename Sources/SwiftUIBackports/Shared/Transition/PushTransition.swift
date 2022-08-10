//
//  File.swift
//  
//
//  Created by Andrey Plotnikov on 10.08.2022.
//

import SwiftUI

extension AnyTransition {
    
    /// Creates a transition that when added to a view will animate the view’s insertion by moving it in from the specified edge while fading it in, and animate its removal by moving it out towards the opposite edge and fading it out.
    /// - Parameter edge: the edge from which the view will be animated in.
    /// - Returns: A transition that animates a view by moving and fading it.
    @available(iOS, deprecated: 16.0)
    @available(watchOS, deprecated: 9.0)
    @available(macOS, deprecated: 13.0)
    @available(tvOS, deprecated: 16.0)
    @available(macCatalyst, deprecated: 16.0)
    static func push(from edge: Edge) -> AnyTransition {
        
        var oppositeEdge: Edge
        switch edge {
        case .top:
            oppositeEdge = .bottom
        case .leading:
            oppositeEdge = .trailing
        case .bottom:
            oppositeEdge = .top
        case .trailing:
            oppositeEdge = .leading
        }
        
        return .asymmetric(insertion: .move(edge: edge), removal: .move(edge: oppositeEdge)).combined(with: .opacity)
    }
}
