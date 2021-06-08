//
//  SearchPartyMapView.swift
//  searchparty
//
//  Created by Hannah Krolewski on 5/19/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//



import SwiftUI
import MapKit
import FirebaseFirestore

struct SearchPartyMapView: UIViewRepresentable {
    
    @Binding var map : MKMapView
    @Binding var name : String
    @Binding var coordinate: CLLocationCoordinate2D?
    @Binding var searchPartyUsers: [SearchPartyUser]
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
        
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: SearchPartyMapView
        
        init(_ parent: SearchPartyMapView) {
            self.parent = parent
        }
        
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            self.parent.coordinate = mapView.centerCoordinate
            self.parent.map.removeOverlays(self.parent.map.overlays)
            
            
            let geoHash = mapView.centerCoordinate.geohash(length: 7)
                        
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
                //self.parent.map.addAnnotation(T##annotation: MKAnnotation##MKAnnotation)
            }
            


            
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            if let polyline = overlay as? PathPolyline {
                        let testlineRenderer = MKPolylineRenderer(polyline: polyline)
                testlineRenderer.strokeColor = UIColor(hexString: polyline.color!);
                
                        testlineRenderer.lineWidth = 3.0
                        return testlineRenderer
            }
            
            if let polyline = overlay as? MKPolygon {
                let over = MKPolygonRenderer(overlay: overlay)
                over.strokeColor = UIConfiguration.colorPrimary
                over.fillColor = UIConfiguration.colorPrimaryDark.withAlphaComponent(0.3)
                over.lineWidth = 3
                return over
                    
            }
            
            let over = MKPolygonRenderer(overlay: overlay)
            over.strokeColor = UIConfiguration.colorPrimary
            over.fillColor = UIConfiguration.colorPrimaryDark.withAlphaComponent(0.3)
            over.lineWidth = 3
            return over

        }
        
        
    }
    
    func makeUIView(context: Context) -> MKMapView {
        map.delegate = context.coordinator
        map.showsUserLocation = true
//        let centerCoordinate = coordinate ?? initialLocation
//        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
//        map.setRegion(region, animated: true)
        
        return map
    }
    
    private func getLatLngsFromPath(path: [GeoPoint]) -> [CLLocationCoordinate2D] {
        var latLngsOnPath = [CLLocationCoordinate2D]()

        for point in path {
            let latLng = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)

            latLngsOnPath.append(latLng)
        }
        return latLngsOnPath
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        print("Update ui view")
        
        var overlays = [MKOverlay]()

        
        for user in self.searchPartyUsers {

            if(user.searches != nil) {
                
                for search in user.searches ?? []{
                    if(search.path != nil && !search.path.isEmpty) {
                        let latLngsOnPath = getLatLngsFromPath(path: search.path)
                        
                    
                        let testline = PathPolyline(coordinates: latLngsOnPath, count: latLngsOnPath.count)
                        //generateRandomColor().toHexString()
                        testline.color = user.color ?? "#FF0000"
                        
                        //Add `MKPolyLine` as an overlay.
                        overlays.append(testline)
                        
                    }
                }
            }
            //print(user.color)
        }
        
        self.map.addOverlays(overlays)

//        print("sacsdsd")
//        print(overlays.count)
//
//        if(!self.hasScrolledToInitialSearches && !overlays.isEmpty) {
////            //scroll to all searches
////
////                    //let centerCoordinate = coordinate ?? initialLocation
////                    let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
////            let region = MKCoordinateRegion(center: overlays[0].coordinate, span: span)
////                    map.setRegion(region, animated: false)
//            print(overlays.count)
//            print("Scrolling to overlays")
//            map.showAnnotations(overlays, animated: false)
//        }
        



                   
            

    
        
        
        
        
    }
    
    func generateRandomColor() -> UIColor {
        let redValue = CGFloat(drand48())
        let greenValue = CGFloat(drand48())
        let blueValue = CGFloat(drand48())
            
        let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
            
        return randomColor
        }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(coordinate: restaurantsData[0].locationCoordinate)
//    }
//}
