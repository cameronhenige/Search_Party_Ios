//
//  PetBackground.swift
//  searchparty
//
//  Created by Hannah Krolewski on 3/14/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI
import Kingfisher

struct PetBackground: View {
    var generalImages: [String]?
    var hasPicture: Bool = false
    var petType: String?
    var lostPetId: String
    
    
    private func getPetImagePagesFromPet(lostPetImages: [String]) -> [PetImagePage] {
        
        var petImagePages = [PetImagePage]()

        for url in lostPetImages {
            var petImage = PetImagePage(url: url)
            petImagePages.append(petImage)
        }

        return petImagePages

    }
    
    var body: some View {
        
        if(generalImages != nil && !generalImages!.isEmpty) {

                        
            PageView(pages: getPetImagePagesFromPet(lostPetImages: generalImages!).map {SingleLostPetImage(url: $0.url, lostPetId: lostPetId)
                            
                        }).aspectRatio(3 / 2, contentMode: .fit)
                        .listRowInsets(EdgeInsets())
            
        }else{
            Image(PetImageTypes().getPetImageType(petType: petType)!)
        }
    }
}

//struct PetBackground_Previews: PreviewProvider {
//    static var previews: some View {
//        PetBackground(generalImages: nil, petType: "Dog")
//    }
//}
