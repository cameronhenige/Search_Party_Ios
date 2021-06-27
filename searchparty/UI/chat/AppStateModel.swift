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

class AppStateModel: ObservableObject {
    @AppStorage("currentUsername") var currentUsername: String = ""
    @AppStorage("currentEmail") var currentEmail: String = ""
    @Published var hasJoinedSearchparty: Bool = false
    @Published var isLoadingMessages: Bool? = false
    @Published var isSendingMessage: Bool? = false
    @Published var errorSendingMessage: Bool? = false
    @Published var showingSignIn: Bool = true
    @Published var conversations: [String] = []
    //@Published var messages: [Message] = []
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

// Search

extension AppStateModel {
    
    func checkForJoined(text: String, lostPetId: String) {
        //todo finish this
        Firestore.firestore().collection("Lost").document(lostPetId).collection("SearchPartyUsers").document(Auth.auth().currentUser!.uid).getDocument { [self] (document, error) in
            if let document = document {
                
                if(document.exists) {
                    self.hasJoinedSearchparty = true
                    addMessage(text: text, lostPetId: lostPetId)
                }else {
                    self.hasJoinedSearchparty = false
                    //todo show failed to join search party
                    
                }
                
            } else {
                print("Document does not exist") //todo handle failure
            }
        }
    }
    
    func getMessages(lostPetId: String) {
        
        
        Firestore.firestore().collection("Lost").document(lostPetId).collection("chat").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }

            self.messages = documents.compactMap { document -> Chat? in
              try? document.data(as: Chat.self)
            }
            
            
      }
            
        
        
        //todo
//        chatListener = NewFirestoreUtil().getLostPetChatQuery(lostPetId).addSnapshotListener { querySnapshot, firebaseFirestoreException ->
//            hideLoading()
//
//            if(firebaseFirestoreException == null){
//                var messages = FirestoreParser.getListOfMessagesFromSnapshot(querySnapshot)
//                showMessages(messages)
//            }else{
//                Toast.makeText(requireContext(), "There was an error loading this chat.", Toast.LENGTH_SHORT).show()
//            }
//        }
        
        
    }
}

// Conversations

extension AppStateModel {
    func getConversations() {
        // Listen for conversations

//        conversationListener = database
//            .collection("users")
//            .document(currentUsername)
//            .collection("chats").addSnapshotListener { [weak self] snapshot, error in
//                guard let usernames = snapshot?.documents.compactMap({ $0.documentID }),
//                      error == nil else {
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    self?.conversations = usernames
//                }
//            }
    }
}

// Get Chat / Send Messages

extension AppStateModel {
    func observeChat() {
//        createConversation()
//
//        chatListener = database
//            .collection("users")
//            .document(currentUsername)
//            .collection("chats")
//            .document(otherUsername)
//            .collection("messages")
//            .addSnapshotListener { [weak self] snapshot, error in
//                guard let objects = snapshot?.documents.compactMap({ $0.data() }),
//                      error == nil else {
//                    return
//                }
//
//                let messages: [Message] = objects.compactMap({
//                    guard let date = ISO8601DateFormatter().date(from: $0["created"] as? String ?? "") else {
//                        return nil
//                    }
//                    return Message(
//                        text: $0["text"] as? String ?? "",
//                        type: $0["sender"] as? String == self?.currentUsername ? .sent : .received,
//                        created: date
//                    )
//                }).sorted(by: { first, second in
//                    return first.created < second.created
//                })
//
//
//                DispatchQueue.main.async {
//                    self?.messages = messages
//                }
//            }
    }
    
    static var MESSAGE_KEY = "message"
    static var SENDER_KEY = "sender"
    static var SENDER_NAME = "senderName"

    func addMessage(text: String, lostPetId: String) {
        let messageData : [String: Any] = [
            AppStateModel.MESSAGE_KEY: text,
            AppStateModel.SENDER_KEY: Auth.auth().currentUser!.uid,
            AppStateModel.SENDER_NAME: Auth.auth().currentUser!.displayName //todo generate this in backend
        ]
        
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("Lost").document(lostPetId).collection("chat").addDocument(data: messageData){ err in
            if  err != nil {
                self.errorSendingMessage = true
            } else {
                //todo successfully sent
            }
            
            self.isSendingMessage = false
        
        self.isLoadingMessages = false

        }
    }
    
    func joinSearchParty() {
        
        //todo
//        NewFirestoreUtil().getLostPetUser(lostPetId).set(getSearchPartyUser(), SetOptions.merge()).addOnSuccessListener {
//            hasJoinedSearchParty = true
//            addMessage()
//
//        }.addOnFailureListener {
//            Toast.makeText(requireContext(), "There was an issue adding your message.", Toast.LENGTH_SHORT).show()
//            hideLoading()
//        }
    }

    func sendMessage(text: String, lostPetId: String) {
        
        isLoadingMessages = true
        if(self.hasJoinedSearchparty){
                addMessage(text: text, lostPetId: lostPetId)
           }else{
            checkForJoined(text: text, lostPetId: lostPetId)
           }
    }

    func createConversation() {
        database.collection("users")
            .document(currentUsername)
            .collection("chats")
            .document(otherUsername).setData(["created":"true"])

        database.collection("users")
            .document(otherUsername)
            .collection("chats")
            .document(currentUsername).setData(["created":"true"])
    }
}


// Sign In & Sign Up

extension AppStateModel {
    func signIn(username: String, password: String) {
        // Get email from DB
        database.collection("users").document(username).getDocument { [weak self] snapshot, error in
            guard let email = snapshot?.data()?["email"] as? String, error == nil else {
                return
            }


            // Try to sign in
            self?.auth.signIn(withEmail: email, password: password, completion: { result, error in
                guard error == nil, result != nil else {
                    return
                }

                DispatchQueue.main.async {
                    self?.currentEmail = email
                    self?.currentUsername = username
                    self?.showingSignIn = false
                }
            })
        }
    }

    func signUp(email: String, username: String, password: String) {
        // Create Account
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }

            // Insert username into database
            let data = [
                "email": email,
                "username": username
            ]

            self?.database
                .collection("users")
                .document(username)
                .setData(data) { error in
                    guard error == nil else {
                        return
                    }

                    DispatchQueue.main.async {
                        self?.currentUsername = username
                        self?.currentEmail = email
                        self?.showingSignIn = false
                    }
                }
        }

    }

    func signOut() {
        do {
            try auth.signOut()
            self.showingSignIn = true
        }
        catch {
            print(error)
        }
    }
}
