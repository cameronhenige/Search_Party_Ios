//
//  MapUtil.swift
//  searchparty
//
//  Created by Hannah Krolewski on 1/5/22.
//  Copyright © 2022 Filip Molcik. All rights reserved.
//

import Foundation
import MapKit

class MapUtil {
    
    class func getPolygonSquareFromGeoHash(geoHash: String, color: String) -> ColoredPolygon {
        let geoHashSquare = GeoHashConverter.decode(hash: geoHash)
        
        let topLeft = CLLocationCoordinate2DMake(geoHashSquare!.latitude.min, geoHashSquare!.longitude.min)
        let topRight = CLLocationCoordinate2DMake(geoHashSquare!.latitude.min, geoHashSquare!.longitude.max)
        let bottomLeft = CLLocationCoordinate2DMake(geoHashSquare!.latitude.max, geoHashSquare!.longitude.min)
        let bottomRight = CLLocationCoordinate2DMake(geoHashSquare!.latitude.max, geoHashSquare!.longitude.max)

        let points = [topLeft, topRight, bottomRight, bottomLeft]
        
        
        let polygon = ColoredPolygon(coordinates: points, count: points.count)
        polygon.color = color
        return polygon
    }
}
