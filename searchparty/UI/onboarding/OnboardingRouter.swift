//
//  OnboardingRouter.swift
//  sketch-elements
//
//  Created by Hannah Krolewski on 3/11/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import SwiftUI

class OnboardingRouter: ObservableObject {
    
    init() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = "onboardingView"
        } else {
            currentPage = ""
        }
    }
    
    //@Published var selectedTab: ContentView.Tab = .home

    @Published var currentPage: String
    
}
