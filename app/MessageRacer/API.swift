// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

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
        id
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
        GraphQLField("createRoom", arguments: ["userInfo": ["username": GraphQLVariable("username")]], type: .object(CreateRoom.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createRoom: CreateRoom? = nil) {
      self.init(unsafeResultMap: ["__typename": "RootMutationType", "createRoom": createRoom.flatMap { (value: CreateRoom) -> ResultMap in value.resultMap }])
    }

    /// Create a new room
    public var createRoom: CreateRoom? {
      get {
        return (resultMap["createRoom"] as? ResultMap).flatMap { CreateRoom(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createRoom")
      }
    }

    public struct CreateRoom: GraphQLSelectionSet {
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
