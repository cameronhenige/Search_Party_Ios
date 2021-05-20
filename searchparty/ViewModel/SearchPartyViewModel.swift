//
//  SearchPartyViewModel.swift
//  searchparty
//
//  Created by Hannah Krolewski on 5/19/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class SearchPartyViewModel: NSObject, ObservableObject {
    @Published var locations: [MKPointAnnotation] = []
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    
    func startUpdatingLocationButtonAction() {
        
        //sender.isSelected = !sender.isSelected
        //if sender.isSelected {
            locationManager.startUpdatingLocation()
        //} else {
            //locationManager.stopUpdatingLocation()
        //}
        
       // startUpdatingLocationButton.setTitle(startUpdatingLocationButton.isSelected ? "Stop Updating Location" : "Start Updating Location", for: .normal)
        
    }
    
}

extension SearchPartyViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        // Add another annotation to the map.
        let annotation = MKPointAnnotation()
        annotation.coordinate = mostRecentLocation.coordinate
        
        // Also add to our map so we can remove old values later
        self.locations.append(annotation)
        
        // Remove values if the array is too big
        while locations.count > 100 {
            let annotationToRemove = self.locations.first!
            self.locations.remove(at: 0)
            
            // Also remove from the map
            //mapView.removeAnnotation(annotationToRemove)
        }
        
//        if UIApplication.shared.applicationState == .active {
//            self.mapView.showAnnotations(self.locations, animated: true)
//        } else {
//            print("App is in background mode at location: \(mostRecentLocation)")
//        }
        
    }
    
}
