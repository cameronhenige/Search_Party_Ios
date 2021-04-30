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
    var url: String
    
    
    init(url: String) {
        self.url = url
    }
    

}
