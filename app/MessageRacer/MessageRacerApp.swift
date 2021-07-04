//
//  MessageRacerApp.swift
//  MessageRacer
//
//  Created by Vincent on 6/18/21.
//

import SwiftUI
import Apollo
import ApolloWebSocket

@main
struct MessageRacerApp: App {
    
    init() {
        print("initialize")
        // Assign the network
        Orfeus.shared.createClient = {
            print("created")
            // Websocket Transport
            let websocket = WebSocketTransport(
                request: URLRequest(
                    url: URL(string: Preferences.shared.websocket)!
                )
            )

            // Request Chain HTTP Network Transport
            let http = RequestChainNetworkTransport(
                interceptorProvider: LegacyInterceptorProvider(store: ApolloStore()),
                endpointURL: URL(string: Preferences.shared.api)!
            )

            // Split Network for both HTTP and Websocket Transport
            let splitNetwork = SplitNetworkTransport(
                uploadingNetworkTransport: http,
                webSocketNetworkTransport: websocket
            )

            return ApolloClient(networkTransport: splitNetwork, store: ApolloStore())
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
