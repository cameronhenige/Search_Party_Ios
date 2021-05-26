//
//  SearchPartySearch.swift
//  searchparty
//
//  Created by Hannah Krolewski on 5/26/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct SearchPartySearch: Codable {
    var uid: String?
    var path: [GeoPoint]
    var created: Timestamp?
    var name: String?
}
