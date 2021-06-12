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
import FirebaseAuth
import UserNotifications

class SearchPartyViewModel: NSObject, ObservableObject {
    
    @Published var currentLocation: CLLocation?
    @Published var initialLocationGeoHash: String?

    @Published var locations: [MKPointAnnotation] = []
    
    @Published var searchDates: [Timestamp] = []
    @Published var listOfPrivateGeoHashes: [String]? = []

    @Published var listOfDays: [Date] = []


    @Published var searchPartyUsers = [SearchPartyUser]()
    @Published var hasScrolledToInitialSearches = false
    
    @Published var searchPartySearches = [SearchPartySearch]()
    var lostPet: LostPet?
    @Published var isSearching: Bool = false
    @Published var isInsideOfAPrivateGeoHash = false

    var currentSearchId: String = ""

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
        
    func fetchData(lostPet: LostPet) {
        
        locationManager.requestLocation()

        self.lostPet = lostPet
        //todo correct this call
        Firestore.firestore().collection("Lost").document(lostPet.id!).collection("SearchPartyUsers").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }

            self.searchPartyUsers = documents.compactMap { document -> SearchPartyUser? in
              try? document.data(as: SearchPartyUser.self)
            }
            
            
      }
        
        Firestore.firestore().collection("Lost").document(lostPet.id!).collection("Searches").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }

            self.searchPartySearches = documents.compactMap { document -> SearchPartySearch? in
              try? document.data(as: SearchPartySearch.self)
            }
            self.updateTabDays(searches: self.searchPartySearches)

            self.updateSearchesForUser(searches: self.searchPartySearches)

      }
        
    }
    
    func updateTabDays(searches: [SearchPartySearch]) {
    
        self.listOfDays.removeAll()
        for search in searches {
            if( search.created != nil){
                let date = search.created?.dateValue().removeTimeStamp
                
                if(!self.listOfDays.contains(date!)){
                    self.listOfDays.append(date!)
                }
            }
        }
        
    }
    
    private func updateSearchesForUser(searches: [SearchPartySearch]) {
        var newSearchPartyUsers: [SearchPartyUser] = self.searchPartyUsers
        
        for (index, element) in self.searchPartyUsers.enumerated() {
            newSearchPartyUsers[index].searches = getSearchesForUser(user: self.searchPartyUsers[index], searches: searches)
        }
        
        self.searchPartyUsers = newSearchPartyUsers
        

        
    }

    private func getSearchesForUser(user: SearchPartyUser, searches: [SearchPartySearch]) -> [SearchPartySearch] {
        
        var matchingSearches: [SearchPartySearch] = []
        
        for search in searches {
            if(search.uid == user.id){
                matchingSearches.append(search)
            }
        }
        return matchingSearches

    }
    
    func startUpdatingLocationButtonAction() {
        
        if isSearching {
            locationManager.stopUpdatingLocation()
            isSearching = false
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["identifier"])

        } else {
            
            if(currentLocation != nil){
            checkForJoined()
            }else{
                //todo tell user to wait for current location
            }
            

        }
        
       // startUpdatingLocationButton.setTitle(startUpdatingLocationButton.isSelected ? "Stop Updating Location" : "Start Updating Location", for: .normal)
        
    }
    
    private func checkForJoined() {
        
        Firestore.firestore().collection("Lost").document(lostPet!.id!).collection("SearchPartyUsers").document(Auth.auth().currentUser!.uid).getDocument { (document, error) in
            if let document = document {
                
                if(document.exists) {
                    self.addNewSearch()

                }else {
                    self.joinSearchParty()

                }
                
            } else {
                print("Document does not exist") //todo handle failure
            }
        }
    }
    
        
    private func joinSearchParty() {
        
    Firestore.firestore().collection("Lost").document(lostPet!.id!).collection("SearchPartyUsers").document(Auth.auth().currentUser!.uid).setData([
        "uid": Auth.auth().currentUser!.uid, "color": generateRandomColor().toHexString()
    ], merge: true) { err in
            if let err = err {
                print("Error adding document: \(err)") //todo
            } else {
                
                self.addNewSearch()

            }
        }
    }
    
    func generateRandomColor() -> UIColor {
        let redValue = CGFloat(drand48())
        let greenValue = CGFloat(drand48())
        let blueValue = CGFloat(drand48())
            
        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
            
        }
    
    func addNewSearch() {
        self.initialLocationGeoHash = self.currentLocation?.coordinate.geohash(length: 7)
        
        
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).updateData([
            "searchStartLocations": FieldValue.arrayUnion([self.initialLocationGeoHash])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                
                
                print("Document successfully updated")

                Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).getDocument { (document, error) in
                    if(document!.exists) {
                    if let user = try? document!.data(as: SPUser.self) {
                        self.listOfPrivateGeoHashes = user.searchStartLocations


                    
                    

                        
                            //start searching
                            var ref: DocumentReference? = Firestore.firestore().collection("Lost").document(self.lostPet!.id!).collection("Searches").addDocument(data: [
                                "uid": Auth.auth().currentUser!.uid
                            ]) { err in
                                if let err = err {
                                    print("Error adding document: \(err)") //todo
                                } else {
                                    
                                    self.currentSearchId = ref!.documentID
                                    //todo get search start locations
                                    
                                    self.sendSearchingNotification()
                                    self.locationManager.startUpdatingLocation()
                                    self.isSearching = true
                                }
                            }
                            
                            


                        }else {
                            //todo handle error
                        }
                        
                    }else {
                        //todo show error
                    }

        
    }
}
}
    }
    
    func sendSearchingNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = NSString.localizedUserNotificationString(forKey: "Wake up!", arguments: nil)
