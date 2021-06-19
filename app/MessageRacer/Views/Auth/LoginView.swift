//
//  LoginView.swift
//  MessageRacer
//
//  Created by Vincent on 6/19/21.
//

import SwiftUI

public struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    let color: Color
    let text: String
    let onPress: () -> Void
    
    @State
    var email: String = ""
    @State
    var password: String = ""
    
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .ignoresSafeArea(.all)
            
            VStack {
                VStack(alignment: .leading, spacing: formSpacing) {
                    Text("Email")
                        .font(.caption)
                    TextField("Email", text: $email)
                    Divider()
                    Text("Email")
                        .font(.caption)
                    TextField("Email", text: $email)
                }
                .padding()
                .background(bgForm)
                .cornerRadius(radius)
                .padding()
                
                Button(action: onPress) {
                    Text(text)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    // MARK: - Style Constants
    var bgForm: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    let radius: CGFloat = 8
    let formSpacing: CGFloat = 20
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(color: .blue, text: "Login") {
            print("")
        }
    }
}
