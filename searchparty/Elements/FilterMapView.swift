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
        
        init(_ parent: FilterMapView) {
            self.parent = parent
        }
        
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            self.parent.coordinate = mapView.centerCoordinate
            self.parent.map.removeOverlays(self.parent.map.overlays)
            
            let radius = self.parent.getRadiusForDistanceSelected(distanceSelected: self.parent.distanceSelected)
            let circle = MKCircle(center: mapView.centerCoordinate, radius: radius)
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
        print("Update ui view")
        
        coordinate = view.centerCoordinate
        view.removeOverlays(view.overlays)
        
        let radius = getRadiusForDistanceSelected(distanceSelected: self.distanceSelected)
        let circle = MKCircle(center: view.centerCoordinate, radius: radius)
        view.addOverlay(circle)
        
    }
    
    func getRadiusForDistanceSelected(distanceSelected: Int) -> Double {
    
        switch distanceSelected {
        case 0:
            return 402.335
        case 1:
            return 804.67
        case 2:
            return 1609.34
        case 3:
            return 3218.68
        case 4:
            return 8046.70
        default:
            return 0
        }
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(coordinate: restaurantsData[0].locationCoordinate)
//    }
//}
