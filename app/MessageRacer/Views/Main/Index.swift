//
//  Index.swift
//  MessageRacer
//
//  Created by Vincent on 6/18/21.
//

import Foundation
import SwiftUI
import Apollo

public struct MainView: View {
    @EnvironmentObject var user: User
    
    let color: Color
    let text: String
    let navigate: (MainRoute) -> Void
    
    @State
    var showCreateMenuForm = false
    
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .ignoresSafeArea(.all)
            
            VStack {
                Button {
                    navigate(.room(id: UUID()))
                } label: {
                    buttonLabel(text: "Join a room", iconName: "gamecontroller.fill")
                }
                Button {
                    showCreateMenuForm.toggle()
                } label: {
                    buttonLabel(text: "Create a room")
                }
                Button {
                    navigate(.lobby)
                } label: {
                    buttonLabel(text: "Explore rooms", iconName: "house.circle.fill")
                }
            }
            /// Form Create Room
            .sheet(
                isPresented: $showCreateMenuForm,
                onDismiss: { showCreateMenuForm = false }
            ) {
                CreateRoomFormView(isShowing: $showCreateMenuForm, createRoom: createNewRoom(roomID:username:))
            }
        }
    }
    
    private let fontColor: Color = Color(UIColor.mediumPurple)
    
    
    private func buttonLabel(text: String, iconName: String = "circle.grid.cross.fill") -> some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(fontColor)
            Text(text)
                .font(.headline)
                .foregroundColor(fontColor)
       }
        .frame(width: 300)
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
    
    /// Create room callback for the form
    private func createNewRoom(roomID: GraphQLID, username: String) -> Void {
        showCreateMenuForm = false
        user.login(username: username)
        navigate(.room(id: UUID(uuidString: roomID) ?? UUID()))
    }
}

struct MainView_Preview: PreviewProvider {
    static var previews: some View {
        MainView(color: .purple, text: "Hello World", navigate: { _ in print("a") }).environmentObject(User())
    }
}
