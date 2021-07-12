//
//  FilterMapView.swift
//  searchparty
//
//  Created by Hannah Krolewski on 7/7/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//
import SwiftUI
import MapKit

struct FilterMapView: UIViewRepresentable {
    
    @Binding var map : MKMapView
    @Binding var distanceSelected: Int
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    

    @Binding var initialLocationAndDistance: InitialLocationAndDistance?
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: FilterMapView
        var currentDistanceSelected: Int? = nil
        var hasGoneToInitialLocation: Bool = false

        
        init(_ parent: FilterMapView) {
            self.parent = parent
        }
        
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            //self.parent.coordinate = mapView.centerCoordinate
            self.parent.map.removeOverlays(self.parent.map.overlays)
            
            let radius = ViewUtil().getRadiusForDistanceSelected(distanceSelected: self.parent.distanceSelected)
            let circle = MKCircle(center: mapView.centerCoordinate, radius: radius)
            currentDistanceSelected = self.parent.distanceSelected
            self.parent.map.addOverlay(circle)
        }
        

        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            let over = MKCircleRenderer(overlay: overlay)
            over.strokeColor = UIConfiguration.colorPrimary
            over.fillColor = UIConfiguration.colorPrimaryDark.withAlphaComponent(0.3)
            over.lineWidth = 3
            return over
        }
        
        
    }
    
    func makeUIView(context: Context) -> MKMapView {
        map.delegate = context.coordinator
                
        //todo
//        if(initialLocationAndDistance != nil) {
//        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//            let region = MKCoordinateRegion(center: initialLocationAndDistance!.locationSelected, span: span)
//            map.setRegion(region, animated: true)
//        }
        
        return map
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.removeOverlays(view.overlays)
        
        if(!context.coordinator.hasGoneToInitialLocation && initialLocationAndDistance != nil) {
            
            context.coordinator.currentDistanceSelected = ViewUtil().getDistanceSelectedForRadius(radius: initialLocationAndDistance!.distanceSelected)

            context.coordinator.hasGoneToInitialLocation = true
            
            let initialRadius = initialLocationAndDistance!.distanceSelected
            
            
            goToLocation(location: initialLocationAndDistance!.locationSelected, distanceSelected: initialRadius)
            
        }else {
            
            let radius = ViewUtil().getRadiusForDistanceSelected(distanceSelected: self.distanceSelected)
        
        if(context.coordinator.currentDistanceSelected == nil || context.coordinator.currentDistanceSelected != self.distanceSelected){
            goToLocation(location: view.centerCoordinate, distanceSelected: radius)
            context.coordinator.currentDistanceSelected = self.distanceSelected
        }
            
        }
        

        
    }
    
    func goToLocation(location: CLLocationCoordinate2D, distanceSelected: Double) {
        
        let doubleRadius = distanceSelected * 2.75

        let region = MKCoordinateRegion( center: location, latitudinalMeters: CLLocationDistance(exactly: doubleRadius)!, longitudinalMeters: CLLocationDistance(exactly: doubleRadius)!)
        map.setRegion(map.regionThatFits(region), animated: true)
        
        
        let circle = MKCircle(center: map.centerCoordinate, radius: distanceSelected)
        map.addOverlay(circle)
    }
    
    

}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(coordinate: restaurantsData[0].locationCoordinate)
//    }
//}
