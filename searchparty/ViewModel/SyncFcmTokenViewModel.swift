//
//  SyncFcmTokenViewModel.swift
//  searchparty
//
//  Created by Hannah Krolewski on 6/18/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseMessaging
import Firebase

class SyncFcmTokenViewModel: ObservableObject {

    
    func syncFcmTokenIfNeeded() {
        print("sync fcm token if needed")
        self.tryToGetInitialFcmToken()
    }
    
    private func tryToGetInitialFcmToken() {

        if(Auth.auth().currentUser != nil){

                if(!latestTokenHasBeenSyncedToCloud()) {
                    
                    Messaging.messaging().token { token, error in
                      if let error = error {
                        print("Error fetching FCM registration token: \(error)")
                      } else if let token = token {
                        print("FCM registration token: \(token)")
                        
                        
                        UserDefaults.standard.setValue(token, forKey: "LATEST_FCM_TOKEN")

                        self.updateTokenOnBackend(token: token)
                      }
                    }
                    
                }
            }

        }

        private func latestTokenHasBeenSyncedToCloud() -> Bool {
            let latestFcmToken = UserDefaults.standard.string(forKey: "LATEST_FCM_TOKEN")
        
            let hasSeenSearchPartyIntro = UserDefaults.standard.bool(forKey: latestFcmToken! + "_" + Auth.auth().currentUser!.uid)
            
            return hasSeenSearchPartyIntro
        }

        private func updateTokenOnBackend(token: String) {

            
            Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("fcmTokens").document(token).setData([
                "token": token, "os": "iOS"
            ], merge: true) { err in
                if let err = err {
                    print("Error saving latest token: \(err)")
                } else {
                    UserDefaults.standard.setValue(token, forKey: token + "_" + Auth.auth().currentUser!.uid)
                }
            }
            
        }
}
