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
    @EnvironmentObject var modalManager: ModalManager
    
    @State var isOnSearchParty = false
    @State var isOnLostPetIsFound = false
    @State var isOnChat = false
    @State var isOnEditPet = false
    @State var selectedView = 1
    @State private var isPresented = false
    
    private func goToSearchParty() {
        self.isPresented.toggle()
    }
    
    private func markPetAsFound() {
            //todo
    }
    
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
                        
                        HStack {
                            Button(action: {
                                self.isOnLostPetIsFound = true
                            }) {
                                Text("Generate Flyer")
                            }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading])
                            
                        
                            NavigationLink(destination: ChatScreen(), isActive: $isOnChat) {
                                Button(action: {
                                    self.isOnChat = true
                                }) {
                                    Text("Chat")
                                }.buttonStyle(PrimaryButtonStyle()).padding([.top, .trailing])
                            }
                            
                            

                        }
                        
                        
                        NavigationLink(destination: MarkPetAsFound(), isActive: $isOnLostPetIsFound) {
                            Button(action: {
                                self.isOnLostPetIsFound = true
                            }) {
                                Text("Mark Pet As Found")
                            }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading, .trailing])
                        }

                        
                        
                        NavigationLink(destination: SearchPartyView(), isActive: $isOnSearchParty) {
                            Button(action: {
                                self.isOnSearchParty = true
                            }) {
                                Text("Join Search Party")
                            }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading, .trailing])
                        }
                        
                        NavigationLink(destination: EditLostPet(), isActive: $isOnEditPet) {
                            Button(action: {
                                self.isOnEditPet = true
                            }) {
                                Text("Edit Pet")
                            }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading, .trailing])
                        }


                        VStack(alignment: .leading) {

                            if let description = lostPet.description, !description.isEmpty {
                                Text(description).padding(.bottom)
                            }
                            
                            if let type = lostPet.type, !type.isEmpty {
                                Text("Pet Type").font(.caption)
                                Text(type).padding(.bottom)
                            }
                            
                            if let lostLocationDescription = lostPet.lostLocationDescription, !lostLocationDescription.isEmpty {
                                Text("Lost Location").font(.caption)
                                Text(lostLocationDescription).padding(.bottom)
                            }
                            
                            if let lostDateTime = lostPet.lostDateTime {
                                Text("Lost Date").font(.caption)
                                Text("Todo").padding(.bottom)
                            }
                            
                            if let ownersName = lostPet.ownerName, !ownersName.isEmpty {
                                Text("Owners' Name").font(.caption)
                                Text(ownersName).padding(.bottom)
                            }
                            
                            if let ownerEmail = lostPet.ownerEmail, !ownerEmail.isEmpty {
                                Text("Owners' Email").font(.caption)
                                Text(ownerEmail).padding(.bottom)
                            }
                            
                            if let ownerPhoneNumber = lostPet.ownerPhoneNumber, !ownerPhoneNumber.isEmpty {
                                Text("Owners' Phone Number").font(.caption)
                                Text(ownerPhoneNumber).padding(.bottom)
                            }
                            
                            if let ownerOtherContactMethod = lostPet.ownerOtherContactMethod, !ownerOtherContactMethod.isEmpty {
                                Text("Other Contact Method").font(.caption)
                                Text(ownerOtherContactMethod).padding(.bottom)
                            }
                            
                            if let ownerPreferredContactMethod = lostPet.ownerPreferredContactMethod, !ownerPreferredContactMethod.isEmpty {
                                Text("Preferred Contact Method").font(.caption)
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