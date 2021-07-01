//
//  RoomPreview.swift
//  MessageRacer
//
//  Created by Vincent on 6/29/21.
//

import SwiftUI


public struct RoomPreview: View {
    let room: LobbyRoom
    
    var availabilities: Color {
        if room.players.count <= 2 {
            return .green
        } else if room.players.count <= 3 {
            return .yellow
        }
        return .red
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: radius)
                .foregroundColor(availabilities)
            Rectangle()
                .foregroundColor(.white)
                .padding(.leading, 10)
            VStack {
                Text(room.id)
                    .font(.caption)
                    .fontWeight(.thin)
                    .foregroundColor(.black)
                HStack {
                    Text("Player count: ")
                        .font(.caption)
                        .foregroundColor(.black)
                    Text(room.players.count.description)
                        .font(.caption)
                        .foregroundColor(availabilities)
                }
                .padding(.top, 2)
           }
            .padding(.horizontal, 10)
        }
        .frame(maxWidth: .infinity, minHeight: height)
        .cornerRadius(radius)
        .padding(.horizontal, 5)
   }
    
    private let radius: CGFloat = 5
    private let height: CGFloat = 75
    
    
}

struct RoomPreview_Previews: PreviewProvider {
    static var previews: some View {
        RoomPreview(room: LobbyRoom(id: "", players: []))
    }
}
