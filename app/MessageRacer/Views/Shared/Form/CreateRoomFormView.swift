//
//  CreateRoomFormView.swift
//  MessageRacer
//
//  Created by Vincent on 7/2/21.
//

import SwiftUI

struct CreateRoomFormView: View {
    @Binding
    var isShowing: Bool
    
    @State
    var username: String = ""
    
    @StateObject
    var createRoom = Orfeus.use(
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
            }
        }
    }
    
    var submitButton: some View {
        Button {
            createRoom.mutate(
                variables: CreateRoomMutation(username: username),
                onCompleted: handleSuccess(data:)
            )
        } label: {
            Text("Submit")
        }
        .disabled(createRoom.isLoading)
    }
    
    
    private func handleSuccess(data: CreateRoomMutation.Data) -> Void {
        print(data.createRoom?.id ?? "no id")
    }
}

struct CreateRoomFormView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRoomFormView(isShowing: Binding.constant(false))
    }
}
