//
//  PetBackgroundSingle.swift
//  searchparty
//
//  Created by Hannah Krolewski on 4/29/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI
import Kingfisher

struct PetBackgroundSingle: View {
    var pictureUrl: URL?
    var hasPicture: Bool = false
    var petType: String?

    var body: some View {
        
        if(hasPicture){
            KFImage(pictureUrl)
                .resizable()
                .aspectRatio(contentMode: .fill).frame(minWidth: 0, maxWidth: .infinity)
            
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

//struct PetBackgroundSingle_Previews: PreviewProvider {
//    static var previews: some View {
//        PetBackground(generalImages: nil, petType: "Dog")
//    }
//}
