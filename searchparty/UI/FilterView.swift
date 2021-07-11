

import SwiftUI
import MapKit

struct FilterView: View {
    @State var map = MKMapView()

    @State var currentLocation: CLLocationCoordinate2D?

    var distances = ["1/4 Mile", "1/2 Mile", "1 Mile", "2 Miles", "5 Miles"]

    @EnvironmentObject var searchPartyAppState: SearchPartyAppState
    @StateObject private var filterViewModel = FilterViewModel()

    var body: some View {
        VStack {
            if(!filterViewModel.isLoadingLocation && filterViewModel.initialLocation != nil) {

            Text("Distance")
            
            Picker(selection: $filterViewModel.distanceSelected, label: Text("Distance")) {
                ForEach(0 ..< distances.count) {
                    Text(self.distances[$0])
                }
            }.pickerStyle(SegmentedPickerStyle()).padding(.bottom)
            

                FilterMapView(map: self.$map, distanceSelected: self.$filterViewModel.distanceSelected, initialLocation: self.$filterViewModel.initialLocation).frame(height: 300).overlay(Image("marker").resizable().frame(width: 30.0, height: 45.0))
        
            Button(action: {
                self.filterViewModel.saveFilterPreference(filterDistance: ViewUtil().getRadiusForDistanceSelected(distanceSelected: filterViewModel.distanceSelected), centerMapLocation: self.map.centerCoordinate) { result in
                    
                    searchPartyAppState.isFiltering = false
                }
                
                
                
            }) {
                Text("Save")
            }.buttonStyle(PrimaryButtonStyle()).padding(.top)
            }
            
            
            Spacer()
        }.padding().onAppear() {
            self.filterViewModel.loadInitialData()
        }
    }
    
}

//struct Filter_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterView()
//    }
//}
