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
    @Published var errorSendingMessage: Bool = false
    @Published var errorMessage: String = ""

    @Published var showingSignIn: Bool = true
    @Published var conversations: [String] = []
    @Published var messages: [Chat] = []
    @Published var messageBeingSent: [MessageBeingSent] = []

    let database = Firestore.firestore()
    let auth = Auth.auth()


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
            
            for message in self.messages {
                
                self.messageBeingSent.removeAll(where: {$0.id == message.id})
            
            }
      }
        
    }
    
    func messageContainsMessageBeingSent() -> Bool {
        return true
    }
}


extension ChatViewModel {
    
    static var MESSAGE_KEY = "message"
    static var SENDER_KEY = "sender"
    static var SENDER_NAME = "senderName"

    func addMessage(text: String, lostPetId: String) {
        
        let userName = Auth.auth().currentUser!.displayName
        //todo generate this in backend
        
        let messageData : [String: Any] = [
            ChatViewModel.MESSAGE_KEY: text,
            ChatViewModel.SENDER_KEY: Auth.auth().currentUser!.uid,
            ChatViewModel.SENDER_NAME: userName
        ]
        

        var ref: DocumentReference?
        ref = Firestore.firestore().collection("Lost").document(lostPetId).collection("chat").addDocument(data: messageData){ err in
            if  err != nil {
                self.errorMessage = text
                self.errorSendingMessage = true
                self.messageBeingSent.removeAll(where: {$0.id == ref?.documentID})
            }

        }
        
        messageBeingSent.append(MessageBeingSent(id: ref?.documentID, message: text, sender: Auth.auth().currentUser!.uid, senderName: userName))
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
        
        if(self.hasJoinedSearchparty){
                addMessage(text: text, lostPetId: lostPetId)
           }else{
            checkForJoined(text: text, lostPetId: lostPetId)
           }
    }

}
