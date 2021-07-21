//
//  AppState.swift
//  searchparty
//
//  Created by Hannah Krolewski on 6/23/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import GeoFire
import FlexibleGeohash

class SearchPartyAppState: NSObject, ObservableObject {
    
    @Published var isOnLostPetIsFound = false
    @Published var isLoadingLostPets = false
    @Published var isOnSearchParty = false
    @Published var isOnChat = false
    @Published var isOnAddingLostPet = false

    @Published var isOnEditingLostPet = false
    @Published var isFiltering = false
    @Published var isLoadingLostPetFromNotification = false
    @Published var isOnLostPet = false
    @Published var selectedTab: Int = 1
    @Published var selectedLostPet: LostPet? = nil
    @Published var pets: [Pet] = [Pet(name: "Louie"), Pet(name: "Fred"), Pet(name: "Stanley")]

    //@Published var isOnChat = false
    
    
    @Published var lostPets = [LostPet]()
        @Published var permissionStatus: CLAuthorizationStatus? = CLLocationManager.authorizationStatus()
        private let locationManager = CLLocationManager()
        @Published var userLatitude: Double = 0
        @Published var userLongitude: Double = 0
        
        
        override init() {
          super.init()
          self.locationManager.delegate = self
        }
        
        func requestLocationPermission() {
            locationManager.requestAlwaysAuthorization()
        }
        

        

        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
                    if #available(iOS 14.0, *) {
                permissionStatus = manager.authorizationStatus
            } else {
                permissionStatus = CLLocationManager.authorizationStatus()
            }
            print(permissionStatus?.rawValue)
        }
        
        func saveLocationToUser(location: CLLocation) {
            
            Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).setData([
                "filterLocation": GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            ], merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    self.fetchLostPets()
                }
            }
        }
    
    func navigateToLostPet(lostPetId: String, goToChat: Bool) {
        self.isLoadingLostPetFromNotification = true
        
        Firestore.firestore().collection("Lost").document(lostPetId).getDocument { (DocumentSnapshot, Error) in

            if(Error == nil){
                let lostPet = try? DocumentSnapshot!.data(as: LostPet.self)
                if(lostPet != nil) {
                    self.selectedLostPet = lostPet
                    self.isOnLostPet = true
                    
                    if(goToChat){
                        self.isOnChat = true
                    }

                } else {
                    //todo show failed to load lost pet
                }
            } else {
                self.isLoadingLostPets = false
                //todo
            }
        }
        
        //todo load lost pet
    }
    
    func getSelectedLostPet() {
        let selectedLostPetQuery = Firestore.firestore().collection("Lost").document((selectedLostPet?.id)!)

        selectedLostPetQuery.getDocument { (DocumentSnapshot, Error) in

            if(Error == nil) {
                let lostPet = try? DocumentSnapshot!.data(as: LostPet.self)
                self.selectedLostPet = lostPet
                
                print(self.selectedLostPet?.generalImages)

            } else {
                //todo
            }
        }
    }
    
    
    
    func fetchLostPets() {
        
        let userDocument = Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid)
        isLoadingLostPets = true
        userDocument.getDocument { (DocumentSnapshot, Error) in

            if(Error == nil){
                let user = try? DocumentSnapshot!.data(as: SPUser.self)
                if(user != nil && user!.filterLocation != nil) {

                    self.queryLostPets(filterLocation: user!.filterLocation!, radiusInM: user!.getRadiusFromUser())
                } else {
                    self.locationManager.requestLocation()
                }
            } else {
                self.isLoadingLostPets = false
                //todo
            }
        }
    }
    
    func queryLostPets(filterLocation: GeoPoint, radiusInM: Double) {
  

        let center = CLLocationCoordinate2D(latitude: filterLocation.latitude, longitude: filterLocation.longitude)
        
        let queryBounds = GFUtils.queryBounds(forLocation: center,
                                              withRadius: radiusInM)
        let queries = queryBounds.compactMap { (any) -> Query? in
            guard let bound = any as? GFGeoQueryBounds else { return nil }
            
            return Firestore.firestore().collection("Lost")
                .order(by: "lostLocation")
                .start(at: [bound.startValue])
                .end(at: [bound.endValue])
        }
        
        let dispatchGroup = DispatchGroup()

        var tempLostPets = [LostPet]()
        
        func getDocumentsCompletion(snapshot: QuerySnapshot?, error: Error?) -> () {

            guard let documents = snapshot?.documents else {
                print("Unable to fetch snapshot data. \(String(describing: error))")
                return
            }
            for document in documents {
                
                let lostPet = try? document.data(as: LostPet.self)
                let lostPetHash = lostPet?.lostLocation
                
                let lostPetCoord = Geohash(hash: lostPetHash!)
                let lostPetLocation = lostPetCoord.region().center
                let userLocation = CLLocation(latitude: filterLocation.latitude, longitude: filterLocation.longitude)
            
                let centerPoint = CLLocation(latitude: lostPetLocation.latitude, longitude: lostPetLocation.longitude)
                // We have to filter out a few false positives due to GeoHash accuracy, but
                // most will match
                let distance = GFUtils.distance(from: centerPoint, to: userLocation)
                if distance <= radiusInM {
                    tempLostPets.append(lostPet!)
                }
            }
            dispatchGroup.leave()
        }
        
            for query in queries {
            dispatchGroup.enter()
            query.getDocuments(completion: getDocumentsCompletion)
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            self.lostPets = tempLostPets
        })
    }
    
}

extension SearchPartyAppState: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    userLatitude = location.coordinate.latitude
    userLongitude = location.coordinate.longitude
    saveLocationToUser(location: location)
  }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }
}
