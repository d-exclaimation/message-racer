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
    
    @State
    var rooms = [LobbyRoom]()
    
    func setRooms(data: AvailableRoomsQuery.Data) -> Void {
        print("API Success")
        withAnimation {
            rooms = data.availableRooms
        }
    }
    
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .ignoresSafeArea(.all)
            
            // All the Rooms available
            ScrollView {
                LazyVStack {
                    ForEach(rooms) { room in
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
        .onAppear(perform: onMount)
    }
    
    private let foreground: Color = .white
    
    private func onMount() -> Void {
        _ = Network.shared.fetch(
            query: AvailableRoomsQuery(),
            onSuccess: setRooms(data:),
            onError: { print("\($0)") }
        )
    }
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView(color: .black, navigate: { _ in print("a") })
    }
}
