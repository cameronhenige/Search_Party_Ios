//
//  ChatView.swift
//  searchparty
//
//  Created by Hannah Krolewski on 6/26/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct ChatView: View {
    @State var message: String = ""
    @EnvironmentObject var model: ChatViewModel
    @EnvironmentObject var searchPartyAppState: SearchPartyAppState

    let otherUsername: String

    init(otherUsername: String) {
        self.otherUsername = otherUsername
    }

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(model.messages, id: \.self) { message in
                    ChatRow(text: message.message!,
                            sender: message.sender == Auth.auth().currentUser?.uid)
                        .padding(3)
                }
            }

            // Field, send button
            HStack {
                TextField("Message...", text: $message)
                    .modifier(CustomField())

                SendButton(text: $message)
            }
            .padding()
        }
        .navigationBarTitle(otherUsername, displayMode: .inline)
        .onAppear {
            model.otherUsername = otherUsername
            model.getMessages(lostPetId: (searchPartyAppState.selectedLostPet?.id)!)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(otherUsername: "Samantha")
            .preferredColorScheme(.dark)
    }
}