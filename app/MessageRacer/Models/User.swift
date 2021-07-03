//
//  User.swift
//  MessageRacer
//
//  Created by Vincent on 6/18/21.
//

import Foundation


public class User: ObservableObject {
    @Published public var username: String
    @Published public var isLoggedIn: Bool
    
    public init(with name: String) {
        username = name
        isLoggedIn = true
    }
    
    public init() {
        isLoggedIn = false
        username = ""
    }
    
    public func login(username: String) {
        self.username = username
        self.isLoggedIn = true
    }
    
    public func logout() {
        self.isLoggedIn = false
    }
}
