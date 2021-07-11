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
    
    @Binding var coordinate: CLLocationCoordinate2D?

    @Binding var distanceSelected: Int

    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    

    var initialLocation: CLLocationCoordinate2D
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: FilterMapView
        var currentDistanceSelected: Int? = nil

        
        init(_ parent: FilterMapView) {
            self.parent = parent
        }
        
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            self.parent.coordinate = mapView.centerCoordinate
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
        let centerCoordinate = coordinate ?? initialLocation
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        map.setRegion(region, animated: true)
        
        return map
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.removeOverlays(view.overlays)
        let radius = ViewUtil().getRadiusForDistanceSelected(distanceSelected: self.distanceSelected)
        let circle = MKCircle(center: view.centerCoordinate, radius: radius)
        view.addOverlay(circle)
        
        if(context.coordinator.currentDistanceSelected == nil || context.coordinator.currentDistanceSelected != self.distanceSelected){
            let doubleRadius = radius * 2.75
            let region = MKCoordinateRegion( center: view.centerCoordinate, latitudinalMeters: CLLocationDistance(exactly: doubleRadius)!, longitudinalMeters: CLLocationDistance(exactly: doubleRadius)!)
            view.setRegion(view.regionThatFits(region), animated: true)
            context.coordinator.currentDistanceSelected = self.distanceSelected
        }
        
    }
    

}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(coordinate: restaurantsData[0].locationCoordinate)
//    }
//}