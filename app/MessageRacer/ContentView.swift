//
//  ContentView.swift
//  MessageRacer
//
//  Created by Vincent on 6/18/21.
//

import SwiftUI

enum MainRoute {
    case login, signup, main
}

struct ContentView: View {
    @State
    var route: MainRoute = .main
    
    @StateObject
    var user: User = User(with: "Vincent")
    
    func navigate(to route: MainRoute) -> Void {
        withAnimation {
            self.route = route
        }
    }
    
    
    var body: some View {
        VStack {
            NavView(user: user)
            routing
                .environmentObject(user)
        }
   }
    
    var routing: some View {
        switch route {
        case .login:
            return MainView(color: .blue, text: "Log In") {
                navigate(to: .signup)
            }
        case .signup:
            return MainView(color: .orange, text: "Sign Up") {
                navigate(to: .main)
            }
        case .main:
            return MainView(color: .purple, text: "Main Page") {
                navigate(to: .login)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
