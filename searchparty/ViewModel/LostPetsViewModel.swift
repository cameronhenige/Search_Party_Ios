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
            
            print(querySnapshot?.documents[1].data())
            print(try! querySnapshot?.documents[1].data(as: LostPet.self)!)

            
//            self.lostPets =
//                try documents.flatMap {
//                    try $0.data(as: JStoreUser.self)
//                }
            
            
            
//            self.lostPets = documents
//                .flatMap { document -> LostPet in
//
//                    return try! document.data(as: LostPet.self)!
//                }
            
            self.lostPets = querySnapshot!.documents.compactMap { (document) -> LostPet? in
                return try? document.data(as: LostPet.self)
            }
//            self.lostPets.append(LostPet(id: "alskdjm", name: "ldsjf", sex: nil, age: nil, chatSize: nil, breed: nil, type: nil, description: nil, uniqueMarkings: nil, temperament: nil, healthCondition: nil, generalImages: nil, lostLocation: nil, lostLocationDescription: nil, ownerName: "v", ownerEmail: nil, ownerPhoneNumber: nil, ownerOtherContactMethod: nil, ownerPreferredContactMethod: nil, foundPetDescription: "", foundPet: nil, Owners: nil))
//
//
        
        }
    }
    
}
