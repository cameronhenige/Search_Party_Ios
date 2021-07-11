

import SwiftUI
import MapKit

struct FilterView: View {
    @State var map = MKMapView()

    @State var currentLocation: CLLocationCoordinate2D?

    var distances = ["1/4 Mile", "1/2 Mile", "1 Mile", "2 Miles", "5 Miles"]
    @State var distanceSelected = 0

    @EnvironmentObject var searchPartyAppState: SearchPartyAppState
    @StateObject private var filterViewModel = FilterViewModel()

    var body: some View {
        VStack {

            Text("Distance")
            
            Picker(selection: $distanceSelected, label: Text("Distance")) {
                ForEach(0 ..< distances.count) {
                    Text(self.distances[$0])
                }
            }.pickerStyle(SegmentedPickerStyle()).padding(.bottom)
            
        if(filterViewModel.userLocation != nil) {

            FilterMapView(map: self.$map, coordinate: self.$currentLocation, distanceSelected: self.$distanceSelected, initialLocation: filterViewModel.userLocation!).frame(height: 300).overlay(Image("marker").resizable().frame(width: 30.0, height: 45.0))
        }else{
            Text("Location not found")
        }
            
            Button(action: {
                self.filterViewModel.saveFilterPreference(filterDistance: ViewUtil().getRadiusForDistanceSelected(distanceSelected: distanceSelected), centerMapLocation: self.map.centerCoordinate) { result in
                    
                    searchPartyAppState.isFiltering = false
                }
                
                
                
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
