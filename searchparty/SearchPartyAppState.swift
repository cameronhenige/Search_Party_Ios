//
//  AppState.swift
//  searchparty
//
//  Created by Hannah Krolewski on 6/23/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation

class SearchPartyAppState: ObservableObject {
    @Published var selectedTab: Int = 1
    @Published var selectedLostPet: LostPet? = nil

    //@Published var isOnChat = false
}
