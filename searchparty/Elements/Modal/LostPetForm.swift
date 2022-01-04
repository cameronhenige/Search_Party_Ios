//
//  LostPetForm.swift
//  searchparty
//
//  Created by Hannah Krolewski on 1/4/22.
//  Copyright © 2022 Filip Molcik. All rights reserved.
//

import Foundation

struct LostPetForm {
    var petName = ""
    var lostDate = Date()
    var name = ""
    var phoneNumber = ""
    var email = ""
    var otherContactMethod = ""
    var petAge: String = ""
    var petBreed = ""

    var images : [SelectedImage] = []
    var petDescription: String = ""
    var petType: Int = 0
    var petSex: Int = 0
    var preferredContactMethod: Int = 0
    var lostLocationDescription = ""

    func getPreferredContactMethodApiString() -> String {
        switch preferredContactMethod {
        case 0:
            return "phoneNumber"
        case 1:
            return "email"
        case 2:
            return "other"
        default:
            return "phoneNumber"
        }
    }
    
    func getPetSexString() -> String {
        switch petSex {
        case 0:
            return "Male"
        case 1:
            return "Female"
        default:
            return "Male"
        }
    }
    
    func getPetTypeString() -> String {
        switch petType {
        case 0:
            return "Dog"
        case 1:
            return "Cat"
        case 2:
            return "Bird"
        case 3:
            return "Other"
        default:
            return "Other"
        }
    }
    
}
