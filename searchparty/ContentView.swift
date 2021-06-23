//
//  ContentView.swift
//  sketch-elements
//
//  Created by Filip Molcik on 12/03/2020.
//  Copyright © 2020 Filip Molcik. All rights reserved.
//

import SwiftUI
import FirebaseAuth

@main
struct ContentView: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    

    
    
//    let loginState = AuthenticationState.shared
//    // Create the SwiftUI view that provides the window contents.
//    let contentView = ContentView()
//        .environmentObject(ModalManager())
//        .environmentObject(OnboardingRouter())
//        .environmentObject(loginState)
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(ModalManager())
                .environmentObject(OnboardingRouter())
                .environmentObject(AuthenticationState.shared)

        }
        
        

        
        
    }
}
