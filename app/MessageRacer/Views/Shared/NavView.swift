//
//  NavView.swift
//  MessageRacer
//
//  Created by Vincent on 6/18/21.
//

import SwiftUI

public struct NavView: View {
    let user: User
    
    public var body: some View {
        if (user.isLoggedIn) {
            HStack(spacing: 10) {
                Text("\(user.username)")
                
                Button {} label: {
                    Text("Log out")
                        .foregroundColor(.red)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        } else {
            Text("Not logged in")
        }
    }
}

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        NavView(user: User())
    }
}
