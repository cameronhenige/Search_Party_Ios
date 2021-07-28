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
    var height: CGFloat
    @State var pictureUrl: URL?
    @State var hasPicture: Bool = false
    var description: String?
    
    var body: some View {
        Card{
            VStack(){
                HStack() {
                    VStack(alignment: .leading) {
                        if (lostPet.getLostDate() != nil ){
                            Text((lostPet.getLostDate())!.uppercased())
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .opacity(0.6)
                        }
                        if (lostPet.getLostLocationDescription() != nil ){
                            Text((lostPet.getLostLocationDescription())!.uppercased())
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .opacity(0.6)
                        }
                        Text(lostPet.name)
                            .fontWeight(.bold)
                            .font(.title)
                    }
                    Spacer()
                }.padding()
                
                
                Spacer()
                
                ZStack {
                    if let foundPet = lostPet.foundPet {
                        if(foundPet) {
                            
                            HStack {
                                
                                Image("error_icon").resizable().frame(width: 32.0, height: 32.0)
                                
                                Text("\(lostPet.name) has been found!").padding(.leading).padding(.trailing)
                            
                            }.foregroundColor(Color.white).frame(
                                minWidth: 0,
                                maxWidth: .infinity,
                                alignment: .bottomLeading
                              ).padding().background(Constant.color.tintColor)
                            
                        }
                    }
                }

                
            }
            
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

struct CardWithBackground_Previews: PreviewProvider {
    static var previews: some View {
        CardWithBackground(lostPet: LostPet(id: "id", name: "Tom", sex: "male", age: 5, chatSize: 3, breed: "Maine Coon", type: "cat", description: "Good pet", uniqueMarkings: "None", temperament: "Nice", healthCondition: "Good", generalImages: [], lostDateTime: nil, lostLocation: "Mexico", lostLocationDescription: "Near Mexico", ownerName: "Cam", ownerEmail: "Cam@g.com", ownerPhoneNumber: "123455678", ownerOtherContactMethod: "Facebook", ownerPreferredContactMethod: "phon", foundPetDescription: "Found the pet", foundPet: true, Owners: []), height: 400.0)
    }
}
