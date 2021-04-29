//
//  PetImagePage.swift
//  searchparty
//
//  Created by Hannah Krolewski on 4/29/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

struct PetImagePage: Hashable, Codable {
    var name: String
//    var park: String
//    var state: String
//    var description: String
//    var isFavorite: Bool
//    var isFeatured: Bool

//    var category: Category
    
    
    init(nameGiven: String) {
        name = nameGiven
        imageName = "ImgeName"
    }
    
    enum Category: String, CaseIterable, Codable {
        case lakes = "Lakes"
        case rivers = "Rivers"
        case mountains = "Mountains"
    }

    private var imageName: String
//    var image: Image {
//        Image(imageName)
//    }

//    private var coordinates: Coordinates
//    var locationCoordinate: CLLocationCoordinate2D {
//        CLLocationCoordinate2D(
//            latitude: coordinates.latitude,
//            longitude: coordinates.longitude)
//    }

    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}
