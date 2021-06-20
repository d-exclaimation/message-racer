//
//  ChatMessage.swift
//  ClusterChat
//
//  Created by Vincent on 10/11/20.
//

import SwiftUI

struct ChatMessage: View {
    @Environment(\.colorScheme) var colorScheme
    let fontColor: Color
    let content: String
    let date: Date
    let alignment: HorizontalAlignment
    let formater: String
    let user: String
    let color: Color
    
    init(content: String, date: Date, isUser: Bool, user: String, fontColor: Color? = nil) {
        self.content = content
        self.date = date
        self.user = user
        
        self.fontColor = fontColor ?? Color.black
        
        // Assign conditional properties
        color = isUser ? Color(UIColor.lavender) : Color(UIColor.white)
        alignment = isUser ? .trailing : .leading
        
        // Assign date in the proper format
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        formater = dateFormatter.string(from: self.date)
    }
    
    
    var body: some View {
        Group {
            switch alignment {
            case .trailing:
                HStack {
                    Spacer()
                    timestamp
                    textMessage
                }
            default:
                HStack {
                    textMessage
                    timestamp
                    Spacer()
                }
            }
        }
    }
    
    var timestamp: some View {
        VStack {
            Spacer()
            Text("\(formater)")
                .font(dateFont)
        }
    }
    
    var textMessage: some View {
        VStack(alignment: alignment) {
            Text("\(user)")
                .font(.caption)
                .foregroundColor(.black)
            Text(content)
                .font(.headline)
                .foregroundColor(fontColor)
                .bold()
        }
        .bubbleCarded(
            using: color,
            opacity,
            of: type,
            with: .custom(
                size: cardSize,
                padding: cardPadding
            )
        )
    }
    
    let cardSize = CGSize(width: 30, height: 10)
    let cardPadding: CGFloat = 0
    let opacity = 1.0
    let type: TypeOfContent = .stack
    let dateFont: Font = .system(size: 10)
}

struct ChatMessage_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            ChatMessage(content: "Hi, how are you?", date: Date(), isUser: true, user: "peepee")
            ChatMessage(content: "Hi, how are you?", date: Date(), isUser: false, user: "peepee")
            ChatMessage(content: "Hi, how are you?", date: Date(), isUser: true, user: "peepee")
            ChatMessage(content: "Hi, how are you?", date: Date(), isUser: false, user: "peepee")
            ChatMessage(content: "Hi, how are you?", date: Date(), isUser: true, user: "peepee")
            ChatMessage(content: "Hi, how are you?", date: Date(), isUser: false, user: "peepee")
        }
        .padding()
    }
}
