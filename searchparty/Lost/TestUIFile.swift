//
//  TestUIFile.swift
//

import SwiftUI
import MapKit

struct TestUIFile: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    var body: some View {
        
        ZStack(alignment: .top) {
    
            
            Map(coordinateRegion: $region)
            
            //but I am in the center?
            ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(0...50, id: \.self) { index in
                                
                                
                                Text(String(index))
                            }
                        }.frame(width: .infinity, height: 100, alignment: .top)
                        
                
            }
        }
        
    }
}

struct TestUIFile_Previews: PreviewProvider {
    static var previews: some View {
        TestUIFile()
    }
}
