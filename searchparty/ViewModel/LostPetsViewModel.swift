//
//  LostPetsViewModel.swift
//  searchparty
//
//  Created by Hannah Krolewski on 3/13/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class LostPetsViewModel: ObservableObject {

@Published var lostPets = [LostPet]()

    private var db = Firestore.firestore()
    
    func fetchLostPets() {
        db.collection("Lost").addSnapshotListener { (querySnapshot, error) in
        
            
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.lostPets = querySnapshot!.documents.compactMap { (document) -> LostPet? in
                return try? document.data(as: LostPet.self)
            }
        }
    }
    
}
