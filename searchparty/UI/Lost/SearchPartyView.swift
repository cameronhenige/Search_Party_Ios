//
//  SearchPartyView.swift
//  searchparty
//
//  Created by Hannah Krolewski on 3/21/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI
import MapKit
import BottomSheet
import Kingfisher


struct SearchPartyView: View {
    
    @EnvironmentObject var searchPartyAppState: SearchPartyAppState
    
    var lostPet: LostPet
    @StateObject var searchPartyViewModel = SearchPartyViewModel()

    enum CustomBottomSheetPosition: CGFloat, CaseIterable {
        case top = 0.975, middle = 0.4, bottom = 0.2
    }
    
    @State private var bottomSheetPosition: CustomBottomSheetPosition = .bottom
    
    @State var currentLocation: CLLocationCoordinate2D?
    
    @State var name = ""
        
    @State var map = MKMapView()
    @State private var showingContactAlert = false
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Title"), message: Text("Message"), buttons: [.default(Text("Call"), action: {
            print("here")
        })])
    }
    

    
    func doesOwnerHaveAContactMethod()-> Bool {
        return false //todo actually check this
    }

    
    var SearchingButtonText: some View {
        if(searchPartyViewModel.isSearching) {
            return Text("Stop")
        } else {
            return Text("Search")
        }
    }
    
    var body: some View {
        
        let taskDateFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter
        }()
        
        NavigationView {
        VStack {
            
            ZStack(alignment: .top) {
                
                NavigationLink(destination: SelectPrivacyLocations(showView: self.$searchPartyViewModel.isOnSelectPrivateAreasScreen), isActive: $searchPartyViewModel.isOnSelectPrivateAreasScreen) {
                    
                }
                
                SearchPartyMapView(map: self.$map, name: self.$name, isSearching: $searchPartyViewModel.isSearching, selectedDay: $searchPartyViewModel.selectedDay, coordinate: self.$currentLocation, searchPartyUsers: $searchPartyViewModel.searchPartyUsers, listOfPrivateGeoHashes: $searchPartyViewModel.listOfPrivateGeoHashes).edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    HStack {
                        Spacer()
                    Button(action: {
                        self.searchPartyAppState.isOnSearchParty = false
                    }) {
                        Text("X")
                    }.buttonStyle(PrimaryButtonStyle()).frame(width: 30, alignment: .trailing)
                    }.padding(.leading).padding(.top).padding(.trailing)
                    

                    if(searchPartyViewModel.listOfDays.count > 0) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            ZStack {
                                LazyHStack {
                                        DateText(text: "All", isSelected: searchPartyViewModel.selectedDay == nil).onTapGesture {
                                            searchPartyViewModel.selectedDay = nil
                                        }

                                    ForEach(searchPartyViewModel.listOfDays, id: \.self) { day in
                                        
                                        DateText(text: String(taskDateFormat.string(from: day)), isSelected: searchPartyViewModel.selectedDay == day).onTapGesture {
                                            searchPartyViewModel.selectedDay = day
                                        }
                                        
                                    }
                                    
                                }.background(Color.white)
                                
                            }.frame(height: 50).clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous)).padding()
                        }.flipsForRightToLeftLayoutDirection(true)
                        .environment(\.layoutDirection, .rightToLeft)
                    }
                    
                    if(searchPartyViewModel.isInsideOfAPrivateGeoHash){
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(Color.white)
                            Text("Leave the privacy square to start searching").foregroundColor(Color.red)
                            
                            
                        }.frame(height: 50, alignment: .top).padding().padding(.top)
                    }
                }
            }
        }.bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, hasBottomPosition: false, content: {
            VStack {
                
                HStack {
                    
                    if(searchPartyViewModel.pictureUrl != nil) {
                        KFImage(searchPartyViewModel.pictureUrl).resizing(referenceSize: CGSize(width: 100, height: 100))
                                .frame(width: 100.0, height: 100.0).cornerRadius(15)
                    }else{
                        Image(PetImageTypes().getPetImageType(petType: lostPet.type)).resizable()
                            .frame(width: 100.0, height: 100.0)
                    }
                    
                    Text(lostPet.name)
                    Spacer()
                    Button(action: {
                        searchPartyViewModel.startUpdatingLocationButtonAction()
                    }) {

                        SearchingButtonText
                        
                    }.buttonStyle(PrimaryButtonStyle()).frame(width: 150)
                    
                }
                

                Button(action: {
                    showingContactAlert.toggle()
                }) {
                    Text("Contact Owner")
                
                }.buttonStyle(PrimaryButtonStyle()).confirmationDialog("Contact Owner", isPresented: $showingContactAlert) {
                    
                    if(doesOwnerHaveAContactMethod()){
                    
                    if(searchPartyViewModel.lostPet?.ownerEmail != nil && !(searchPartyViewModel.lostPet?.ownerEmail!.isEmpty)!){
                        Button((searchPartyViewModel.lostPet?.ownerEmail)!) {
                            IosUtil.sendEmail(email: (searchPartyViewModel.lostPet?.ownerEmail)!)
                    }
                    }
                    
                    if(searchPartyViewModel.lostPet?.ownerPhoneNumber != nil && !(searchPartyViewModel.lostPet?.ownerPhoneNumber!.isEmpty)!){
                        Button("Text " + (searchPartyViewModel.lostPet?.ownerPhoneNumber)!) {
                            IosUtil.sendMessage(phoneNumber: (searchPartyViewModel.lostPet?.ownerPhoneNumber)!)
                    }
                        
                        Button("Call " + (searchPartyViewModel.lostPet?.ownerPhoneNumber)!) {
                            IosUtil.callPhone(phoneNumber: (searchPartyViewModel.lostPet?.ownerPhoneNumber)!)
                    }
                    }
                    } else {

                        Button("Owner has not added any contact methods") {
                            
                        }
                    }

                    Button("Cancel", role: .cancel) {}
                }
                                    
                ScrollView {
                    Text("People Searching").padding(.vertical)
                    
                    ForEach(searchPartyViewModel.searchPartyUsers) { user in
                        Text(String("User"))
                        
                        Text(String(user.name ?? "Private")).foregroundColor(Color(UIColor(hexString: user.color!)))
                        
                    }.frame(maxWidth: .infinity)
                    
                }
                
            }.padding(.horizontal)
            
            
        }).navigationBarTitle(Text(""), displayMode: .inline).onAppear() {
            self.searchPartyViewModel.fetchData(lostPet: lostPet)
            

            
        }
        

            
        }
        
        

        
        
    }
    
    
    struct DateText: View {
        var text: String
        var isSelected: Bool

        var body: some View {
            
            if(isSelected){
                Text(text).foregroundColor(.white).rotation3DEffect(Angle(degrees: 180), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0))).padding().background(Constant.color.tintColor)

            }else {
                Text(text).foregroundColor(Constant.color.tintColor).rotation3DEffect(Angle(degrees: 180), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0))).padding()

            }
        }
    }
    
    
    
    
}

struct SearchPartyView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPartyView(lostPet: LostPet(id: "TestContent", name: "Fido", sex: "TestContent", age: 3, chatSize: 3, breed: "TestContent", type: "TestContent", description: "TestContent", uniqueMarkings: "TestContent", temperament: "TestContent", healthCondition: "TestContent", generalImages: ["TestContent"], lostDateTime: nil, lostLocation: "TestContent", lostLocationDescription: "TestContent", ownerName: "TestContent", ownerEmail: "TestContent", ownerPhoneNumber: "TestContent", ownerOtherContactMethod: "TestContent", ownerPreferredContactMethod: "TestContent", foundPetDescription: "TestContent", foundPet: true, Owners: ["TestContent"]))
    }
}
