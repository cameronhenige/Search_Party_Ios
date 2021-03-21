//
//  RestaurantDetail.swift
//  sketch-elements
//
//  Created by Filip Molcik on 30/06/2020.
//  Copyright © 2020 Filip Molcik. All rights reserved.
//

import SwiftUI

struct LostPetView: View {
    var lostPet: LostPet

    var tintColor: Color = Constant.color.tintColor
    //let gradient = LinearGradient(gradient: Gradient(colors: [.white, .clear]), startPoint: .top, endPoint: .bottom)
    @EnvironmentObject var modalManager: ModalManager
    
//    init() {
//        //self.restaurant = restaurant
//        //self.tintColor = tintColor
//    }
    
    var body: some View {
        return VStack(spacing: 0){


            
            ZStack(alignment: .top) {

                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(alignment: .center, spacing: 0, content: {
                        Image("dog")
                            .frame(height: 350.0)
                        Text(lostPet.name)
                            .fontWeight(.bold)
                            .font(.title)
                    })
                    
                    VStack(alignment: .leading, spacing:0) {
                        
//                        Header(image: restaurant.picture.uri, height: 223) {
//                            VStack(){
//                                Spacer()
//                                HStack(){
//                                    Text(restaurant.title)
//                                        .font(.largeTitle)
//                                        .fontWeight(.bold)
//                                    Spacer()
//                                }
//                            }
//                        }
                        

                        TabBar(
                            foregroundColor: tintColor,
                            content: [
                            TabItem(
                                name: "Generate Flyer", icon: Constant.icon.creditcard),
                            TabItem(
                                name: "Chat",
                                icon: Constant.icon.clock)
                        ])
                        ButtonPrimary(action: self.modalManager.openModal, backgroundColor: tintColor) {
                                Text("Mark Pet as Found")
                                    .font(.headline)
                            }.padding([.top, .leading, .trailing])

                        VStack(alignment: .leading) {

                            if let description = lostPet.description, !description.isEmpty {
                                Text(description).padding(.bottom)
                            }
                            
                            if let type = lostPet.type, !type.isEmpty {
                                Text("Pet Type")
                                Text(type).padding(.bottom)
                            }
                            
                            if let lostLocationDescription = lostPet.lostLocationDescription, !lostLocationDescription.isEmpty {
                                Text("Lost Location")
                                Text(lostLocationDescription).padding(.bottom)
                            }
                            
                            if let lostDateTime = lostPet.lostDateTime {
                                Text("Lost Date")
                                Text("Todo").padding(.bottom)
                            }
                            
                            if let ownersName = lostPet.ownerName, !ownersName.isEmpty {
                                Text("Owners' Name")
                                Text(ownersName).padding(.bottom)
                            }
                            
                            if let ownerEmail = lostPet.ownerEmail, !ownerEmail.isEmpty {
                                Text("Owners' Email")
                                Text(ownerEmail).padding(.bottom)
                            }
                            
                            if let ownerPhoneNumber = lostPet.ownerPhoneNumber, !ownerPhoneNumber.isEmpty {
                                Text("Owners' Phone Number")
                                Text(ownerPhoneNumber).padding(.bottom)
                            }
                            
                            if let ownerOtherContactMethod = lostPet.ownerOtherContactMethod, !ownerOtherContactMethod.isEmpty {
                                Text("Other Contact Method")
                                Text(ownerOtherContactMethod).padding(.bottom)
                            }
                            
                            if let ownerPreferredContactMethod = lostPet.ownerPreferredContactMethod, !ownerPreferredContactMethod.isEmpty {
                                Text("Preferred Contact Method")
                                Text(ownerPreferredContactMethod).padding(.bottom)
                            }
                            
                        }.padding()
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .background(Constant.color.gray)
        .edgesIgnoringSafeArea([.top])
        .navigationBarTitle("", displayMode: .large)
        .navigationBarItems(trailing: Image(systemName: Constant.icon.bookmark).foregroundColor(.white))
        .onAppear {
//            self.modalManager.newModal(position: .closed) {
//                ReservationModal(
//                    place: self.restaurant,
//                    timeOptions: ["19:00", "19:30", "20:00", "20:30"],
//
//                    tintColor: tintColor,
//                    action: self.modalManager.closeModal)
//            }
        }
    }
}


struct LostPetView_Previews: PreviewProvider {
    static var previews: some View {
        LostPetView(lostPet: LostPet(id: "TestContent", name: "TestContent", sex: "TestContent", age: 3, chatSize: 3, breed: "TestContent", type: "TestContent", description: "TestContent", uniqueMarkings: "TestContent", temperament: "TestContent", healthCondition: "TestContent", generalImages: ["TestContent"], lostDateTime: nil, lostLocation: "TestContent", lostLocationDescription: "TestContent", ownerName: "TestContent", ownerEmail: "TestContent", ownerPhoneNumber: "TestContent", ownerOtherContactMethod: "TestContent", ownerPreferredContactMethod: "TestContent", foundPetDescription: "TestContent", foundPet: true, Owners: ["TestContent"]))
    }
}
