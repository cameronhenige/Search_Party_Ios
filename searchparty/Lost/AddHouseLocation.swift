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
    @State var isOnLostPetIsFound = false

    @State var map = MKMapView()
    @State var currentLocation: CLLocationCoordinate2D?
    @ObservedObject private var addHouseLocationViewModel = AddHouseLocationViewModel()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    
    var body: some View {

        VStack {

            ZStack(alignment: .top) {
                

                
                
        if(addHouseLocationViewModel.userLocation != nil) {

            AddHouseLocationMapView(map: self.$map, coordinate: self.$currentLocation, initialLocation: addHouseLocationViewModel.userLocation!).overlay(Image("outline_home_black_36pt").resizable().frame(width: 45.0, height: 45.0))
        }
                
            }
            
            ZStack(alignment: .bottom) {
                VStack {
                Text("Add your home location")

                    Button(action: {
                        self.isOnLostPetIsFound = true
                        //todo skip

                    }) {
                        Text("Skip")
                    }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading, .trailing])
                
                    

                        Button(action: {
                            self.addHouseLocationViewModel.saveHomeLocation(location: self.map.centerCoordinate)
                            self.isOnLostPetIsFound = true
                            //todo save
                        }) {
                            Text("Save")
                        }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading, .trailing, .bottom])
                    
                    
                }
                
            }

            
            
        }.onAppear() {
            self.addHouseLocationViewModel.requestLocation()
        }
        
    }
}

struct AddHouseLocation_Previews: PreviewProvider {
    static var previews: some View {
        AddHouseLocation()
    }
}
