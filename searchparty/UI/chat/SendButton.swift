//
//  SendButton.swift
//  Messenger
//
//  Created by Afraz Siddiqui on 4/17/21.
//

import SwiftUI

struct SendButton: View {
    @Binding var text: String
    @ObservedObject var model: ChatViewModel
    @EnvironmentObject var searchPartyAppState: SearchPartyAppState

    var body: some View {
        Button(action: {
            self.sendMessage()
        }, label: {
            Image(systemName: "paperplane")
                .font(.system(size: 33))
                .aspectRatio(contentMode: .fit)
                .frame(width: 55, height: 55)
                .foregroundColor(Color.white)
                .background(Constant.color.tintColor)
                .clipShape(Circle())
        })
    }

    func sendMessage() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        model.sendMessage(text: text, lostPetId: (searchPartyAppState.selectedLostPet?.id)!)

        text = ""
    }
}
