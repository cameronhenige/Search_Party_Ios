//
//  LostPet.swift
//  searchparty
//
//  Created by Hannah Krolewski on 3/13/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

struct LostPet: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String

    var sex: String?
    var age: Int?
    var chatSize: Int?
    var breed: String?
    var type: String?
    var description: String?
    var uniqueMarkings: String?
    var temperament: String?
    var healthCondition: String?
    var generalImages: [String]?
    //var lostDateTime: FIRTimestamp?
    var lostLocation: String?
    var lostLocationDescription: String?
    var ownerName: String?
    var ownerEmail: String?
    var ownerPhoneNumber: String?
    var ownerOtherContactMethod: String?
    var ownerPreferredContactMethod: String?
    var foundPetDescription: String?
    var foundPet: Bool?
    var Owners: [String]?
    
}
