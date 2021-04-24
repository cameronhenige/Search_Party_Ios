//
//  SearchPartyView.swift
//  searchparty
//
//  Created by Hannah Krolewski on 3/21/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI
import MapKit

struct SearchPartyView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    
    var body: some View {
        NavigationView {
            VStack {
        
        Map(coordinateRegion: $region)
        }

        }
    }
}

struct SearchPartyView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPartyView()
    }
}
