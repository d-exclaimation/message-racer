//
//  Plist.swift
//  MessageRacer
//
//  Created by Vincent on 7/1/21.
//

import Foundation

public struct Preferences: Codable {
    public var api: String
    public var websocket: String
    
    init() {
        api = "http://localhost:4000/graphql"
        websocket = "ws://localhost:4000/subscription/websocket"
    }
    
    public static let shared: Preferences = getPlist(withName: "Preferences") ?? Preferences()
}

public func getPlist<TReturn: Codable>(withName name: String) -> TReturn? {
    if  let path = Bundle.main.path(forResource: name, ofType: "plist"),
        let xml = FileManager.default.contents(atPath: path),
        let pref = try? PropertyListDecoder().decode(TReturn.self, from: xml) {
        return pref
    }
    return nil
}
