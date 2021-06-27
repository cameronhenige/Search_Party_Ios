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

struct SearchPartyView: View {
    

    @EnvironmentObject var searchPartyAppState: SearchPartyAppState

    var lostPet: LostPet

    @ObservedObject var searchPartyViewModel = SearchPartyViewModel()

    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    enum CustomBottomSheetPosition: CGFloat, CaseIterable {
        case top = 0.975, middle = 0.4, bottom = 0.165
    }
    
    @State private var bottomSheetPosition: CustomBottomSheetPosition = .bottom

    @State var currentLocation: CLLocationCoordinate2D?

    @State var name = ""

    @State var map = MKMapView()

    var SearchingButtonText: some View {
                        if(searchPartyViewModel.isSearching) {
                            return Text("Stop")
                        } else {
                            return Text("Search")
                        }
    }
    
    var body: some View {
        
        NavigationLink(destination: AddHouseLocation(), isActive: $searchPartyViewModel.isOnAddHomeScreen) {

        }
        
        
        let taskDateFormat: DateFormatter = {
                let formatter = DateFormatter()
            formatter.dateStyle = .short
                return formatter
            }()
            VStack {

                ZStack(alignment: .top) {
                

                    
                    SearchPartyMapView(map: self.$map, name: self.$name, isSearching: $searchPartyViewModel.isSearching, coordinate: self.$currentLocation, searchPartyUsers: $searchPartyViewModel.searchPartyUsers, listOfPrivateGeoHashes: $searchPartyViewModel.listOfPrivateGeoHashes)
                                        
                    
                    VStack {
                        
                        
                        Button(action: {
                            self.searchPartyAppState.isOnSearchParty = false
                        }) {
                            Text("X")
                        }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading, .trailing])
                        
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        ZStack {
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .fill(Color.white)
                                LazyHStack {
                                    ForEach(searchPartyViewModel.listOfDays, id: \.self) { day in
                                        Text(String(taskDateFormat.string(from: day))).padding()
                                    }
                                    
                                }
                            
                        }.frame(height: 50, alignment: .top).padding()
                        
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
                    Image("cat").resizable()
                        .frame(width: 100.0, height: 100.0)

                    Text(lostPet.name)
                    Spacer()
                    Button(action: {
                        searchPartyViewModel.startUpdatingLocationButtonAction()
                    }) {

                        
                    
                        SearchingButtonText
                        
                    }.buttonStyle(PrimaryButtonStyle()).frame(width: 150)
                    
                }
                
                    Button(action: {
                        //todo contact searchPartyViewModel.startUpdatingLocationButtonAction()
                    }) {

                        Text("Contact Owner")
                        
                    }.buttonStyle(PrimaryButtonStyle())
            
                        ScrollView {
//                            ForEach(0..<100) { index in
//                                Text(String(index))
//                            }
//                            .frame(maxWidth: .infinity)
                            Text("People Searching").padding(.vertical)

                            ForEach(searchPartyViewModel.searchPartyUsers) { user in
                                Text(String("User"))

                                Text(String(user.name ?? "Private")).foregroundColor(Color(UIColor(hexString: user.color!)))

                            }.frame(maxWidth: .infinity)
                            
                        }
            
            }.padding(.horizontal)
            
            
                    }).onAppear() {
                        self.searchPartyViewModel.fetchData(lostPet: lostPet)
                      }

        
    }
}

struct SearchPartyView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPartyView(lostPet: LostPet(id: "TestContent", name: "Fido", sex: "TestContent", age: 3, chatSize: 3, breed: "TestContent", type: "TestContent", description: "TestContent", uniqueMarkings: "TestContent", temperament: "TestContent", healthCondition: "TestContent", generalImages: ["TestContent"], lostDateTime: nil, lostLocation: "TestContent", lostLocationDescription: "TestContent", ownerName: "TestContent", ownerEmail: "TestContent", ownerPhoneNumber: "TestContent", ownerOtherContactMethod: "TestContent", ownerPreferredContactMethod: "TestContent", foundPetDescription: "TestContent", foundPet: true, Owners: ["TestContent"]))
    }
}
