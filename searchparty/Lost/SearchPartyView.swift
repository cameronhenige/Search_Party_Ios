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
    
    var lostPet: LostPet

    @ObservedObject var searchPartyViewModel = SearchPartyViewModel()

    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    //@State private var bottomSheetPosition: BottomSheetPosition = .middle

    enum CustomBottomSheetPosition: CGFloat, CaseIterable {
        case top = 0.975, middle = 0.4, bottom = 0.125
    }
    
    @State private var bottomSheetPosition: CustomBottomSheetPosition = .bottom

    @State var currentLocation: CLLocationCoordinate2D?

    //@State var initialLocation: CLLocationCoordinate2D
    @State var name = ""

    @State var map = MKMapView()

    var SearchingButtonText: some View {
                        if(searchPartyViewModel.isSearching) {
                            return Text("Stop Searching" )
                        } else {
                            return Text("Search for \(lostPet.name)" )
                        }
    }
    
    var body: some View {
            VStack {
                
                SearchPartyMapView(map: self.$map, name: self.$name, coordinate: self.$currentLocation, searchPartyUsers: $searchPartyViewModel.searchPartyUsers)
                
            }.bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, hasBottomPosition: false, content: {
            VStack {
            Button(action: {
                searchPartyViewModel.startUpdatingLocationButtonAction()
            }) {

                
                SearchingButtonText
                
            }.buttonStyle(PrimaryButtonStyle()).padding()
            
                        ScrollView {
//                            ForEach(0..<100) { index in
//                                Text(String(index))
//                            }
//                            .frame(maxWidth: .infinity)
                            
                            ForEach(searchPartyViewModel.searchPartyUsers) { user in
                                Text(String("User"))

                                Text(String(user.name ?? "Private")) //todo

                            }.frame(maxWidth: .infinity)
                            
                        }
            
            }
            
            
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
