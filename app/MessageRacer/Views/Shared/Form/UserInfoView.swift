//
//  CreateRoomFormView.swift
//  MessageRacer
//
//  Created by Vincent on 7/2/21.
//

import SwiftUI
import Apollo

struct UserInfoView: View {
    @Binding
    var isShowing: Bool
    @Binding
    var errorMessage: String?
    var isLoading: Bool
    let onSubmit: (String) -> Void
    
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
            onSubmit(username)
        } label: {
            Text("Submit")
        }
        .disabled(isLoading)
    }
}

struct CreateRoomFormView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(isShowing: Binding.constant(false), errorMessage: Binding.constant(nil), isLoading: false) { _ in }
    }
}
