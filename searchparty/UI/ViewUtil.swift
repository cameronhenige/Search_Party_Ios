//
//  ViewUtil.swift
//  searchparty
//
//  Created by Hannah Krolewski on 7/11/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation

public class ViewUtil {
    
    public func getRadiusForDistanceSelected(distanceSelected: Int) -> Double {
    
        switch distanceSelected {
        case 0:
            return 402.335
        case 1:
            return 804.67
        case 2:
            return 1609.34
        case 3:
            return 3218.68
        case 4:
            return 8046.70
        default:
            return 0
        }
    }
    
    public func getDistanceSelectedForRadius(radius: Double) -> Int {
    
        switch radius {
        case 402.335:
            return 0
        case 804.67:
            return 1
        case 1609.34:
            return 2
        case 3218.68:
            return 3
        case 8046.70:
            return 4
        default:
            return 3
        }
    }
}
