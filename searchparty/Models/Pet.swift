//
//  Pet.swift
//  searchparty
//
//  Created by Hannah Krolewski on 6/26/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation

struct Pet: Identifiable, Hashable {
    var name: String
    var id: String { name }

}
