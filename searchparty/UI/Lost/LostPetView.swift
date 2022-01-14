
import UIKit
import SwiftUI
import FirebaseStorage
import Kingfisher
import MapKit

struct LostPetView: View {
    
    @EnvironmentObject var modalManager: ModalManager
    @EnvironmentObject var searchPartyAppState: SearchPartyAppState
    @StateObject private var deleteLostPetViewModel = DeleteLostPetViewModel()
    @State var hasLostLocation = false
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State var lostPetForm: LostPetForm = LostPetForm()
    @State private var showingContactAlertPhoneNumber = false

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
        
    var body: some View {
        ZStack {
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
                            Image(PetImageTypes().getPetImageType(petType: searchPartyAppState.selectedLostPet!.type)).resizable()
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
                                            if(!foundPetDescription.isEmpty){
                                                Text("\"\(foundPetDescription)\"").fixedSize(horizontal: false, vertical: true)
                                            }
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
                            
                            if(searchPartyAppState.isOwnerOfLostPet()){
                                
                                NavigationLink(destination: MarkPetAsFound(), isActive: $searchPartyAppState.isOnLostPetIsFound) {
                                    
                                    
                                    TabBar(content: TabItem(name: "Mark Found", icon: "tag.circle")).onTapGesture {
                                        self.searchPartyAppState.isOnLostPetIsFound = true
                                        
                                    }
                                }
                            }
                            
                            TabBar(content: TabItem(name: "Flyer", icon: Constant.icon.doc)).onTapGesture {
                                
                                DispatchQueue.global().async { [self] in
                                    
                                    let pdfData = GenerateFlyerViewModelX(lostPet: searchPartyAppState.selectedLostPet!).createFlyer()
                                    
                                    DispatchQueue.main.async {
                                        let activityVC = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
                                        activityVC.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
                                        activityVC.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2.1, y: UIScreen.main.bounds.height / 2.3, width: 200, height: 200)

                                        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                                
                                    }
                                    
                                }
                            }

                            
                            TabBar(content: TabItem(name: "Chat", icon: Constant.icon.envelope)).onTapGesture {
                                self.searchPartyAppState.isOnChat = true
                                
                            }
                            
                            TabBar(content: TabItem(name: "Share Link", icon: Constant.icon.share)).onTapGesture {
                                DispatchQueue.global().async { [self] in

                                self.searchPartyAppState.shareLink()
                                    
                                }
                                
                            }
                            
                            NavigationLink(destination: AddLostPet(addLostPetViewModel: AddLostPetViewModel(lostPetForm: lostPetForm, isEditing: true)).environmentObject(searchPartyAppState), isActive: $searchPartyAppState.isOnEditingLostPet) {
                                
                            }
                            
                            
                            NavigationLink(destination: ChatView(), isActive: $searchPartyAppState.isOnChat) {

                            }
                            
                            
                        }.padding(.vertical)
                        
