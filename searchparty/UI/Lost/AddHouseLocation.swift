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

    
    var body: some View {

        VStack {

            ZStack(alignment: .top) {

        if(addHouseLocationViewModel.userLocation != nil) {

            AddHouseLocationMapView(map: self.$map, coordinate: self.$currentLocation, disabledLocationHashes: $addHouseLocationViewModel.disabledLocationHashes, initialLocation: addHouseLocationViewModel.userLocation!).overlay(Image("outline_home_black_36pt").resizable().frame(width: 45.0, height: 45.0))
        }
                
            }
            
            ZStack(alignment: .bottom) {
                VStack {
                    Text("Please select your home location so Search Party knows not to track you while you are near your home.").padding(.bottom)

                    Button(action: {
                        self.showView = false

                    }) {
                        Text("Add Disabled")
                    }.buttonStyle(PrimaryButtonStyle()).padding(.bottom)
                
                    

                        Button(action: {
                            self.addHouseLocationViewModel.saveHomeLocation(location: self.map.centerCoordinate) { result in
                                self.showView = false
                            }
                        }) {
                            Text("Skip")
                        }.buttonStyle(PrimaryButtonStyle())
                    
                    
                }.padding()
                
            }

            
            
        }.navigationBarTitle(Text("Add House Location"), displayMode: .inline).onAppear() {
            self.addHouseLocationViewModel.requestLocation()
        }
        
    }
}

struct AddHouseLocation_Previews: PreviewProvider {
    static var previews: some View {
        AddHouseLocation(showView: .constant(true))
    }
}
