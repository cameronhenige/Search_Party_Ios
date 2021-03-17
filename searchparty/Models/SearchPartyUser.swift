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

struct SearchPartyUser: Codable, Identifiable {
    @DocumentID var id: String?
    var color: Int?
    var name: String?
}
