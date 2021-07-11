//
//  FilterViewModel.swift
//  searchparty
//
//  Created by Hannah Krolewski on 7/7/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import FirebaseStorage

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import GeoFire
import FlexibleGeohash

class FilterViewModel: NSObject, ObservableObject {

    @Published var isLoadingLocation = false
    @Published var isUpdatingFilter = false
    @Published var permissionStatus: CLAuthorizationStatus? = CLLocationManager.authorizationStatus()
    @Published var userLocation: CLLocationCoordinate2D?
    
    private var completionHandler: ((Result<String, Error>) -> Void)?
    private var db = Firestore.firestore()
    private let locationManager = CLLocationManager()
    
    let FILTER_DISTANCE_KEY = "filterDistance"
    let FILTER_LOCATION = "filterLocation"
    
    override init() {
      super.init()
      self.locationManager.delegate = self
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
    
    func saveFilterPreference(filterDistance: Double, centerMapLocation: CLLocationCoordinate2D, completionHandler: @escaping (Result<String, Error>) -> Void) {
        print(filterDistance)
        print(centerMapLocation.latitude)
        
        isUpdatingFilter = true

        let locationGeoPoint = centerMapLocation.geohash(length: 7)
        
            let filterData : [String: Any] = [
                FILTER_LOCATION : locationGeoPoint,
                FILTER_DISTANCE_KEY: filterDistance
            ]
        
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).setData(filterData, merge: true) { err in
                if let err = err {
                    print("Error updating filter settings: \(err)")
                    completionHandler(.failure(err))
                } else {
                    completionHandler(.success("Updated Filter Settings"))
                }
            }

    }
    
    
    
    
}

extension FilterViewModel: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    userLocation = CLLocationCoordinate2D(
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude)
  }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

}
