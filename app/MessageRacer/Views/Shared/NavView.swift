//
//  NavView.swift
//  MessageRacer
//
//  Created by Vincent on 6/18/21.
//

import SwiftUI

public struct NavView: View {
    let roomID: UUID?
    let leaveRoom: () -> Void
    
    public var body: some View {
        HStack(spacing: 10) {
            Text("Message Racer")
                .font(.headline)
                .foregroundColor(.purple)
            if let roomID = roomID {
                Text("\(roomID)")
                    .font(.system(size: 8, weight: .thin, design: .monospaced))
                    .foregroundColor(.gray)
                    .transition(.slide)
                Spacer()
                Button(action: leaveRoom) {
                    Text("Leave")
                        .foregroundColor(.red)
                        .transition(.scale)
                }
            } else {
                Spacer()
            }
        }
        .padding(.horizontal, 20)
    }
}

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        NavView(roomID: UUID()) {}
    }
}
