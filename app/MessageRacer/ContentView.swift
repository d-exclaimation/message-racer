//
//  ContentView.swift
//  MessageRacer
//
//  Created by Vincent on 6/18/21.
//

import SwiftUI

/// Main Tree Navigation Routes
public enum MainRoute {
    case room(id: UUID), main, lobby
}

struct ContentView: View {
    /// Route for Navigation
    @State
    var route: MainRoute = .main
    
    @StateObject
    var user: User = User()
    
    /// Get room id from the route, using case
    var roomID: UUID? {
        if case .room(let id) = route {
            return id
        }
        return nil
    }
    
    /// Allow to change the route so child component can programmatically, reroute navigation
    func navigate(to route: MainRoute) -> Void {
        withAnimation {
            self.route = route
        }
    }
    
    /// Just a wrapper to move back to main used for Navigation Bar
    func leaveRoom() -> Void {
        withAnimation {
            route = .main
        }
    }
    
    var body: some View {
        VStack {
            // Navigation Bar
            NavView(roomID: roomID, leaveRoom: leaveRoom)
            
            // Either room view or main view
            content()
                .environmentObject(user)
        }
        .onAppear {
            route = user.isLoggedIn ? route : .lobby
        }
   }
    
    @ViewBuilder func content() -> some View {
        switch route {
        case .room(let id):
            RoomView(
                color: Color(UIColor.mediumPurple),
                uuid: id
            )
            .transition(.slide)
        case .main:
            MainView(
                color: .purple,
                text: "Main Page",
                navigate: navigate(to:)
            )
            .transition(.slide)
        case .lobby:
            LobbyView(
                color: .black,
                navigate: navigate(to:)
            )
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
