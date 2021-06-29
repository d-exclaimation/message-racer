//
//  LobbyView.swift
//  MessageRacer
//
//  Created by Vincent on 6/29/21.
//

import SwiftUI

public struct LobbyView: View {
    @EnvironmentObject var user: User
    
    let color: Color
    let navigate: (MainRoute) -> Void
    
    private let mockRooms: [Room] = Array(0...100)
        .map { Room(id: UUID(), playerCount: $0) }
    
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .ignoresSafeArea(.all)
            
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
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        navigate(.main)
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward.fill")
                            .padding(15)
                            .foregroundColor(foreground)
                            .background(
                                Circle()
                                    .foregroundColor(.black)
                            )
                            .padding(5)
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
    
    private let foreground: Color = .white
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView(color: .black, navigate: { _ in print("a") }).environmentObject(User())
    }
}
