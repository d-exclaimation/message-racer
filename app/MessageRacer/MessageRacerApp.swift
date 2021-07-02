//
//  MessageRacerApp.swift
//  MessageRacer
//
//  Created by Vincent on 6/18/21.
//

import SwiftUI
import Apollo

@main
struct MessageRacerApp: App {
    
    init() {
        Orfeus.shared.apollo = ApolloClient(url: URL(string: Preferences.shared.api)!)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
