//
//  BubbleCarded.swift
//  ClusterChat
//
//  Created by Vincent on 10/10/20.
//

import Foundation
import SwiftUI

public struct BubbleCarded: ViewModifier {
    
    var color: Color
    var width: CGFloat
    var height: CGFloat
    var radius: CGFloat
    var padding: CGFloat
    
    public init(color: Color, opacity: Double, type: TypeOfContent, size: CardSize, padding: CGFloat = 20) {
        // Initialize color
        self.color = color.opacity(opacity)
        
        // Initialize size
        var x: CGFloat = 0
        var y: CGFloat = 0
        var curve: CGFloat = 0
        var padding = padding
        
        switch type {
            case .single:
                y = 10
                x = 20
                break
            case .stack:
                y = 10
                x = 0
                break
        }
        
        switch size {
            case .small:
                curve = 10
                break
            case .medium:
                curve = 20
                y *= 2
                x *= 2
                break
            case .large:
                curve = 30
                y *= 3
                x *= 3
                break
            case .custom(let size, let pad):
                curve = (size.height + size.width)/2
                padding = pad
                y = size.height
                x = size.width
                break
        }
        
        width = x
        height = y
        radius = curve
        self.padding = padding
    }
    
    public func body(content: Content) -> some View {
        content
            .padding(.vertical, height)
            .padding(.horizontal, width)
            .background(color)
            .cornerRadius(radius)
            .padding(padding)
    }
    
    
    
}

extension View {
    public func bubbleCarded(using color: Color = .black,_ opacity: Double = 0.1, of type: TypeOfContent = .single, with size: CardSize = .medium) -> some View {
        self.modifier(BubbleCarded(color: color, opacity: opacity, type: type, size: size))
    }
}

public enum TypeOfContent {
    case single
    case stack
}

public enum CardSize {
    case small
    case medium
    case large
    case custom(size: CGSize, padding: CGFloat)
}
