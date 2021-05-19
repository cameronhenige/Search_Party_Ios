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
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State private var bottomSheetPosition: BottomSheetPosition = .middle

    
    var body: some View {
        NavigationView {
            VStack {
        
        Map(coordinateRegion: $region).bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, content: {
            //The Numbers from 0 to 99 as Main Content in a Scroll View
            ScrollView {
                ForEach(0..<100) { index in
                    Text(String(index))
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top)
        })
        }

        }
    }
}

struct SearchPartyView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPartyView()
    }
}
