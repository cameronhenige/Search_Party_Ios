//
//  Filter.swift
//  searchparty
//
//  Created by Hannah Krolewski on 6/30/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI
import MapKit

struct FilterView: View {
    @State var map = MKMapView()

    @State var currentLocation: CLLocationCoordinate2D?

    var distances = ["1/4 Mile", "1/2 Mile", "1 Mile", "2 Miles", "5 Miles"]
    @State private var distanceSelected = 0

    @EnvironmentObject var searchPartyAppState: SearchPartyAppState
    @ObservedObject private var filterViewModel = FilterViewModel()

    var body: some View {
        VStack {

            Text("Distance")
            
            Picker(selection: $distanceSelected, label: Text("Distance")) {
                ForEach(0 ..< distances.count) {
                    Text(self.distances[$0])
                }
            }.pickerStyle(SegmentedPickerStyle()).padding(.bottom)
            
        if(filterViewModel.userLocation != nil) {

            FilterMapView(map: self.$map, coordinate: self.$currentLocation, initialLocation: filterViewModel.userLocation!).frame(height: 300).overlay(Image("marker").resizable().frame(width: 30.0, height: 45.0))
        }
            
            Button(action: {
                //todo save filter
            }) {
                Text("Save")
            }.buttonStyle(PrimaryButtonStyle()).padding(.top)
            
            
            
            Spacer()
        }.padding().onAppear() {
            self.filterViewModel.requestLocation()
        }
    }
}

//struct Filter_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterView()
//    }
//}
