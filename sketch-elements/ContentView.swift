//
//  ContentView.swift
//  sketch-elements
//
//  Created by Filip Molcik on 12/03/2020.
//  Copyright © 2020 Filip Molcik. All rights reserved.
//

import SwiftUI

// NOTE: This is needed only to change the theme, feel free to remove it
enum Theme: String, CaseIterable, Identifiable {
    case food
    case social
    case travel
    var id: String { self.rawValue }
}

struct ContentView: View {
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter: OnboardingRouter

    var body: some View {
                
        
        VStack {
            if viewRouter.currentPage == "onboardingView" {
                SplashView(state: AppState())
            } else if viewRouter.currentPage == "homeView" {
                ZStack {
                    
                    Food()
                    ModalAnchorView()
                }
            }
        }
        

        
        
    }
}
