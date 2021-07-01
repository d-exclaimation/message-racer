//
//  LobbyView.swift
//  MessageRacer
//
//  Created by Vincent on 6/29/21.
//

import SwiftUI
import Apollo


public struct LobbyView: View {
    let color: Color
    let navigate: (MainRoute) -> Void
    
    @StateObject
    var roomAgent = Graph.useQuery(
        query: AvailableRoomsQuery(),
        fallback: {AvailableRoomsQuery.Data(availableRooms: [])}
    )
    
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .ignoresSafeArea(.all)
            
            // All the Rooms available
            ScrollView {
                LazyVStack {
                    ForEach(roomAgent.data?.availableRooms ?? []) { room in
                        Button {
                            navigate(
                                .room(id: room.uuid)
                            )
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
