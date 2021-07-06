//
//  JoinFormView.swift
//  MessageRacer
//
//  Created by Vincent on 7/6/21.
//

import SwiftUI
import Apollo

struct JoinFormView: View {
    @Binding
    var isShowing: Bool
    @Binding
    var errorMessage: String?
    var isLoading: Bool
    let onSubmit: (GraphQLID, String) -> Void
    
    @State
    var id: GraphQLID = ""
    @State
    var username: String = ""
   
    
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
                Section(header: Text("Room ID"), footer: submitButton) {
                    TextField("ID", text: $id)
                }
                Section(header: Text("User Info"), footer: submitButton) {
                    TextField("Username", text: $username)
                }
                
                if let reason = errorMessage {
                    Text("\(reason)")
                        .font(.system(size: 12, weight: .thin, design: .monospaced))
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    var submitButton: some View {
        Button {
            onSubmit(id, username)
        } label: {
            Text("Submit")
        }
        .disabled(isLoading)
    }
}

