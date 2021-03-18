//
//  MapViewModel.swift
//  searchparty
//
//  Created by Hannah Krolewski on 3/15/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var permissionStatus: CLAuthorizationStatus? = CLLocationManager.authorizationStatus()
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        print("New Status")


        if #available(iOS 14.0, *) {
            
            permissionStatus = manager.authorizationStatus

//            switch locationAuthorizationStatus() {
//            case .denied:
//                break
//            case .notDetermined:
//                manager.requestWhenInUseAuthorization()
//                break
//            default:
//                ()
//            }
        } else {
    permissionStatus = CLLocationManager.authorizationStatus()

            // Fallback on earlier versions
        }
        print(permissionStatus?.rawValue)

    }
    
    
//    func locationAuthorizationStatus() -> CLAuthorizationStatus {
//        let locationManager = CLLocationManager()
//        var locationAuthorizationStatus : CLAuthorizationStatus
//        if #available(iOS 14.0, *) {
//            locationAuthorizationStatus =  locationManager.authorizationStatus
//        } else {
//            // Fallback on earlier versions
//            locationAuthorizationStatus = CLLocationManager.authorizationStatus()
//
//        }
//        return locationAuthorizationStatus
//    }
}
