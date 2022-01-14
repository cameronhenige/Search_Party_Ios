//
//  AppState.swift
//  searchparty
//
//  Created by Hannah Krolewski on 6/23/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import GeoFire
import FlexibleGeohash

class SearchPartyAppState: NSObject, ObservableObject {
    
    @Published var isOnLostPetIsFound = false
    @Published var isOnSearchParty = false
    @Published var isOnChat = false
    @Published var isOnAddingLostPet = false
    @Published var isOnEditingLostPet = false
    @Published var isFiltering = false
    @Published var isLoadingLostPetFromNotification = false
    @Published var isOnLostPet = false
    @Published var selectedTab: Int = 1
    @Published var selectedLostPet: LostPet? = nil
    @Published var isLoadingLostPets = false

        
    
    func navigateToLostPet(lostPetId: String, goToChat: Bool) {
        self.isLoadingLostPetFromNotification = true
        
        Firestore.firestore().collection("Lost").document(lostPetId).getDocument { (DocumentSnapshot, Error) in

            if(Error == nil){
                let lostPet = try? DocumentSnapshot!.data(as: LostPet.self)
                if(lostPet != nil) {
                    self.selectedLostPet = lostPet
                    self.isOnLostPet = true
                    
                    if(goToChat){
                        self.isOnChat = true
                    }

                } else {
                    //todo show failed to load lost pet
                }
            } else {
                self.isLoadingLostPets = false
                //todo
            }
        }
        
        //todo load lost pet
    }
    
    func isOwnerOfLostPet() -> Bool {
        
        if let owners = selectedLostPet?.Owners {
            return owners.contains(Auth.auth().currentUser!.uid)
        }else {
            return false
        }
        
    }
    
    func getSelectedLostPet() {
        let selectedLostPetQuery = Firestore.firestore().collection("Lost").document((selectedLostPet?.id)!)

        selectedLostPetQuery.getDocument { (DocumentSnapshot, Error) in

            if(Error == nil) {
                let lostPet = try? DocumentSnapshot!.data(as: LostPet.self)
                self.selectedLostPet = lostPet
            } else {
                //todo
            }
        }
    }
    

    
    
    func shareLink() {
        var link = DynamicLinkGenerator().getShareLink(lostPetName: selectedLostPet!.name, lostPetId: selectedLostPet!.id!)
        
        switch link {
          case let .success(data):
            DispatchQueue.main.async {
            let activityVC = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
                activityVC.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2.1, y: UIScreen.main.bounds.height / 2.3, width: 200, height: 200)
                UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
            
            }
        case .failure(_):
            print("failure!")
            //todo show failed getting link
           }
    }
    
    func deepLinkToLostPet(lostPetId: String) {
        let lostPetDocument = Firestore.firestore().collection("Lost").document(lostPetId)
        
        lostPetDocument.getDocument { (DocumentSnapshot, Error) in

            if(Error == nil){
                self.selectedLostPet = try? DocumentSnapshot!.data(as: LostPet.self)
                self.isOnLostPet = true
                //todo navigate
            } else {
                //todo
            }
        }
    }
    

    
}


