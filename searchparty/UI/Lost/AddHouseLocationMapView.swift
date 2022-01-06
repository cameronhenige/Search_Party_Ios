

import SwiftUI
import MapKit

struct AddHouseLocationMapView: UIViewRepresentable {
    
    @Binding var map : MKMapView
    
    @Binding var mapCenter: CLLocationCoordinate2D?
    
    @Binding var disabledLocationHashes: [String]
    var initialLocation: CLLocationCoordinate2D

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    

    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: AddHouseLocationMapView
        
        init(_ parent: AddHouseLocationMapView) {
            self.parent = parent
        }
        
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            self.parent.mapCenter = mapView.centerCoordinate

        }
        
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            if let polyline = overlay as? PathPolyline {
                let testlineRenderer = MKPolylineRenderer(polyline: polyline)
                testlineRenderer.strokeColor = UIColor(hexString: polyline.color!);
                testlineRenderer.fillColor = UIConfiguration.colorPrimaryDark.withAlphaComponent(0.3)

                testlineRenderer.lineWidth = 3
                return testlineRenderer
            }
            
            
            if let polygon = overlay as? ColoredPolygon {
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
        let centerCoordinate = initialLocation
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        map.setRegion(region, animated: true)
        
        return map
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        
        view.removeOverlays(view.overlays)
        
        let geoHash = view.centerCoordinate.geohash(length: 7)
        
        let polygon = MapUtil.getPolygonSquareFromGeoHash(geoHash: geoHash, color: "#808080")

        var overlays: [ColoredPolygon] = []
            for hash in disabledLocationHashes {
                let disabledPolygon = MapUtil.getPolygonSquareFromGeoHash(geoHash: hash, color: "#FF0000")
                overlays.append(disabledPolygon)

            }
        

        overlays.append(polygon)

        view.addOverlays(overlays)
        
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(coordinate: restaurantsData[0].locationCoordinate)
//    }
//}
