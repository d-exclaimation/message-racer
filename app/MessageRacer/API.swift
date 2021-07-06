// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// Event type
public enum EventType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case delta
  case end
  case start
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "DELTA": self = .delta
      case "END": self = .end
      case "START": self = .start
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .delta: return "DELTA"
      case .end: return "END"
      case .start: return "START"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: EventType, rhs: EventType) -> Bool {
    switch (lhs, rhs) {
      case (.delta, .delta): return true
      case (.end, .end): return true
      case (.start, .start): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [EventType] {
    return [
      .delta,
      .end,
      .start,
    ]
  }
}

public final class AvailableRoomsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query AvailableRooms {
      availableRooms(last: 20) {
        __typename
        id
        players {
          __typename
          id
        }
      }
    }
    """

  public let operationName: String = "AvailableRooms"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["RootQueryType"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("availableRooms", arguments: ["last": 20], type: .nonNull(.list(.nonNull(.object(AvailableRoom.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(availableRooms: [AvailableRoom]) {
      self.init(unsafeResultMap: ["__typename": "RootQueryType", "availableRooms": availableRooms.map { (value: AvailableRoom) -> ResultMap in value.resultMap }])
    }

    /// Get all public rooms
    public var availableRooms: [AvailableRoom] {
      get {
        return (resultMap["availableRooms"] as! [ResultMap]).map { (value: ResultMap) -> AvailableRoom in AvailableRoom(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: AvailableRoom) -> ResultMap in value.resultMap }, forKey: "availableRooms")
      }
    }

    public struct AvailableRoom: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Room"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("players", type: .nonNull(.list(.nonNull(.object(Player.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, players: [Player]) {
        self.init(unsafeResultMap: ["__typename": "Room", "id": id, "players": players.map { (value: Player) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Identifier
      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      /// Players joined in this room
      public var players: [Player] {
        get {
          return (resultMap["players"] as! [ResultMap]).map { (value: ResultMap) -> Player in Player(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Player) -> ResultMap in value.resultMap }, forKey: "players")
        }
      }

      public struct Player: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Player"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID) {
          self.init(unsafeResultMap: ["__typename": "Player", "id": id])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The id, duh
        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }
      }
    }
  }
}

public final class CreateRoomMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation CreateRoom($username: String!) {
      createRoom(userInfo: {username: $username}) {
        __typename
        host {
          __typename
          id
          username
        }
        room {
          __typename
          id
        }
      }
    }
    """

  public let operationName: String = "CreateRoom"

  public var username: String

  public init(username: String) {
    self.username = username
  }

  public var variables: GraphQLMap? {
    return ["username": username]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["RootMutationType"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createRoom", arguments: ["userInfo": ["username": GraphQLVariable("username")]], type: .nonNull(.object(CreateRoom.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createRoom: CreateRoom) {
      self.init(unsafeResultMap: ["__typename": "RootMutationType", "createRoom": createRoom.resultMap])
    }

    /// Create a new room
    public var createRoom: CreateRoom {
      get {
        return CreateRoom(unsafeResultMap: resultMap["createRoom"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "createRoom")
      }
    }

    public struct CreateRoom: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["HostInfo"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("host", type: .nonNull(.object(Host.selections))),
          GraphQLField("room", type: .nonNull(.object(Room.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(host: Host, room: Room) {
        self.init(unsafeResultMap: ["__typename": "HostInfo", "host": host.resultMap, "room": room.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Host player who created the room
      public var host: Host {
        get {
          return Host(unsafeResultMap: resultMap["host"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "host")
        }
      }

      /// Room created
      public var room: Room {
        get {
          return Room(unsafeResultMap: resultMap["room"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "room")
        }
      }

      public struct Host: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Player"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("username", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, username: String) {
          self.init(unsafeResultMap: ["__typename": "Player", "id": id, "username": username])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The id, duh
        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// Unique username
        public var username: String {
          get {
            return resultMap["username"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "username")
          }
        }
      }

      public struct Room: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Room"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID) {
          self.init(unsafeResultMap: ["__typename": "Room", "id": id])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifier
        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }
      }
    }
  }
}

public final class GameRoomSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    subscription GameRoom($id: ID!) {
      gameCycle(roomId: $id) {
        __typename
        ... on DeltaEvent {
          index
          type
          username
          word
        }
        ... on EndEvent {
          type
          winner
        }
        ... on StartEvent {
          type
          payload
          room {
            __typename
            players {
              __typename
              username
            }
          }
        }
      }
    }
    """

  public let operationName: String = "GameRoom"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["RootSubscriptionType"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("gameCycle", arguments: ["roomId": GraphQLVariable("id")], type: .nonNull(.object(GameCycle.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(gameCycle: GameCycle) {
      self.init(unsafeResultMap: ["__typename": "RootSubscriptionType", "gameCycle": gameCycle.resultMap])
    }

    /// Game cycle update
    public var gameCycle: GameCycle {
      get {
        return GameCycle(unsafeResultMap: resultMap["gameCycle"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "gameCycle")
      }
    }

    public struct GameCycle: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["DeltaEvent", "EndEvent", "StartEvent"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLTypeCase(
            variants: ["DeltaEvent": AsDeltaEvent.selections, "EndEvent": AsEndEvent.selections, "StartEvent": AsStartEvent.selections],
            default: [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            ]
          )
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public static func makeDeltaEvent(index: Int, type: EventType, username: String, word: String) -> GameCycle {
        return GameCycle(unsafeResultMap: ["__typename": "DeltaEvent", "index": index, "type": type, "username": username, "word": word])
      }

      public static func makeEndEvent(type: EventType, winner: String) -> GameCycle {
        return GameCycle(unsafeResultMap: ["__typename": "EndEvent", "type": type, "winner": winner])
      }

      public static func makeStartEvent(type: EventType, payload: [String], room: AsStartEvent.Room) -> GameCycle {
        return GameCycle(unsafeResultMap: ["__typename": "StartEvent", "type": type, "payload": payload, "room": room.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var asDeltaEvent: AsDeltaEvent? {
        get {
          if !AsDeltaEvent.possibleTypes.contains(__typename) { return nil }
          return AsDeltaEvent(unsafeResultMap: resultMap)
        }
        set {
          guard let newValue = newValue else { return }
          resultMap = newValue.resultMap
        }
      }

      public struct AsDeltaEvent: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["DeltaEvent"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("index", type: .nonNull(.scalar(Int.self))),
            GraphQLField("type", type: .nonNull(.scalar(EventType.self))),
            GraphQLField("username", type: .nonNull(.scalar(String.self))),
            GraphQLField("word", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(index: Int, type: EventType, username: String, word: String) {
          self.init(unsafeResultMap: ["__typename": "DeltaEvent", "index": index, "type": type, "username": username, "word": word])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var index: Int {
          get {
            return resultMap["index"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "index")
          }
        }

        public var type: EventType {
          get {
            return resultMap["type"]! as! EventType
          }
          set {
            resultMap.updateValue(newValue, forKey: "type")
          }
        }

        public var username: String {
          get {
            return resultMap["username"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "username")
          }
        }

        public var word: String {
          get {
            return resultMap["word"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "word")
          }
        }
      }

      public var asEndEvent: AsEndEvent? {
        get {
          if !AsEndEvent.possibleTypes.contains(__typename) { return nil }
          return AsEndEvent(unsafeResultMap: resultMap)
        }
        set {
          guard let newValue = newValue else { return }
          resultMap = newValue.resultMap
        }
      }

      public struct AsEndEvent: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EndEvent"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("type", type: .nonNull(.scalar(EventType.self))),
            GraphQLField("winner", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(type: EventType, winner: String) {
          self.init(unsafeResultMap: ["__typename": "EndEvent", "type": type, "winner": winner])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var type: EventType {
          get {
            return resultMap["type"]! as! EventType
          }
          set {
            resultMap.updateValue(newValue, forKey: "type")
          }
        }

        public var winner: String {
          get {
            return resultMap["winner"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "winner")
          }
        }
      }

      public var asStartEvent: AsStartEvent? {
        get {
          if !AsStartEvent.possibleTypes.contains(__typename) { return nil }
          return AsStartEvent(unsafeResultMap: resultMap)
        }
        set {
          guard let newValue = newValue else { return }
          resultMap = newValue.resultMap
        }
      }

      public struct AsStartEvent: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["StartEvent"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("type", type: .nonNull(.scalar(EventType.self))),
            GraphQLField("payload", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
            GraphQLField("room", type: .nonNull(.object(Room.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(type: EventType, payload: [String], room: Room) {
          self.init(unsafeResultMap: ["__typename": "StartEvent", "type": type, "payload": payload, "room": room.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var type: EventType {
          get {
            return resultMap["type"]! as! EventType
          }
          set {
            resultMap.updateValue(newValue, forKey: "type")
          }
        }

        public var payload: [String] {
          get {
            return resultMap["payload"]! as! [String]
          }
          set {
            resultMap.updateValue(newValue, forKey: "payload")
          }
        }

        public var room: Room {
          get {
            return Room(unsafeResultMap: resultMap["room"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "room")
          }
        }

        public struct Room: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Room"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("players", type: .nonNull(.list(.nonNull(.object(Player.selections))))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(players: [Player]) {
            self.init(unsafeResultMap: ["__typename": "Room", "players": players.map { (value: Player) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Players joined in this room
          public var players: [Player] {
            get {
              return (resultMap["players"] as! [ResultMap]).map { (value: ResultMap) -> Player in Player(unsafeResultMap: value) }
            }
            set {
              resultMap.updateValue(newValue.map { (value: Player) -> ResultMap in value.resultMap }, forKey: "players")
            }
          }

          public struct Player: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Player"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("username", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(username: String) {
              self.init(unsafeResultMap: ["__typename": "Player", "username": username])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Unique username
            public var username: String {
              get {
                return resultMap["username"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "username")
              }
            }
          }
        }
      }
    }
  }
}

public final class JoinRoomMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation JoinRoom($id: ID!, $username: String!) {
      joinRoom(roomId: $id, userInfo: {username: $username}) {
        __typename
        id
        username
      }
    }
    """

  public let operationName: String = "JoinRoom"

  public var id: GraphQLID
  public var username: String

  public init(id: GraphQLID, username: String) {
    self.id = id
    self.username = username
  }

  public var variables: GraphQLMap? {
    return ["id": id, "username": username]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["RootMutationType"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("joinRoom", arguments: ["roomId": GraphQLVariable("id"), "userInfo": ["username": GraphQLVariable("username")]], type: .nonNull(.object(JoinRoom.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(joinRoom: JoinRoom) {
      self.init(unsafeResultMap: ["__typename": "RootMutationType", "joinRoom": joinRoom.resultMap])
    }

    /// Join a room with a player information
    public var joinRoom: JoinRoom {
      get {
        return JoinRoom(unsafeResultMap: resultMap["joinRoom"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "joinRoom")
      }
    }

    public struct JoinRoom: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Player"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("username", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, username: String) {
        self.init(unsafeResultMap: ["__typename": "Player", "id": id, "username": username])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The id, duh
      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      /// Unique username
      public var username: String {
        get {
          return resultMap["username"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "username")
        }
      }
    }
  }
}

public final class SendDeltaMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation SendDelta($id: ID!, $username: String!, $index: Int!, $word: String!) {
      sendDelta(
        delta: {roomId: $id, username: $username, changes: {index: $index, word: $word}}
      )
    }
    """

  public let operationName: String = "SendDelta"

  public var id: GraphQLID
  public var username: String
  public var index: Int
  public var word: String

  public init(id: GraphQLID, username: String, index: Int, word: String) {
    self.id = id
    self.username = username
    self.index = index
    self.word = word
  }

  public var variables: GraphQLMap? {
    return ["id": id, "username": username, "index": index, "word": word]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["RootMutationType"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("sendDelta", arguments: ["delta": ["roomId": GraphQLVariable("id"), "username": GraphQLVariable("username"), "changes": ["index": GraphQLVariable("index"), "word": GraphQLVariable("word")]]], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(sendDelta: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "RootMutationType", "sendDelta": sendDelta])
    }

    /// Send delta event
    public var sendDelta: Bool? {
      get {
        return resultMap["sendDelta"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "sendDelta")
      }
    }
  }
}
