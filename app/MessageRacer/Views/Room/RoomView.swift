//
//  RoomView.swift
//  MessageRacer
//
//  Created by Vincent on 6/19/21.
//

import Foundation
import SwiftUI

public struct RoomView: View {
    // TODO: - Remove later
    @EnvironmentObject var user: User
    
    let color: Color
    let uuid: UUID
    let onPress: () -> Void
    
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .ignoresSafeArea(.all)
            
            VStack {
                ScrollView {
                    // TODO: - Uses actually text messages, also create model
                    ChatMessage(content: "Hi, how are you?", date: Date(), isUser: true, user: "peepee")
                    ChatMessage(content: "Hi, how are you?", date: Date(), isUser: false, user: "peepee")
                    ChatMessage(content: "Hi, how are you?", date: Date(), isUser: true, user: "peepee")
                    ChatMessage(content: "Hi, how are you?", date: Date(), isUser: false, user: "peepee")
                    ChatMessage(content: "Hi, how are you?", date: Date(), isUser: true, user: "peepee")
                    ChatMessage(content: "Hi, how are you?", date: Date(), isUser: false, user: "peepee")
                }
                .padding()
                
                Button(action: onPress) {
                    Text("\(uuid)")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct RoomView_Preview: PreviewProvider {
    static var previews: some View {
        RoomView(color: .init(UIColor.mediumPurple), uuid: UUID(), onPress: { print("a") }).environmentObject(User())
    }
}
