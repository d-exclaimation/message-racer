//
//  LobbyView.swift
//  MessageRacer
//
//  Created by Vincent on 6/29/21.
//

import SwiftUI
import Apollo
import ActivityIndicatorView


public struct LobbyView: View {
    let color: Color
    let navigate: (MainRoute) -> Void
    
    /// Room Feed  Agent
    @StateObject
    var roomAgent = Orfeus.use(
        awaiting: AvailableRoomsQuery(),
        fallback: AvailableRoomsQuery.Data(availableRooms: [])
    )
    
    /// Join Agent Mutation
    @StateObject
    var joinAgent = Orfeus.use(
        mutation: JoinRoomMutation.self
    )
    
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .ignoresSafeArea(.all)
            
            switch roomAgent.state {
            case .idle:
                EmptyView()
            case .loading:
                ActivityIndicatorView(isVisible: Binding.constant(true), type: .rotatingDots)
                    .frame(maxWidth: 50, maxHeight: 50)
                    .foregroundColor(Color(UIColor.darkPurple))
                    .transition(.opacity)
            case .succeed(let data):
                // All the Rooms available
                ScrollView {
                    LazyVStack {
                        ForEach(data.availableRooms) { room in
                            Button {
                                navigate(.room(id: room.uuid))
                            } label: {
                                RoomPreview(room: room)
                            }
                        }
                    }
                }
                .padding(.top, 15)
                .transition(.scale(scale: 0.3).combined(with: .opacity))
            case .failed(let err):
                Text(err.message)
                    .transition(.scale(scale: 0.3).combined(with: .opacity))
            }
            
        }
    }
    
    private let foreground: Color = .white
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView(color: .black, navigate: { _ in print("a") })
    }
}
