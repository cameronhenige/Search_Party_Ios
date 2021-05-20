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
import FirebaseFirestore

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
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        //todo correct this call
      db.collection("books").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
//        self.books = documents.map { queryDocumentSnapshot -> Book in
//          let data = queryDocumentSnapshot.data()
//          let title = data["title"] as? String ?? ""
//          let author = data["author"] as? String ?? ""
//          let numberOfPages = data["pages"] as? Int ?? 0
//          return Book(id: .init(), title: title, author: author, numberOfPages: numberOfPages)
//        }
      }
    }
    
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
