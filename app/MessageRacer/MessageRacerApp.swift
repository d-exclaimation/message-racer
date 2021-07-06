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
        // Assign the network
        Orfeus.shared.createClient = {
            // Websocket Transport
            let websocket = WebSocketTransport(
                request: URLRequest(
                    url: URL(string: Preferences.shared.websocket)!
                )
            )
            let store = ApolloStore()
            
            // Request Chain HTTP Network Transport
            let http = RequestChainNetworkTransport(
                interceptorProvider: NetworkInterceptorProvider(
                    store: store,
                    client: URLSessionClient(sessionConfiguration: .cookie, callbackQueue: .main)
                ),
                endpointURL: URL(string: Preferences.shared.api)!
            )

            // Split Network for both HTTP and Websocket Transport
            let splitNetwork = SplitNetworkTransport(
                uploadingNetworkTransport: http,
                webSocketNetworkTransport: websocket
            )

            return ApolloClient(networkTransport: splitNetwork, store: store)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
