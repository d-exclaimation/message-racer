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
    let navigate: (MainRoute) -> Void
    
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .ignoresSafeArea(.all)
            
            VStack {
                Button {
                    navigate(.room(id: UUID()))
                } label: {
                    buttonLabel(text: "Join a room", iconName: "gamecontroller.fill")
                }
                Button {
                    navigate(.main)
                } label: {
                    buttonLabel(text: "Create a room")
                }
                Button {
                    navigate(.lobby)
                } label: {
                    buttonLabel(text: "Explore rooms", iconName: "house.circle.fill")
                }
            }
        }
    }
    
    private let fontColor: Color = Color(UIColor.mediumPurple)
    
    
    private func buttonLabel(text: String, iconName: String = "circle.grid.cross.fill") -> some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(fontColor)
            Text(text)
                .font(.headline)
                .foregroundColor(fontColor)
       }
        .frame(width: 300)
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
}

struct MainView_Preview: PreviewProvider {
    static var previews: some View {
        MainView(color: .purple, text: "Hello World", navigate: { _ in print("a") }).environmentObject(User())
    }
}
