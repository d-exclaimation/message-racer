//
//  RoomPreview.swift
//  MessageRacer
//
//  Created by Vincent on 6/29/21.
//

import SwiftUI

public struct Room: Codable, Identifiable {
    public let id: UUID
    public let playerCount: Int
}

public struct RoomPreview: View {
    let room: Room
    
    var availabilities: Color {
        if room.playerCount <= 2 {
            return .green
        } else if room.playerCount <= 3 {
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
                Text(room.id.uuidString)
                    .font(.caption)
                    .fontWeight(.thin)
                    .foregroundColor(.black)
                HStack {
                    Text("Player count: ")
                        .font(.caption)
                        .foregroundColor(.black)
                    Text(room.playerCount.description)
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
        RoomPreview(room: Room(id: UUID(), playerCount: 3))
    }
}
