//
//  Index.swift
//  MessageRacer
//
//  Created by Vincent on 6/18/21.
//

import Foundation
import SwiftUI

public struct MainView: View {
    @EnvironmentObject var user: User
    
    let color: Color
    let text: String
    let onPress: () -> Void
    
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .ignoresSafeArea(.all)
            
            VStack {
                Button(action: onPress) {
                    Text(text)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct MainView_Preview: PreviewProvider {
    static var previews: some View {
        MainView(color: .red, text: "Hello World", onPress: { print("a") }).environmentObject(User())
    }
}
