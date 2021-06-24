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
    @Binding var isSearching : Bool

    @Binding var coordinate: CLLocationCoordinate2D?
    @Binding var searchPartyUsers: [SearchPartyUser]
    
    @Binding var listOfPrivateGeoHashes: [String]?

    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
        
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: SearchPartyMapView
        var hasZoomed = false
        var currentlySearching = false
        var currentOverlays = [PathPolyline]()
        init(_ parent: SearchPartyMapView) {
            self.parent = parent
        }
        
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            self.parent.coordinate = mapView.centerCoordinate
//            self.parent.map.removeOverlays(self.parent.map.overlays)
//
//
//            let geoHash = mapView.centerCoordinate.geohash(length: 7)
//
//            let geoHashSquare = GeoHashConverter.decode(hash: geoHash)
//
//            let topLeft = CLLocationCoordinate2DMake(geoHashSquare!.latitude.min, geoHashSquare!.longitude.min)
//            let topRight = CLLocationCoordinate2DMake(geoHashSquare!.latitude.min, geoHashSquare!.longitude.max)
//            let bottomLeft = CLLocationCoordinate2DMake(geoHashSquare!.latitude.max, geoHashSquare!.longitude.min)
//            let bottomRight = CLLocationCoordinate2DMake(geoHashSquare!.latitude.max, geoHashSquare!.longitude.max)
//
//            let points = [topLeft, topRight, bottomRight, bottomLeft]
//
//            let polygon = MKPolygon(coordinates: points, count: points.count)
//
//            self.parent.map.addOverlay(polygon)
//
//
//
//            for user in self.parent.searchPartyUsers {
//
//                print("Users!")
//                //self.parent.map.addAnnotation(T##annotation: MKAnnotation##MKAnnotation)
//            }



            
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            if let polyline = overlay as? PathPolyline {
                        let testlineRenderer = MKPolylineRenderer(polyline: polyline)
                testlineRenderer.strokeColor = UIColor(hexString: polyline.color!);
                        
                        testlineRenderer.lineWidth = 3.0
                        return testlineRenderer
            }
            
            
            if let polygon = overlay as? ColoredPolygon {
//                        let testlineRenderer = MKPolylineRenderer(polyline: polyline)
//                testlineRenderer.strokeColor = UIColor(hexString: polyline.color!);
//
//                        testlineRenderer.lineWidth = 3.0
//                        return testlineRenderer
                
                
                let over = MKPolygonRenderer(overlay: overlay)
                over.strokeColor = UIColor(hexString: polygon.color!)
                over.fillColor = UIColor(hexString: polygon.color!).withAlphaComponent(0.3)
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
        
        let buttonItem = MKUserTrackingButton(mapView: map)
            buttonItem.frame = CGRect(origin: CGPoint(x:25, y: 80), size: CGSize(width: 35, height: 35))

            map.addSubview(buttonItem)
        
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
        
        var overlays = [PathPolyline]()
        self.map.removeOverlays(self.map.overlays)
        
        for user in self.searchPartyUsers {

            if(user.searches != nil) {
                
                for search in user.searches ?? []{
                    if(!search.path.isEmpty) {
                        let latLngsOnPath = getLatLngsFromPath(path: search.path)
                    
                        let testline = PathPolyline(coordinates: latLngsOnPath, count: latLngsOnPath.count)
                        //generateRandomColor().toHexString()
                        testline.color = user.color ?? "#FF0000"
                        
                        //Add `MKPolyLine` as an overlay.
                        overlays.append(testline)
                        
                    }
                }
            }
        }
        

        
        if(isSearching && !context.coordinator.currentlySearching) {

        
            self.map.setUserTrackingMode(.follow, animated: true)

            context.coordinator.currentlySearching = true
        }
        
        
        if(!isSearching && context.coordinator.currentlySearching) {
            self.map.setUserTrackingMode(.none, animated: true)
            context.coordinator.currentlySearching = false
        }
        
        self.map.addOverlays(overlays)

        
        if(!context.coordinator.hasZoomed && !overlays.isEmpty) {
            var allRects :MKMapRect = overlays[0].boundingMapRect
            for overlay in overlays {
                allRects = allRects.union(overlay.boundingMapRect)
            }
            let rect = map.mapRectThatFits(allRects, edgePadding: UIEdgeInsets(top: 70, left: 70, bottom: 170, right: 70))
            map.setVisibleMapRect(rect, animated: false)
            context.coordinator.hasZoomed = true
        }
        
        
        //self.parent.coordinate = map.centerCoordinate
        //self.parent.map.removeOverlays(self.parent.map.overlays)


        if(isSearching) {
        if(listOfPrivateGeoHashes != nil && !listOfPrivateGeoHashes!.isEmpty){

            for privateHash in self.listOfPrivateGeoHashes! {
                
            
            let geoHashSquare = GeoHashConverter.decode(hash: privateHash)

        let topLeft = CLLocationCoordinate2DMake(geoHashSquare!.latitude.min, geoHashSquare!.longitude.min)
        let topRight = CLLocationCoordinate2DMake(geoHashSquare!.latitude.min, geoHashSquare!.longitude.max)
        let bottomLeft = CLLocationCoordinate2DMake(geoHashSquare!.latitude.max, geoHashSquare!.longitude.min)
        let bottomRight = CLLocationCoordinate2DMake(geoHashSquare!.latitude.max, geoHashSquare!.longitude.max)

        let points = [topLeft, topRight, bottomRight, bottomLeft]

        let polygon = ColoredPolygon(coordinates: points, count: points.count)
                polygon.color = "#FF0000"

        self.map.addOverlay(polygon)
            }
            
        }

        }

        
  
    }
    
    func getMkMapRectFromSearches(polyLines: [PathPolyline]) -> MKMapRect{
        
//        // these are your two lat/long coordinates
//        let coordinate1 = CLLocationCoordinate2DMake(52.5200,long1);
//        let coordinate2 = CLLocationCoordinate2DMake(lat2,long2);
//
//        // convert them to MKMapPoint
//        let p1 = MKMapPointForCoordinate (coordinate1);
//        let p2 = MKMapPointForCoordinate (coordinate2);
//
//        // and make a MKMapRect using mins and spans
//        let mapRect = MKMapRectMake(fmin(p1.x,p2.x), fmin(p1.y,p2.y), fabs(p1.x-p2.x), fabs(p1.y-p2.y));
//
//        return mapRect
        
        
        //return MKMapRect.init(x: 52.5200, y: 13.4050, width: 100000, height: 100000);
        
        return MKMapRect(x: 52.5200, y: 13.4050, width: 0.1, height: 0.1);

        
        
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
