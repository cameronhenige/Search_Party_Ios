//
//  RecipeRow.swift
//  sketch-elements
//
//  Created by Filip Molcik on 29/02/2020.
//  Copyright © 2020 Filip Molcik. All rights reserved.
//

import SwiftUI
import FirebaseStorage
import Kingfisher

struct CardWithBackground: View {

    var lostPet: LostPet
    var title: String
    var subTitle: String?
    var subSubTitle: String?
    var height: CGFloat
    @State var pictureUrl: URL?
    @State var hasPicture: Bool = false

    var description: String?
    
    var body: some View {
        Card{
            VStack(){
                HStack() {
                    VStack(alignment: .leading) {
                        if (subTitle != nil ){
                            Text((subTitle!).uppercased())
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .opacity(0.6)
                        }
                        if (subSubTitle != nil ){
                            Text((subSubTitle!).uppercased())
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .opacity(0.6)
                        }
                        Text(title)
                            .fontWeight(.bold)
                            .font(.title)
                    }
                    Spacer()
                }
                Spacer()

                
            }
            .padding(.all)
            .background(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0), Color.black.opacity(0), Color.black.opacity(description != nil ? 0.3 : 0)]), startPoint: .top, endPoint: .bottom))
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .foregroundColor(Color.white)
            .background(
                PetBackgroundSingle(pictureUrl: self.pictureUrl, hasPicture: self.hasPicture, petType: lostPet.type)
            )

        }.onAppear {
            
            if(lostPet.generalImages != nil && !lostPet.generalImages.isEmpty){
                hasPicture = true
                let storageLocation : String = "Lost/" + lostPet.id! + "/generalImages/" + lostPet.generalImages[0]
                let storage = Storage.storage().reference().child(storageLocation)
                storage.downloadURL { (URL, Error) in
                    if(Error != nil){
                        print(Error?.localizedDescription)
                        return
                    }
                    pictureUrl = URL
                }
            }else{
                hasPicture = false
            }
        }
    }
}

//struct CardWithBackground_Previews: PreviewProvider {
//    static var previews: some View {
////        CardWithBackground(
////            title: recipesData[0].title,
////            subTitle: recipeCategoriesData[0].subtitle,
////            height: 300.0,
////            pictureUrl: recipesData[0].picture.uri,
////            description: "\(recipesData[0].minutes) minutes")
////            .environmentObject(UserData())
//    }
//}
