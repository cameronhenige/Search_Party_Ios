//
//  SearchPartyUser.swift
//  searchparty
//
//  Created by Hannah Krolewski on 3/16/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct SPUser: Codable, Identifiable {
    @DocumentID var id: String?
    var filterDistance: Float?
    var filterLocation: GeoPoint?
    var receiveNotifications: Bool?
    var searchStartLocations: [String]?
    var hasSetHomeFilter: Bool?
    var homeGeoHash: String?
}
