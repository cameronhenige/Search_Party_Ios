//
//  AddLostPetViewModel.swift
//  searchparty
//
//  Created by Hannah Krolewski on 5/6/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import GeoFire
import FlexibleGeohash

class AddLostPetViewModel: NSObject, ObservableObject {

@Published var isLoadingLocation = false
    @Published var permissionStatus: CLAuthorizationStatus? = CLLocationManager.authorizationStatus()
    private var db = Firestore.firestore()
    private let locationManager = CLLocationManager()
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    @Published var userLocation: CLLocationCoordinate2D?
    
    @Published var isAddingLostPet = false

    
    override init() {
      super.init()
      self.locationManager.delegate = self
    }
    
    func addLostPet(name: String, sex: String, age: Int, breed: String, type: String, description: String, lostDateTime: Date, lostLocation: String, lostLocationDescription: String, ownerName: String, ownerEmail: String, ownerPhoneNumber: String, ownerPreferredContactMethod: String, ownerOtherContactMethod: String, owners: [String]) {
        
        //auth.signIn(withEmail: email, password: password, completion: handleAuthResultCompletion)
    }
    
    func requestLocationPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func requestLocation() {
        self.locationManager.requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
                if #available(iOS 14.0, *) {
            permissionStatus = manager.authorizationStatus
        } else {
            permissionStatus = CLLocationManager.authorizationStatus()
        }
    }
    
    func saveLocationToUser(location: CLLocation) {
        
    }
}

extension AddLostPetViewModel: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    userLatitude = location.coordinate.latitude
    userLongitude = location.coordinate.longitude
    saveLocationToUser(location: location)
    userLocation = CLLocationCoordinate2D(
        latitude: userLatitude,
        longitude: userLongitude)
  }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

}
