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
    var pictureUrl: URL?
    var hasPicture: Bool = false
    var petType: String?

    var body: some View {
        
        if(hasPicture){
            KFImage(pictureUrl)
                .resizable()
                      .aspectRatio(contentMode: .fill)
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

struct PetBackground_Previews: PreviewProvider {
    static var previews: some View {
        PetBackground(pictureUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/react-native-e.appspot.com/o/f18c2d27ce297526d53da71a2386d229f4b1bed4.png?alt=media&token=cf79a3a7-ce7c-4307-a874-27be6f3f1dc1"), petType: "Dog")
    }
}
