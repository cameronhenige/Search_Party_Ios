//
//  LostPetConverter.swift
//  searchparty
//
//  Created by Hannah Krolewski on 1/4/22.
//  Copyright © 2022 Filip Molcik. All rights reserved.
//

import Foundation

class LostPetConverter {
    
    
    class func getLostPetFormFromLostPet(selectedLostPet: LostPet?) -> LostPetForm {
        
        var images : [SelectedImage] = []
        if let tempExistingImages = selectedLostPet?.generalImages {
                            for existingImage in tempExistingImages {
                                let existingImageString = SelectedImage(name: existingImage, isExisting: true, image: nil)
                                images.append(existingImageString)
                            }
                        }
        
        let petAge = selectedLostPet?.age?.description ?? ""
        
        return LostPetForm(petName: selectedLostPet?.name ?? "", lostDate: selectedLostPet?.lostDateTime?.dateValue() ?? Date(), name: selectedLostPet?.name ?? "", phoneNumber: selectedLostPet?.ownerPhoneNumber ?? "", email: selectedLostPet?.ownerEmail ?? "", otherContactMethod: selectedLostPet?.ownerOtherContactMethod ?? "", petAge: petAge, petBreed: selectedLostPet?.breed ?? "", images: images, petDescription: selectedLostPet?.description ?? "", petType: LostPetConverter.getPetTypeFromLostPet(petType: selectedLostPet?.type), petSex: LostPetConverter.getPetSexFromLostPet(sex: selectedLostPet?.sex), preferredContactMethod: LostPetConverter.getPreferredContactMethod(method: selectedLostPet?.ownerPreferredContactMethod ?? ""), lostLocationDescription: selectedLostPet?.lostLocationDescription ?? "")
    }
    
    class func getPreferredContactMethod(method: String) -> Int {
        switch method {
        case "phoneNumber":
            return 0
        case "email":
            return 1
        case "other":
            return 2
        default:
            return 0
        }
    }
    
    class func getPreferredContactMethod(ownerPreferredContactMethod: String) -> String{
        switch ownerPreferredContactMethod {
        case "phoneNumber":
            return "Phone Number"
        case "email":
            return "Email"
        case "other":
            return "Other"
        default:
            return "Other"
        }
    }
    
    class func getPetSexFromLostPet(sex: String?) -> Int {
        switch sex {
        case "Male":
            return 0
        case "Female":
            return 1
        default:
            return 0
        }
    }
    
    class func getPetTypeFromLostPet(petType: String?) -> Int {
        switch petType {
        case "Dog":
            return 0
        case "Cat":
            return 1
        case "Bird":
            return 2
        case "Other":
            return 3
        default:
            return 0
        }
    }
}
