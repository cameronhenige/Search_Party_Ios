//
//  SearchPartyMapView.swift
//  searchparty
//
//  Created by Hannah Krolewski on 5/19/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//



import SwiftUI
import MapKit

struct SearchPartyMapView: UIViewRepresentable {
    
    @Binding var map : MKMapView
    @Binding var name : String
    

    @Binding var coordinate: CLLocationCoordinate2D?
    @Binding var searchPartyUsers: [SearchPartyUser]

    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    

    //var initialLocation: CLLocationCoordinate2D
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: SearchPartyMapView
        
        init(_ parent: SearchPartyMapView) {
            self.parent = parent
        }
        
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            self.parent.coordinate = mapView.centerCoordinate
            self.parent.map.removeOverlays(self.parent.map.overlays)
            
            let geoHash = mapView.centerCoordinate.geohash(length: 7)
            print("current geohash " + geoHash)
            
            print(GeoHashConverter.decode(hash: geoHash))
            
            let geoHashSquare = GeoHashConverter.decode(hash: geoHash)
            
            let topLeft = CLLocationCoordinate2DMake(geoHashSquare!.latitude.min, geoHashSquare!.longitude.min)
            let topRight = CLLocationCoordinate2DMake(geoHashSquare!.latitude.min, geoHashSquare!.longitude.max)
            let bottomLeft = CLLocationCoordinate2DMake(geoHashSquare!.latitude.max, geoHashSquare!.longitude.min)
            let bottomRight = CLLocationCoordinate2DMake(geoHashSquare!.latitude.max, geoHashSquare!.longitude.max)

            let points = [topLeft, topRight, bottomRight, bottomLeft]
            
            let polygon = MKPolygon(coordinates: points, count: points.count)
            
            self.parent.map.addOverlay(polygon)
            
            
            for user in self.parent.searchPartyUsers {
                
                print("Users!")
                //self.parent.map.addAnnotation(<#T##annotation: MKAnnotation##MKAnnotation#>)
            }

            
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            let over = MKPolygonRenderer(overlay: overlay)
            over.strokeColor = UIConfiguration.colorPrimary
            over.fillColor = UIConfiguration.colorPrimaryDark.withAlphaComponent(0.3)
            over.lineWidth = 3
            return over
        }
        
        
    }
    
    func makeUIView(context: Context) -> MKMapView {
        map.delegate = context.coordinator
//        let centerCoordinate = coordinate ?? initialLocation
//        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
//        map.setRegion(region, animated: true)
        
        return map
    }

    func updateUIView(_ view: MKMapView, context: Context) {
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(coordinate: restaurantsData[0].locationCoordinate)
//    }
//}
