//
//  RoomView.swift
//  MessageRacer
//
//  Created by Vincent on 6/19/21.
//

import Foundation
import SwiftUI


public struct RoomView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @EnvironmentObject var user: User
    
    let color: Color = Color(UIColor.mediumPurple)
    let uuid: UUID
    let navigate: (MainRoute) -> Void
    let timestamp: Date = Date()
    let textMessage: [(String, Bool)] = [
        "a",
        "a",
        "a",
        "a",
        "a",
        "a",
        "a",
        "a",
        "a",
        "a",
        "a",
        "a",
        "a",
        "a",
        "a",
        "a",
    ]
        .map { ($0.uppercased(), Int.random(in: 0...2) != 1)  }
        .reversed()
    
    @State
    var input: String = ""
    @State
    var playerPos: Int = 0
    @State
    var wpm: Double = 0
    
    @StateObject
    var gameCycle: Orfeus.StreamAgent<GameRoomSubscription, GameRoomSubscription.Data?>
    
    init(uuid id: UUID, navigate fn: @escaping (MainRoute) -> Void) {
        uuid = id
        navigate = fn
        _gameCycle = StateObject(wrappedValue: Orfeus.agent(
            stream: GameRoomSubscription(id: id.id),
            initial: nil,
            reducer: { _, curr in curr },
            pause: false
        ))
    }
    
    public var body: some View {
        ZStack {
            background
            
            VStack {
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        // Text messages
                        ForEach(textMessage.indices) { i in
                            ChatMessage(content: textMessage[i].0, date: Date(), isUser: textMessage[i].1, user: textMessage[i].1 ? "user" : "friend", fontColor: i < playerPos ? Color.blue : nil)
                                .flippedUpsideDown()
                                .padding(.vertical, 10)
                                .id(i)
                        }
                        
                        // End of text message
                        Text(playerPos == textMessage.count ? "Well done \(user.username)! \(Int(wpm)) wpm" : "\(user.username)'s end of the line ...")
                            .fontWeight(.thin)
                            .padding()
                            .flippedUpsideDown()
                            .id(textMessage.count)
                    }
                    .flippedUpsideDown()
                    .padding()
                    
                    // Text Input
                    VStack {
                        TextField("Start typing...", text: $input, onCommit:  {
                            onSubmission(val: input, proxy: scrollProxy)
                        })
                            .onChange(of: input) { val in
                                if let last = val.last, last == " " {
                                    onSubmission(val: val, proxy: scrollProxy)
                                }
                            }
                    }
                    .padding()
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .cornerRadius(10)
                    .padding()
                    
                }
            }
        }
        .onAppear {
            if !user.isLoggedIn {
                navigate(.main)
            }
        }
        .onStream(agent: gameCycle) { data in
            // TODO: Play the game
            print(data ?? "called")
        }
    }
    
    private var background: some View {
        Rectangle()
            .foregroundColor(color)
            .ignoresSafeArea(.all)
    }
    
    private func onSubmission(val: String, proxy: ScrollViewProxy) -> Void {
        guard playerPos < textMessage.count else {
            return
        }
        
        guard val.trimmingCharacters(in: .whitespacesAndNewlines) == textMessage[playerPos].0 else {
            return
        }
        
        withAnimation {
            input = ""
            playerPos += 1
            proxy.scrollTo(playerPos, anchor: .top)
        }
        
        if (playerPos == textMessage.count) {
            let end = Date()
            let wordCount = Double(textMessage.flatMap { (content, _) in
                content.split(separator: " ")
            }.count)
            wpm = wordCount / timestamp.distance(to: end) * 60.0
        }
    }
}


struct RoomView_Preview: PreviewProvider {
    static var previews: some View {
        RoomView(uuid: UUID()) { _ in }
            .environmentObject(User())
    }
}
