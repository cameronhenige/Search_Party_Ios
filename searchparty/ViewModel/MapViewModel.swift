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
    
    @Published var permissionDenied = false
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //checking permission
        

        if #available(iOS 14.0, *) {
            switch locationAuthorizationStatus() {
            case .denied:
                permissionDenied.toggle()
                break
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
                break
            default:
                ()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func locationAuthorizationStatus() -> CLAuthorizationStatus {
        let locationManager = CLLocationManager()
        var locationAuthorizationStatus : CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            locationAuthorizationStatus =  locationManager.authorizationStatus
        } else {
            // Fallback on earlier versions
            locationAuthorizationStatus = CLLocationManager.authorizationStatus()
        }
        return locationAuthorizationStatus
    }
}
