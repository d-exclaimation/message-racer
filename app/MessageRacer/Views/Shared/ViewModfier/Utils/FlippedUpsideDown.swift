//
//  FlippedUpsideDown.swift
//  ClusterChat
//
//  Created by Vincent on 10/10/20.
//

import Foundation
import SwiftUI

public struct FlippedUpsideDown: ViewModifier {
   public func body(content: Content) -> some View {
    content
        .rotationEffect(Angle(degrees: 180))
        .scaleEffect(x: -1, y: 1, anchor: .center)
   }
}
extension View{
   public func flippedUpsideDown() -> some View{
     self.modifier(FlippedUpsideDown())
   }
}
