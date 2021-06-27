//
//  AppStateModel.swift
//  Messenger
//
//  Created by Afraz Siddiqui on 4/17/21.
//

import Foundation
import SwiftUI

import FirebaseAuth
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @AppStorage("currentUsername") var currentUsername: String = ""
    @AppStorage("currentEmail") var currentEmail: String = ""
    @Published var hasJoinedSearchparty: Bool = false
    @Published var isAddingMessage: Bool = false
    @Published var isSendingMessage: Bool? = false
    @Published var errorSendingMessage: Bool? = false
    @Published var showingSignIn: Bool = true
    @Published var conversations: [String] = []
    @Published var messages: [Chat] = []

    let database = Firestore.firestore()
    let auth = Auth.auth()

    var otherUsername = ""

    var conversationListener: ListenerRegistration?
    var chatListener: ListenerRegistration?

    init() {
        self.showingSignIn = Auth.auth().currentUser == nil
    }
}

extension ChatViewModel {
    
    func checkForJoined(text: String, lostPetId: String) {
        Firestore.firestore().collection("Lost").document(lostPetId).collection("SearchPartyUsers").document(Auth.auth().currentUser!.uid).getDocument { [self] (document, error) in
            if let document = document {
                
                if(document.exists) {
                    self.hasJoinedSearchparty = true
                    addMessage(text: text, lostPetId: lostPetId)
                }else {
                    self.hasJoinedSearchparty = false
                    joinSearchParty(text: text, lostPetId: lostPetId)
                }
                
            } else {
                print("Document does not exist") //todo handle failure
            }
        }
    }
    
    func getMessages(lostPetId: String) {
        
        //.orderBy("created", Query.Direction.DESCENDING)
        Firestore.firestore().collection("Lost").document(lostPetId).collection("chat").order(by: "created", descending: false).addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
            
            self.messages = documents.compactMap { document -> Chat? in
              try? document.data(as: Chat.self)
            }
      }
        
    }
}


extension ChatViewModel {
    
    static var MESSAGE_KEY = "message"
    static var SENDER_KEY = "sender"
    static var SENDER_NAME = "senderName"

    func addMessage(text: String, lostPetId: String) {
        
        isAddingMessage = true
        let messageData : [String: Any] = [
            ChatViewModel.MESSAGE_KEY: text,
            ChatViewModel.SENDER_KEY: Auth.auth().currentUser!.uid,
            ChatViewModel.SENDER_NAME: Auth.auth().currentUser!.displayName //todo generate this in backend
        ]
        
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("Lost").document(lostPetId).collection("chat").addDocument(data: messageData){ err in
            if  err != nil {
                self.errorSendingMessage = true
            } else {
                //todo successfully sent
            }
            self.isSendingMessage = false
        
        self.isAddingMessage = false

        }
    }
    
    
    private func joinSearchParty(text: String, lostPetId: String) {
    
Firestore.firestore().collection("Lost").document(lostPetId).collection("SearchPartyUsers").document(Auth.auth().currentUser!.uid).setData([
    "uid": Auth.auth().currentUser!.uid, "color": UIColor.generateRandomColor().toHexString()
], merge: true) { err in
        if let err = err {
            print("Error adding document: \(err)") //todo
        } else {
            self.hasJoinedSearchparty = true
            self.sendMessage(text: text, lostPetId: lostPetId)

        }
    }
}

    func sendMessage(text: String, lostPetId: String) {
        
        isAddingMessage = true
        if(self.hasJoinedSearchparty){
                addMessage(text: text, lostPetId: lostPetId)
           }else{
            checkForJoined(text: text, lostPetId: lostPetId)
           }
    }

}
