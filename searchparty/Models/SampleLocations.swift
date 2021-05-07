//
//  SampleLocations.swift
//  searchparty
//
//  Created by Hannah Krolewski on 5/7/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {
    
    static var inifiniteLoop: CLLocationCoordinate2D = {
        CLLocationCoordinate2D(latitude: 37.331836, longitude: -122.029604)
    }()
    
    static var applePark: CLLocationCoordinate2D = {
        CLLocationCoordinate2D(latitude: 37.334780, longitude: -122.009073)
    }()
    
}
