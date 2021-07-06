//
//  GameCycleEnum.swift
//  MessageRacer
//
//  Created by Vincent on 7/4/21.
//

import Foundation

public enum GameEvent {
    case start(GameRoomSubscription.Data.GameCycle.AsStartEvent.Room, [String])
    case end(String)
    case delta(username: String, index: Int, word: String)
    case none
}

extension GameRoomSubscription.Data.GameCycle {
    var union: GameEvent {
        if let start = asStartEvent {
            return .start(start.room, start.payload)
        }
        if let delta = asDeltaEvent {
            return .delta(username: delta.username, index: delta.index, word: delta.word)
        }
        if let end = asEndEvent {
            return .end(end.winner)
        }
        return .none
    }
}

extension GameRoomSubscription.Data: Equatable {
    public static func == (lhs: GameRoomSubscription.Data, rhs: GameRoomSubscription.Data) -> Bool {
        switch lhs.gameCycle.union {
        case .start(_, let arr1):
            if case let .start(_, arr2) = rhs.gameCycle.union {
                return arr1 == arr2
            }
            return false
        case .end(let win1):
            if case let .end(win2) = rhs.gameCycle.union {
                return win1 == win2
            }
            return false
        case .delta(let user1, let i, let word1):
            if case let .delta(user2, j, word2) = rhs.gameCycle.union {
                return user1 == user2 && i == j && word1 == word2
            }
            return false
        case .none:
            if case .none = rhs.gameCycle.union {
                return true
            }
            return false
        }
    }
}
