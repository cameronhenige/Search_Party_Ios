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
    //var petImagePages: [PetImagePage]
    
    @EnvironmentObject var modelData: ModelData

    
    private func getPetImagePagesFromPet(lostPetImages: [String]) -> [PetImagePage] {
        
        var petImagePages = [PetImagePage]()

        for url in lostPetImages {
            var petImage = PetImagePage(nameGiven: "dog")
            petImagePages.append(petImage)
        }

        return petImagePages

    }
    
    var body: some View {
        
        if(generalImages != nil && !generalImages!.isEmpty) {
            //            KFImage(pictureUrl)
            //                .resizable()
            //                .aspectRatio(contentMode: .fill).frame(minWidth: 0, maxWidth: .infinity)
            
                        
            PageView(pages: getPetImagePagesFromPet(lostPetImages: generalImages!).map {FeatureCard(landmark: $0.name)
                            
                        }).aspectRatio(3 / 2, contentMode: .fit)
                        .listRowInsets(EdgeInsets())
            
        }else{
            if(petType == "Dog"){
            Image("dog")
            }else if petType == "Cat" {
                Image("cat")
            }else if petType == "Bird" {
                Image("bird")
            }else {
                Image("maps_default_marker")

            }

            

        }
    }
}

//struct PetBackground_Previews: PreviewProvider {
//    static var previews: some View {
//        PetBackground(generalImages: nil, petType: "Dog")
//    }
//}
