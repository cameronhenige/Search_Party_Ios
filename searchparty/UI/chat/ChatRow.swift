//
//  ChatRow.swift
//  Messenger
//
//  Created by Afraz Siddiqui on 4/17/21.
//

import SwiftUI

struct ChatRow: View {
    let sender: String
    @EnvironmentObject var model: AppStateModel

    var isSender: Bool {
        return true
    }

    let text: String

    init(text: String, sender: String) {
        self.text = text
        self.sender = sender
    }

    var body: some View {
        HStack {
            if isSender { Spacer() }

            if !isSender {
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
                    .foregroundColor(isSender ? Color.white : Color(.label))
                    .padding()
            }
            .background(isSender ? Color.blue : Color(.systemGray4))
            .padding(isSender ? .leading : .trailing,
                     isSender ? UIScreen.main.bounds.width/3 : UIScreen.main.bounds.width/5)
            .cornerRadius(6)

            if !isSender { Spacer() }

        }
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatRow(text: "Test", sender: "Cam")
                .preferredColorScheme(.dark)
            ChatRow(text: "Test", sender: "Hannah")
                .preferredColorScheme(.light)

        }
    }
}