                        LostPetData.padding()
                        
                    }
                }
                
                
                
                
                
                
                VStack(alignment:.trailing) {
                    Spacer()
                    HStack {
                        Spacer()
                
                    Button(action: {
                        self.searchPartyAppState.isOnSearchParty = true
                    }) {

                        Image("flashlight_white").resizable()
                            .frame(width: 80, height: 80)
                            .background(Circle().fill(Constant.color.secondaryColor))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(color: .gray, radius: 3, x: 2, y: 2)
                            .padding().fullScreenCover(isPresented: self.$searchPartyAppState.isOnSearchParty) {
                                
                                SearchPartyView(lostPet: searchPartyAppState.selectedLostPet!)
                            }
                        
                    }
                
                    }
                }.onAppear {
                 
                        searchPartyAppState.isOnChat = true
                    
                }
                
                
                
                
            }
            
        }.alert(isPresented: $deleteLostPetViewModel.showDeleteWarning, content: {
            Alert(title: Text("Delete"), message: Text("Are you sure you want to delete your listing?"),
                  primaryButton: .destructive(Text("Delete")) {
                    deleteLostPetViewModel.deleteSelectedLostPet(lostPet: searchPartyAppState.selectedLostPet!){ result in

                        searchPartyAppState.isOnLostPet = false

                    }
                  },
                  secondaryButton: .cancel())
        }).navigationTitle("Lost: \(searchPartyAppState.selectedLostPet!.name)").frame(maxWidth: .infinity).onAppear {
            
            
            searchPartyAppState.getSelectedLostPet()
            
            if let lostLocation = searchPartyAppState.selectedLostPet?.lostLocation {
                
                let lostPetLocation = GeoHashConverter.decode(hash: lostLocation)
                
                let latitudeMin = lostPetLocation?.latitude.min
                let latitudeMax = lostPetLocation?.latitude.max

                let longitudeMin = lostPetLocation?.longitude.min
                let longitudeMax = lostPetLocation?.longitude.max

                let latitude = (latitudeMin! + latitudeMax!) / 2
                let longitude = (longitudeMin! + longitudeMax!) / 2
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                hasLostLocation = true
            }else {
                hasLostLocation = false
            }

        }.toolbar {
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if(searchPartyAppState.isOwnerOfLostPet()){
                    
                    Button(action: {
                        
                        self.lostPetForm = LostPetConverter.getLostPetFormFromLostPet(selectedLostPet: searchPartyAppState.selectedLostPet)
                        self.searchPartyAppState.isOnEditingLostPet = true
                        
                    }) { Image(systemName: "square.and.pencil") }
                    
                    Button(action: {
                        self.deleteLostPetViewModel.showDeleteWarning = true
                    }) { Image(systemName: "trash") }
                    
                }
            }
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
                    
                    if let lostDateTime = pet.lostDateTime {
                        Text("Lost Date").font(.caption)
                        Text(taskDateFormat.string(from: (lostDateTime.dateValue()))).padding(.bottom)
                    }
                    
                    if let lostLocationDescription = pet.lostLocationDescription, !lostLocationDescription.isEmpty {
                        Text("Lost Location").font(.caption)
                        Text(lostLocationDescription).padding(.bottom)
                    }
                    
                    if(hasLostLocation) {
                    Map(coordinateRegion: $region).disabled(true)
                        .frame(width: 200, height: 200).overlay(Image(PetImageTypes().getPetImageType(petType: searchPartyAppState.selectedLostPet?.type)).resizable().frame(width: 45.0, height: 45.0)).padding(.bottom)
                    }
                    
                    if let ownersName = pet.ownerName, !ownersName.isEmpty {
                        Text("Owners' Name").font(.caption)
                        Text(ownersName).padding(.bottom)
                    }
                    
                    if let ownerEmail = pet.ownerEmail, !ownerEmail.isEmpty {
                        Text("Owners' Email").font(.caption)
                        Button(ownerEmail) {
                            IosUtil.sendEmail(email: ownerEmail)
                        }.padding(.bottom)
                    }
                    
                    if let ownerPhoneNumber = pet.ownerPhoneNumber, !ownerPhoneNumber.isEmpty {
                        Text("Owners' Phone Number").font(.caption)
                    
                            Button(ownerPhoneNumber) {
                                showingContactAlertPhoneNumber.toggle()
                            }.padding(.bottom).confirmationDialog("Contact", isPresented: $showingContactAlertPhoneNumber) {
                                
                                    Button("Text " + ownerPhoneNumber) {
                                        IosUtil.sendMessage(phoneNumber: ownerPhoneNumber)
                                }
                                    Button("Call " + ownerPhoneNumber) {
                                        IosUtil.callPhone(phoneNumber: ownerPhoneNumber)
                                }

                                Button("Cancel", role: .cancel) {}
                            }
                        
                    }
                    
                    if let ownerOtherContactMethod = pet.ownerOtherContactMethod, !ownerOtherContactMethod.isEmpty {
                        Text("Other Contact Method").font(.caption)
                        Text(ownerOtherContactMethod).padding(.bottom)
                    }
                    
                    if let ownerPreferredContactMethod = pet.ownerPreferredContactMethod, !ownerPreferredContactMethod.isEmpty {
                        Text("Preferred Contact Method").font(.caption)
                        Text(LostPetConverter.getPreferredContactMethod(ownerPreferredContactMethod: ownerPreferredContactMethod)).padding(.bottom)
                    }
                    
                } else {
                    EmptyView()
                }
            }
    }
}

struct LostPetView_Previews: PreviewProvider {
    static var previews: some View {
        LostPetView()
    }
}
