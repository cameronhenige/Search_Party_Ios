//
//  LostViewRouter.swift
//  searchparty
//
//  Created by Hannah Krolewski on 5/18/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation

import SwiftUI

class LostViewRouter: ObservableObject {
    
    init() {
        isAddingLostPet = false
    }
    
    
    @Published var isAddingLostPet: Bool
    
}
