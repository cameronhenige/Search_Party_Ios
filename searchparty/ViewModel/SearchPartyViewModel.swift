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
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class SearchPartyViewModel: NSObject, ObservableObject {
    @Published var locations: [MKPointAnnotation] = []
    
    @Published var searchPartyUsers = [SearchPartyUser]()
    @Published var searchPartySearches = [SearchPartySearch]()
    var lostPet: LostPet?

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    
    private var db = Firestore.firestore()
    
    func fetchData(lostPet: LostPet) {
        self.lostPet = lostPet
        //todo correct this call
        db.collection("Lost").document(lostPet.id!).collection("SearchPartyUsers").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
//        self.searchPartyUsers = documents.map { queryDocumentSnapshot -> SearchPartyUser in
//
//            return try queryDocumentSnapshot.data(as: SearchPartyUser.self)!
//
////          let data = queryDocumentSnapshot.data()
////          let title = data["title"] as? String ?? ""
////          let author = data["author"] as? String ?? ""
////          let numberOfPages = data["pages"] as? Int ?? 0
////          return Book(id: .init(), title: title, author: author, numberOfPages: numberOfPages)
//        }
            
            self.searchPartyUsers = documents.compactMap { document -> SearchPartyUser? in
              try? document.data(as: SearchPartyUser.self)
            }
            
            print(self.searchPartyUsers)
            
      }
        
        db.collection("Lost").document(lostPet.id!).collection("Searches").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }

            self.searchPartySearches = documents.compactMap { document -> SearchPartySearch? in
              try? document.data(as: SearchPartySearch.self)
            }

            self.updateSearchesForUser(searches: self.searchPartySearches)

            print(self.searchPartyUsers)

      }
        
    }
    
    private func updateSearchesForUser(searches: [SearchPartySearch]) {
        
        for (index, element) in self.searchPartyUsers.enumerated() {
            self.searchPartyUsers[index].searches = getSearchesForUser(user: self.searchPartyUsers[index], searches: searches)
        }
        

        
    }

    private func getSearchesForUser(user: SearchPartyUser, searches: [SearchPartySearch]) -> [SearchPartySearch]{
        //todo filter these
//        var matchingSearches: ArrayList<SearchPartySearch> = arrayListOf()
//
//        for(search in searches){
//            if(search.uid == user.id){
//                matchingSearches.add(search)
//            }
//        }
//        return matchingSearches
        return searches
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
        
        print(self.locations.first)
        print("New location!")
        
        updatePathToBackend(location: mostRecentLocation)
        
//        if UIApplication.shared.applicationState == .active {
//            self.mapView.showAnnotations(self.locations, animated: true)
//        } else {
//            print("App is in background mode at location: \(mostRecentLocation)")
//        }
        
    }
    
    func updatePathToBackend(location: CLLocation) {
        
        let geoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        print(lostPet?.id)
        db.collection("Lost").document(lostPet!.id!).collection("Searches").document("v4el89bTn19Ka5RSZLXR").updateData(["path" : FieldValue.arrayUnion([geoPoint])]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        
        
//        NewFirestoreUtil().getUserSearchPartyReference(lostPetId!!, currentSearchId!!).update("path", FieldValue.arrayUnion(geoPoint)).addOnSuccessListener {
//            numberOfUpdates++
//
//            if(numberOfUpdates >= MAX_NUMBER_OF_UPDATES){
//                endSearch()
//            }
//        }.addOnFailureListener {
//            Toast.makeText(applicationContext, "Failure adding latest location.", Toast.LENGTH_SHORT).show()
//        }
        
        
        
    }
    
}
