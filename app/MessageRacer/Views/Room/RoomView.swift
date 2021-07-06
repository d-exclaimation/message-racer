//
//  RoomView.swift
//  MessageRacer
//
//  Created by Vincent on 6/19/21.
//

import Foundation
import SwiftUI


public struct RoomView: View {
    @Environment(\.colorScheme) var scheme: ColorScheme
    @EnvironmentObject var user: User
    
    let color: Color = Color(UIColor.mediumPurple)
    let uuid: UUID
    let navigate: (MainRoute) -> Void
    
    // Player state
    @State
    var input: String = ""
    @State
    var playerPos: Int = 0
    @State
    var messages: [TextMessage] = []
 
    
    // Behind the scene state
    @State
    var lobby: [String: Int] = [:]
    @State
    var wpm: Double = 0
    @State
    var timestamp: Date = Date()
    
    @State
    var winner: String? = nil
   
    @StateObject
    var gameCycle: Orfeus.StreamAgent<GameRoomSubscription, GameRoomSubscription.Data?>

    @StateObject
    var deltaAgent = Orfeus.agent(mutation: SendDeltaMutation.self)
    
    var endTitle: String {
        if let winner = winner {
            return "Sadly, \(winner) won! You are texting on \(Int(wpm)) wpm"
        }
        if playerPos == messages.count {
            return "Well done \(user.username)! \(Int(wpm)) wpm"
        }
        return "\(user.username)'s end of the line ..."
    }

    
    init(uuid id: UUID, navigate fn: @escaping (MainRoute) -> Void) {
        uuid = id
        navigate = fn
        _gameCycle = Orfeus.wrapped(
            stream: GameRoomSubscription(id: id.id),
            initial: nil,
            reducer: { _, curr in curr }
        )
    }
    
    public var body: some View {
        ZStack {
            background
            
            VStack {
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        // Text messages
                        ForEach(messages) { message in
                            ChatMessage(
                                content: message.message,
                                date: Date(),
                                isUser: message.owner == user.username,
                                user: message.owner,
                                fontColor: message.id < playerPos ? Color.blue : nil
                            )
                                .flippedUpsideDown()
                                .padding(.vertical, 10)
                                .id(message.id)
                        }
                        
                        // End of text message
                        Text(endTitle)
                            .fontWeight(.thin)
                            .padding()
                            .flippedUpsideDown()
                            .id(messages.count)
                    }
                    .flippedUpsideDown()
                    .padding()
                    
                    // Text Input
                    VStack {
                        HStack {
                            TextField("Start typing...", text: $input, onCommit:  {
                                onSubmission(val: input, proxy: scrollProxy)
                            })
                                .onChange(of: input) { val in
                                    if let last = val.last, last == " " {
                                        onSubmission(val: val, proxy: scrollProxy)
                                    }
                                }
                            
                            Button {
                                onSubmission(val: input, proxy: scrollProxy)
                            } label: {
                                Text("🕊")
                            }
                        }
                    }
                    .padding()
                    .background(scheme == .dark ? Color.black : Color.white)
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
        .onDataChange(agent: gameCycle) { data in
            guard winner == nil else { return }
            guard let data = data else { return }
            
            // Choose appropriate functions
            switch data.gameCycle.union {
            case .none: return
            case .start(let room, let words): return onStart(room: room, words: words)
            case .end(let winner): return onEnd(winner: winner)
            case .delta(let username, let index, _): return onDelta(username: username, index: index)
            }
        }
        .alert(item: $winner) { winner in
            Alert(
                title: Text("\(winner)"),
                message: Text(endTitle),
                dismissButton: .destructive(Text("leave")) { navigate(.main) }
            )
        }
    }
    
    private var background: some View {
        Rectangle()
            .foregroundColor(color)
            .ignoresSafeArea(.all)
    }
    
    private func onSubmission(val: String, proxy: ScrollViewProxy) -> Void {
        guard winner == nil else { return }
        guard playerPos < messages.count else { return }
        guard val.trimmingCharacters(in: .whitespacesAndNewlines) == messages[playerPos].message.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        deltaAgent.mutate(
            variables: SendDeltaMutation(
                id: uuid.id, username: user.username, index: playerPos, word: val.trimmingCharacters(in: .whitespacesAndNewlines)
            ),
            onCompleted: { _ in }
        )
        
        withAnimation {
            input = ""
            playerPos += 1
            proxy.scrollTo(playerPos, anchor: .top)
        }
        
    }
    
    func messageColor(message: TextMessage) -> Color? {
        if message.id < playerPos { return .green }
        let maxOthers = lobby.values.max() ?? 0
        if message.id < maxOthers  {
            let diff = maxOthers - message.id
            if diff > 5 {
                return .red
            }
            
            if diff > 2 {
                return .orange
            }
            return .yellow
        }
        return nil
    }
    
    // On Start event
    private typealias Start = GameRoomSubscription.Data.GameCycle.AsStartEvent
    private func onStart(room: Start.Room, words: [String]) {
        guard lobby.isEmpty else { return }
        timestamp = Date()
        lobby = Dictionary(uniqueKeysWithValues:
            room.players
                .filter { $0.username != user.username }
                .map { ($0.username, 0) }
        )
        messages = words
            .enumerated()
            .map { ($0, $1, Int.random(in: 0..<room.players.count)) }
            .map { (i, word, j) in (i, word, room.players[j].username) }
            .map { TextMessage(id: $0, message: $1, owner: $2) }
    }
    
    // On Delta event
    private func onDelta(username: String, index: Int) {
        guard let _ = lobby[username] else { return }
        guard username == user.username else { return }
        lobby.updateValue(index, forKey: username)
    }
    
    private func onEnd(winner player: String) {
        winner = player
        let end = Date()
        let wordCount = Double(messages.flatMap {
            $0.message.split(separator: " ")
        }.count)
        wpm = wordCount / timestamp.distance(to: end) * 60.0
    }
}

extension String: Identifiable {
    public var id: String {
        self
    }
}


struct RoomView_Preview: PreviewProvider {
    static var previews: some View {
        RoomView(uuid: UUID()) { _ in }
            .environmentObject(User())
    }
}
