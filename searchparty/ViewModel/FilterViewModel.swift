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
    @Published var distanceSelected = 0
    
    @Published var initialLocationAndDistance: InitialLocationAndDistance?
    
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
    
    func loadInitialData() {
        self.isLoadingLocation = true
    
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).getDocument { (document, error) in
            if let document = document {
                
                if(document.exists) {
                    
                    if let user = try? document.data(as: SPUser.self) {
                        if(user.filterDistance != nil && user.filterLocation != nil) {
                            self.isLoadingLocation = false
                            
                            var initialLocation = CLLocationCoordinate2D(latitude: user.filterLocation!.latitude, longitude: user.filterLocation!.longitude)

                            
                            self.initialLocationAndDistance = InitialLocationAndDistance(locationSelected: initialLocation, distanceSelected: user.filterDistance!)
                            
                            //set filter distance and location on view
                        }else{
                            self.requestLocation()
                        }
                                    
                    } else {
                        self.requestLocation()
                    }

                }else {
                    
                    self.requestLocation()

                }
                
            } else {
                print("Document does not exist") //todo handle failure
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
                if #available(iOS 14.0, *) {
            permissionStatus = manager.authorizationStatus
        } else {
            permissionStatus = CLLocationManager.authorizationStatus()
        }
    }
    
    func saveFilterPreference(filterDistance: Double, centerMapLocation: CLLocationCoordinate2D, completionHandler: @escaping (Result<String, Error>) -> Void) {
        
        isUpdatingFilter = true

        let locationGeoPoint = GeoPoint(latitude: centerMapLocation.latitude, longitude: centerMapLocation.longitude)

        print(centerMapLocation)
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
    
    self.initialLocationAndDistance = InitialLocationAndDistance(locationSelected: CLLocationCoordinate2D(
                                                                    latitude: location.coordinate.latitude,
                                                                    longitude: location.coordinate.longitude), distanceSelected: 3218.68)
    self.isLoadingLocation = false

  }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

}
