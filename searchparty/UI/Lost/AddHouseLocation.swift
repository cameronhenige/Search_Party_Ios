//
//  AddHouseLocation.swift
//  searchparty
//
//  Created by Hannah Krolewski on 6/14/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI
import MapKit

struct AddHouseLocation: View {
    @Binding var showView : Bool

    @State var isOnLostPetIsFound = false

    @State var map = MKMapView()
    @State var currentLocation: CLLocationCoordinate2D?
    @ObservedObject private var addHouseLocationViewModel = AddHouseLocationViewModel()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    
    var AddRemoveButton: some View {
        
        if(addHouseLocationViewModel.disabledLocationHashes.contains((map.centerCoordinate.geohash(length: 7)))) {
            return Button(action: {
                addHouseLocationViewModel.removeUserLocation(geoHash: map.centerCoordinate.geohash(length: 7))
            }) {
                Text("Remove").padding()
            }.frame(minWidth: 100, minHeight: 44).background(Constant.color.tintColor)
                .foregroundColor(Color(.white))
                .cornerRadius(8).padding()
        } else {


            return Button(action: {
                self.addHouseLocationViewModel.saveHomeLocation(geoHash: map.centerCoordinate.geohash(length: 7))

            }) {

               Text("Add").padding()

            }.frame(minWidth: 100, minHeight: 44).background(Constant.color.tintColor)
                .foregroundColor(Color(.white))
                .cornerRadius(8).padding()

        }

    }
    
    var body: some View {

        VStack {

            ZStack(alignment: .top) {

        if(addHouseLocationViewModel.userLocation != nil) {

            AddHouseLocationMapView(map: self.$map, coordinate: self.$currentLocation, disabledLocationHashes: $addHouseLocationViewModel.disabledLocationHashes, initialLocation: addHouseLocationViewModel.userLocation!).overlay(AddRemoveButton, alignment: .bottomTrailing).overlay(Image("outline_home_black_36pt").resizable().frame(width: 45.0, height: 45.0))
        }
                
            }
            
            ZStack(alignment: .bottom) {
                VStack {
                    Text("Please select areas where Search Party shouldn't track you when searching.").padding(.bottom)

                        Button(action: {

                        }) {
                            if(addHouseLocationViewModel.disabledLocationHashes.isEmpty) {
                                Text("Skip")
                            } else {
                                Text("Done")
                            }
                            
                        
                        }.buttonStyle(PrimaryButtonStyle())
                    
                    
                }.padding()
                
            }

            
            
        }.navigationBarTitle(Text("Select Private Areas"), displayMode: .inline).onAppear() {
            self.addHouseLocationViewModel.requestLocation()
        }
        
    }
}

struct AddHouseLocation_Previews: PreviewProvider {
    static var previews: some View {
        AddHouseLocation(showView: .constant(true))
    }
}
