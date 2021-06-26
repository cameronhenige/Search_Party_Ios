//
//  LostPet.swift
//  searchparty
//
//  Created by Hannah Krolewski on 3/13/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct LostPet: Codable, Identifiable, Hashable {
    
    public static var NAME : String = "name"
    public static var SEX : String = "sex"
    public static var AGE : String = "age"
    public static var BREED : String = "breed"
    public static var TYPE : String = "type"
    public static var DESCRIPTION : String = "description"
    public static var GENERAL_IMAGES : String = "generalImages"
    public static var LOST_DATE_TIME : String = "lostDateTime"
    public static var LOST_LOCATION : String = "lostLocation"
    public static var LOST_LOCATION_DESCRIPTION : String = "lostLocationDescription"
    public static var OWNER_NAME : String = "ownerName"
    public static var OWNER_EMAIL : String = "ownerEmail"
    public static var OWNER_PHONE_NUMBER : String = "ownerPhoneNumber"
    public static var OWNER_PREFERRED_CONTACT_METHOD : String = "ownerPreferredContactMethod"
    public static var OWNER_OTHER_CONTACT_METHOD : String = "ownerOtherContactMethod"
    public static var OWNERS : String = "Owners"

    
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
    var lostDateTime: Timestamp?
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