//        content.body = NSString.localizedUserNotificationString(forKey: "Rise and shine! It's morning time!",
//                                                                arguments: nil)
//
//        // Configure the trigger for a 7am wakeup.
////        var dateInfo = DateComponents()
////        dateInfo.hour = 7
////        dateInfo.minute = 0
//            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
//
//        // Create the request object.
//        let request = UNNotificationRequest(identifier: "MorningAlarm", content: content, trigger: nil)
//
//        // Schedule the request.
//        let center = UNUserNotificationCenter.current()
//        center.add(request) { (error : Error?) in
//            if let theError = error {
//                print(theError.localizedDescription)
//            }
//        }

        
        let content = UNMutableNotificationContent()
        let categoryIdentifire = "Delete Notification Type"
        
        content.title = "Searching for pet"
        content.body = "Your location is being tracked."
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire
        
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: "identifier", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
    }

    
}

extension SearchPartyViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func isInsideOfPrivateGeoHash()-> Bool {
        print(self.currentLocation?.coordinate.geohash(length: 7))
        
        print(self.listOfPrivateGeoHashes)
        
        let currentLocationGeoHash = self.currentLocation?.coordinate.geohash(length: 7)
        
        
        return (self.listOfPrivateGeoHashes!.contains((currentLocationGeoHash)!))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
                
        currentLocation = mostRecentLocation
        
        self.isInsideOfAPrivateGeoHash = self.isInsideOfPrivateGeoHash()
        print(self.isInsideOfAPrivateGeoHash)
        
        if(isSearching) {
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
        
        print("New location!")
        
        updatePathToBackend(location: mostRecentLocation)
        
//        if UIApplication.shared.applicationState == .active {
//            self.mapView.showAnnotations(self.locations, animated: true)
//        } else {
//            print("App is in background mode at location: \(mostRecentLocation)")
//        }
            
        }
        
    }
    
    func updatePathToBackend(location: CLLocation) {
        
        let geoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)

        Firestore.firestore().collection("Lost").document(lostPet!.id!).collection("Searches").document(currentSearchId).updateData(["path" : FieldValue.arrayUnion([geoPoint])]){ err in
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
