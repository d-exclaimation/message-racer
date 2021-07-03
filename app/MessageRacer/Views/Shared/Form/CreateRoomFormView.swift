//
//  CreateRoomFormView.swift
//  MessageRacer
//
//  Created by Vincent on 7/2/21.
//

import SwiftUI
import Apollo

struct CreateRoomFormView: View {
    @Binding
    var isShowing: Bool
    let createRoom: (GraphQLID, String) -> Void
    
    @State
    var username: String = ""
    @State
    var failed: Bool = false
    @State
    var reason: String = ""
    
    /// Create Agent Mutation
    @StateObject
    var createAgent = Orfeus.use(
        mutation: CreateRoomMutation.self
    )
    
    var body: some View {
        VStack {
            HStack {
                Text("Create a new room")
                    .font(.headline)
                Spacer()
                Button {
                    isShowing = false
                } label: {
                    Text("Done")
                        .foregroundColor(.blue)
                }
            }
            .padding(.top)
            .padding(.horizontal)
            Form {
                Section(header: Text("User Info"), footer: submitButton) {
                    TextField("Username", text: $username)
                }
                
                if failed {
                    Text("\(reason)")
                        .font(.system(size: 12, weight: .thin, design: .monospaced))
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    var submitButton: some View {
        Button {
            createAgent.mutate(
                variables: CreateRoomMutation(username: username),
                onCompleted: handleSuccess(data:),
                onFailure: handleFailure(_:)
            )
        } label: {
            Text("Submit")
        }
        .disabled(createAgent.isLoading)
    }
    
    
    private func handleFailure(_ err: Orfeus.Fault) -> Void {
        switch err {
        case .requestFailed(reason: let res):
            reason = res
        case .graphqlErrors(errors: let errors):
            reason = errors.map { $0.message }.compactMap { $0 }.joined(separator: ", ")
        case .nothingHappened:
            reason = "nothing happened"
        }
        failed = true
    }
    
    /// Handle creation success with joining room
    private func handleSuccess(data: CreateRoomMutation.Data) -> Void {
        let roomId = data.createRoom.room.id
        let username = data.createRoom.host.username
        createRoom(roomId, username)
    }
}

struct CreateRoomFormView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRoomFormView(isShowing: Binding.constant(false)) { _, _ in }
    }
}
