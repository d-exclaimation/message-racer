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
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: radius)
                .foregroundColor(.purple)
            Rectangle()
                .foregroundColor(.white)
                .padding(.leading, 10)
            VStack {
                Text(room.id.description)
                    .foregroundColor(.black)
                Text(room.playerCount.description)
                    .foregroundColor(.black)
            }
        }
        .frame(maxWidth: .infinity, minHeight: height)
        .cornerRadius(radius)
   }
    
    private let radius: CGFloat = 5
    private let height: CGFloat = 75
}

struct RoomPreview_Previews: PreviewProvider {
    static var previews: some View {
        RoomPreview(room: Room(id: UUID(), playerCount: 3))
    }
}
