
import UIKit
import SwiftUI
import FirebaseStorage
import Kingfisher

struct LostPetView: View {
    
    var tintColor: Color = Constant.color.tintColor
    @EnvironmentObject var modalManager: ModalManager
    @EnvironmentObject var searchPartyAppState: SearchPartyAppState
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
    
    private var numberOfImages = 5
    
    var body: some View {
        
        GeometryReader { proxy in
            
            ScrollView {
                
                VStack(alignment: .leading, spacing:0) {
                    
                    
                    if(searchPartyAppState.selectedLostPet!.generalImages.count>0) {
                        TabView {
                            
                            ForEach(searchPartyAppState.selectedLostPet!.generalImages, id: \.self) { image in
                                SingleLostPetImage(url: image, lostPetId: (searchPartyAppState.selectedLostPet?.id!)!)
                            }
                            
                        }.tabViewStyle(PageTabViewStyle())
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                        .frame(width: proxy.size.width, height: proxy.size.height/2.5).id(searchPartyAppState.selectedLostPet!.generalImages.count)
                        
                    } else {
                        Image(PetImageTypes().getPetImageType(petType: searchPartyAppState.selectedLostPet!.type)!).resizable()
                            .aspectRatio(contentMode: .fit).clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding()
                            .frame(width: proxy.size.width, height: proxy.size.height/2.5)
                        
                    }
                    
                    if let foundPet = searchPartyAppState.selectedLostPet?.foundPet {
                        if(foundPet) {
                            
                            HStack {
                                
                                Image("error_icon").resizable().frame(width: 32.0, height: 32.0)
                                
                                VStack(alignment: .leading) {
                                    Text("\(searchPartyAppState.selectedLostPet!.name) has been found!")
                                    
                                    if let foundPetDescription = searchPartyAppState.selectedLostPet?.foundPetDescription{
                                        Text("\"\(foundPetDescription)\"").fixedSize(horizontal: false, vertical: true)
                                    }
                                    Spacer()
                                    
                                }.padding(.leading).padding(.trailing)
                                
                            }.foregroundColor(Color.white).frame(
                                minWidth: 0,
                                maxWidth: .infinity,
                                alignment: .bottomLeading
                            ).padding().background(Constant.color.tintColor)
                            
                        }
                    }
                    
                    
                    
                    HStack () {
                        
                        TabBar(content: TabItem(name: "Generate Flyer", icon: Constant.icon.doc)).onTapGesture {
                            
                            DispatchQueue.global().async { [self] in
                                
                                var pdfData = GenerateFlyerViewModelX(lostPet: searchPartyAppState.selectedLostPet!).createFlyer()
                                
                                DispatchQueue.main.async {
                                    let activityVC = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
                                    UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                                }
                                
                            }
                        }
                        
                        NavigationLink(destination: ChatView(), isActive: $searchPartyAppState.isOnChat) {
                            TabBar(content: TabItem(name: "Chat", icon: Constant.icon.person)).onTapGesture {
                                self.searchPartyAppState.isOnChat = true
                                
                            }
                        }
                        
                        if(searchPartyAppState.isOwnerOfLostPet()){

                        NavigationLink(destination: MarkPetAsFound(), isActive: $searchPartyAppState.isOnLostPetIsFound) {
                            TabBar(content: TabItem(name: "Mark Pet as Found", icon: Constant.icon.person)).onTapGesture {
                                self.searchPartyAppState.isOnLostPetIsFound = true
                                
                            }
                        }
                        }
                        
                        if(searchPartyAppState.isOwnerOfLostPet()){

                        NavigationLink(destination: AddLostPet().environmentObject(searchPartyAppState), isActive: $searchPartyAppState.isOnEditingLostPet) {
                            TabBar(content: TabItem(name: "Edit Pet", icon: Constant.icon.person)).onTapGesture {
                                self.searchPartyAppState.isOnEditingLostPet = true

                                
                            }
                        }
                        }
                        
                    }
                    
                    
                    Text("Lost: \(searchPartyAppState.selectedLostPet!.name)")
                        .fontWeight(.bold)
                        .font(.title).padding()
                    
                    RandomView
                    LostPetData.padding()
                    
                }
            }
            
        }.frame(maxWidth: .infinity).onAppear {
            searchPartyAppState.getSelectedLostPet()
        }
        
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
                
                
                
//                if(searchPartyAppState.isOwnerOfLostPet()){
//                    NavigationLink(destination: MarkPetAsFound(), isActive: $searchPartyAppState.isOnLostPetIsFound) {
//                        Button(action: {
//                            self.searchPartyAppState.isOnLostPetIsFound = true
//                        }) {
//                            Text("Mark Pet As Found")
//                        }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading, .trailing])
//                    }
//                }
                
                if let pet = searchPartyAppState.selectedLostPet {
                    
                    Button("Join Search Party") {
                        self.searchPartyAppState.isOnSearchParty.toggle()
                    }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading, .trailing]).fullScreenCover(isPresented: self.$searchPartyAppState.isOnSearchParty) {
                        
                        SearchPartyView(lostPet: pet)
                    }
                    
                }
                
                
//                if(searchPartyAppState.isOwnerOfLostPet()){
//
//                    NavigationLink(destination: AddLostPet().environmentObject(searchPartyAppState), isActive: $searchPartyAppState.isOnEditingLostPet) {
//                        Button(action: {
//                            self.searchPartyAppState.isOnEditingLostPet = true
//                        }) {
//                            Text("Edit Pet")
//                        }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading, .trailing])
//                    }
//                }
                
                NavigationLink(destination: AddLostPet().environmentObject(searchPartyAppState), isActive: $searchPartyAppState.isOnAddingLostPet) {
                    
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
