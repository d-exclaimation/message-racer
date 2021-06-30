//
//  LobbyView.swift
//  MessageRacer
//
//  Created by Vincent on 6/29/21.
//

import SwiftUI

public struct LobbyView: View {
    let color: Color
    let navigate: (MainRoute) -> Void
    
    // TODO: - Update to fetch from API
    private let mockRooms: [Room] = Array(0...100)
        .map { _ in Room(id: UUID(), playerCount: Int.random(in: 0...4)) }
    
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .ignoresSafeArea(.all)
            
            // All the Rooms available
            ScrollView {
                LazyVStack {
                    ForEach(mockRooms) { room in
                        Button {
                            navigate(.room(id: room.id))
                        } label: {
                            RoomPreview(room: room)
                        }
                    }
                }
            }
            .padding(.top, 15)
        }
    }
    
    private let foreground: Color = .white
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView(color: .black, navigate: { _ in print("a") })
    }
}
