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

    
    var body: some View {
            VStack {
                
                SearchPartyMapView(map: self.$map, name: self.$name, coordinate: self.$currentLocation)
                
                

                
        
//        Map(coordinateRegion: $region)
            }.bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, hasBottomPosition: false, content: {
                        //The Numbers from 0 to 99 as Main Content in a Scroll View
            VStack {
            Button(action: {
                searchPartyViewModel.startUpdatingLocationButtonAction()
            }) {
                Text("Search")
            }.buttonStyle(PrimaryButtonStyle()).padding()
            
                        ScrollView {
                            ForEach(0..<100) { index in
                                Text(String(index))
                            }
                            .frame(maxWidth: .infinity)
                        }
            
            }
            
            
                    })

        
    }
}

struct SearchPartyView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPartyView()
    }
}
