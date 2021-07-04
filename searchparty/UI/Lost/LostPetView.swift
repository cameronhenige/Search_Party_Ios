
import UIKit
import SwiftUI
import FirebaseStorage
import Kingfisher

struct LostPetView: View {

    var tintColor: Color = Constant.color.tintColor
    @EnvironmentObject var modalManager: ModalManager
    @EnvironmentObject var searchPartyAppState: SearchPartyAppState
    @ObservedObject var generateFlyerViewModel = GenerateFlyerViewModel()
    @State var isOnLostPetIsFound = false
    @State var isOnEditPet = false
    @State var selectedView = 1
    @State private var isPresented = false
    @State var pictureUrl: URL?
    @State var hasPicture: Bool = false
    @State private var isShareFlyerPresented: Bool = false
    let taskDateFormat: DateFormatter = {
            let formatter = DateFormatter()
        formatter.dateStyle = .short
            return formatter
        }()
    
    private func goToSearchParty() {
        self.isPresented.toggle()
    }
    
    private func markPetAsFound() {
            //todo
    }
    

    
    var body: some View {
        return
            ZStack(alignment: .top) {

                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(alignment: .center, spacing: 0, content: {

                            

                        
                        if let pet = searchPartyAppState.selectedLostPet {
                                PetBackground(generalImages: pet.generalImages, hasPicture: self.hasPicture, petType: pet.type, lostPetId: pet.id!)
                            
                                                    Text(pet.name)
                                                        .fontWeight(.bold)
                                                        .font(.title).padding(.top)
                            
                        } else {
                            EmptyView()
                        }
                        
                    })
                    
                    VStack(alignment: .leading, spacing:0) {
                        

                        
                        RandomView

                        LostPetData.padding()

                    }
                }
            }
            .frame(maxWidth: .infinity)
    }
    
    var LostPetData: some View {
        return
            VStack(alignment: .leading) {
        if let pet = searchPartyAppState.selectedLostPet {
                            if let description = pet.description, !description.isEmpty {
                                Text(description).padding(.bottom)
                            }
                            
                            if let type = pet.type, !type.isEmpty {
                                Text("Pet Type").font(.caption)
                                Text(type).padding(.bottom)
                            }
            
                            if let lostLocationDescription = pet.lostLocationDescription, !lostLocationDescription.isEmpty {
                                Text("Lost Location").font(.caption)
                                Text(lostLocationDescription).padding(.bottom)
                            }
            
                            if let lostDateTime = pet.lostDateTime {
                                Text("Lost Date").font(.caption)
                                Text(taskDateFormat.string(from: (lostDateTime.dateValue()))).padding(.bottom)
                            }
            
                            if let ownersName = pet.ownerName, !ownersName.isEmpty {
                                Text("Owners' Name").font(.caption)
                                Text(ownersName).padding(.bottom)
                            }
            
                            if let ownerEmail = pet.ownerEmail, !ownerEmail.isEmpty {
                                Text("Owners' Email").font(.caption)
                                Text(ownerEmail).padding(.bottom)
                            }
            
                            if let ownerPhoneNumber = pet.ownerPhoneNumber, !ownerPhoneNumber.isEmpty {
                                Text("Owners' Phone Number").font(.caption)
                                Text(ownerPhoneNumber).padding(.bottom)
                            }
            
                            if let ownerOtherContactMethod = pet.ownerOtherContactMethod, !ownerOtherContactMethod.isEmpty {
                                Text("Other Contact Method").font(.caption)
                                Text(ownerOtherContactMethod).padding(.bottom)
                            }
            
                            if let ownerPreferredContactMethod = pet.ownerPreferredContactMethod, !ownerPreferredContactMethod.isEmpty {
                                Text("Preferred Contact Method").font(.caption)
                                Text(ownerPreferredContactMethod).padding(.bottom)
                            }
            
        } else {
            EmptyView()
        }
        

                


                
            }
    }
    
    var RandomView: some View {
        return
            VStack{
            HStack {
            Button(action: {
                
                generateFlyerViewModel.generateFlyer(lostPet: searchPartyAppState.selectedLostPet!)
            }) {
                Text("Generate Flyer")
            }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading])
            
//            .sheet(isPresented: $generateFlyerViewModel.isShowingFlyer, onDismiss: {
//                print("Dismiss")
//            }, content: {
//                ActivityViewController(activityItems: [$generateFlyerViewModel.flyerURL])
//            })
            
                
                
        
                NavigationLink(destination: ChatView(), isActive: $searchPartyAppState.isOnChat) {
                Button(action: {
                    self.searchPartyAppState.isOnChat = true
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

                if let pet = searchPartyAppState.selectedLostPet {

        
                    NavigationLink(destination: SearchPartyView(lostPet: pet), isActive: $searchPartyAppState.isOnSearchParty) {
            Button(action: {
                self.searchPartyAppState.isOnSearchParty = true
            }) {
                Text("Join Search Party")
            }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading, .trailing])
        }
                    
//                    Button("Full Screen Join Search Party") {
//                        self.searchPartyAppState.isOnSearchParty.toggle()
//                            }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading, .trailing]).fullScreenCover(isPresented: self.$searchPartyAppState.isOnSearchParty) {
//
//                                SearchPartyView(lostPet: pet)
//                            }
                    
                    
                }
        
        NavigationLink(destination: EditLostPet(), isActive: $isOnEditPet) {
            Button(action: {
                self.isOnEditPet = true
            }) {
                Text("Edit Pet")
            }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading, .trailing])
        }
            }
    }
}

//
//struct LostPetView_Previews: PreviewProvider {
//    static var previews: some View {
//        LostPetView(lostPet: LostPet(id: "TestContent", name: "TestContent", sex: "TestContent", age: 3, chatSize: 3, breed: "TestContent", type: "TestContent", description: "TestContent", uniqueMarkings: "TestContent", temperament: "TestContent", healthCondition: "TestContent", generalImages: ["TestContent"], lostDateTime: nil, lostLocation: "TestContent", lostLocationDescription: "TestContent", ownerName: "TestContent", ownerEmail: "TestContent", ownerPhoneNumber: "TestContent", ownerOtherContactMethod: "TestContent", ownerPreferredContactMethod: "TestContent", foundPetDescription: "TestContent", foundPet: true, Owners: ["TestContent"]))
//    }
//}
