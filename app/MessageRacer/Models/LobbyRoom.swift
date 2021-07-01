//
//  LobbyRoom.swift
//  MessageRacer
//
//  Created by Vincent on 7/1/21.
//

import Foundation

public typealias LobbyRoom = AvailableRoomsQuery.Data.AvailableRoom
extension AvailableRoomsQuery.Data.AvailableRoom: Identifiable {
    public var uuid: UUID {
        UUID(uuidString: id) ?? UUID()
    }
}
