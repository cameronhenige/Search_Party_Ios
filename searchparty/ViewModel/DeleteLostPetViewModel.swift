//
//  DeleteLostPetViewModel.swift
//  searchparty
//
//  Created by Hannah Krolewski on 8/31/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import FirebaseFirestore

class DeleteLostPetViewModel: NSObject, ObservableObject {
    @Published var showDeleteWarning = false

    
    func deleteSelectedLostPet(lostPet: LostPet, completionHandler: @escaping (Result<String, Error>) -> Void) {
        let selectedLostPetDocument = Firestore.firestore().collection("Lost").document((lostPet.id)!)
        selectedLostPetDocument.delete() { err in
            if let err = err {
                //todo
                print("Error removing document: \(err)")
            } else {
                completionHandler(.success("Deleted Lost Pet"))
            }
        }
        
        
//        Firestore.firestore().collection("Lost").document("acds").delete { Error? in
//            if(Error == nil) {
//                self.isOnLostPet = false
//            }else {
//                //todo show error deleting lost pet.
//            }
//        }
    }
    
}
