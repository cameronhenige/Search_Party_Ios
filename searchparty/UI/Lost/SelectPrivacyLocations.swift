//
//  AddHouseLocation.swift
//  searchparty
//
//  Created by Hannah Krolewski on 6/14/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI
import MapKit

struct SelectPrivacyLocations: View {
    @Binding var showView : Bool
    @State var isOnLostPetIsFound = false
    @State var map = MKMapView()
    @State var currentLocation: CLLocationCoordinate2D?
    @State var mapCenter: CLLocationCoordinate2D?
    @ObservedObject private var addHouseLocationViewModel = SelectPrivacyLocationsViewModel()

    var AddRemoveButton: some View {
        
        if(addHouseLocationViewModel.disabledLocationHashes.contains((map.centerCoordinate.geohash(length: 7)))) {
            return Button("Remove", action: {
                addHouseLocationViewModel.removeUserLocation(geoHash: map.centerCoordinate.geohash(length: 7))
            }).frame(minWidth: 100, minHeight: 44).background(Constant.color.tintColor)
                .foregroundColor(Color(.white))
                .clipShape(Capsule()).padding()
        } else {


            return Button("Add", action: {
                self.addHouseLocationViewModel.saveHomeLocation(geoHash: map.centerCoordinate.geohash(length: 7))

            }).frame(minWidth: 100, minHeight: 44).background(Constant.color.tintColor)
                .foregroundColor(Color(.white))
                .clipShape(Capsule()).padding()
        }

    }
    
    var body: some View {

        VStack {

            if(addHouseLocationViewModel.isLoadingUserLocation) {
                ProgressView()
                Text("Finding Location")
            } else {
                
            
            ZStack(alignment: .top) {

        if(addHouseLocationViewModel.userLocation != nil) {

            SelectPrivacyLocationsMapView(map: self.$map, mapCenter: $mapCenter, disabledLocationHashes: $addHouseLocationViewModel.disabledLocationHashes, initialLocation: addHouseLocationViewModel.userLocation!).overlay(AddRemoveButton, alignment: .bottomTrailing).overlay(Image("dot").resizable().frame(width: 45.0, height: 45.0))
        }
                
            }
            
            ZStack(alignment: .bottom) {
                VStack {
                    Text("Please select areas where Search Party shouldn't track you when searching.").foregroundColor(.black).padding(.bottom)

                        Button(action: {
                            showView = false
                        }) {
                            if(addHouseLocationViewModel.disabledLocationHashes.isEmpty) {
                                Text("Skip")
                            } else {
                                Text("Done")
                            }
                            
                        
                        }.buttonStyle(PrimaryButtonStyle())
                    
                    
                }.padding()
                
            }
                
            }

            
            
        }.navigationBarTitle(Text("Select Private Areas"), displayMode: .inline)

    }
}

struct AddHouseLocation_Previews: PreviewProvider {
    static var previews: some View {
        SelectPrivacyLocations(showView: .constant(true))
    }
}
