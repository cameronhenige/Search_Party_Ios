//
//  ChatRow.swift
//  Messenger
//
//  Created by Afraz Siddiqui on 4/17/21.
//

import SwiftUI

struct ChatRow: View {
    let sender: Bool
    @EnvironmentObject var model: ChatViewModel


    let text: String

    init(text: String, sender: Bool) {
        self.text = text
        self.sender = sender
    }

    var body: some View {
        HStack {
            if sender { Spacer() }

            if !sender {
                VStack {
                    Spacer()
                    Image(model.currentUsername == "Matt" ? "photo1" : "photo2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .foregroundColor(Color.pink)
                        .clipShape(Circle())
                }
            }

            HStack {
                Text(text)
                    .foregroundColor(sender ? Color.white : Color(.label))
                    .padding()
            }
            .background(sender ? Color.blue : Color(.systemGray4))
            .padding(sender ? .leading : .trailing,
                     sender ? UIScreen.main.bounds.width/3 : UIScreen.main.bounds.width/5)
            .cornerRadius(6)

            if !sender { Spacer() }

        }
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatRow(text: "Test", sender: true)
                .preferredColorScheme(.dark)
            ChatRow(text: "Test", sender: false)
                .preferredColorScheme(.light)

        }
    }
}
