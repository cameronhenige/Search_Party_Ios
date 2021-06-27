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
    @Environment(\.scenePhase) var scenePhase

    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(ModalManager())
                .environmentObject(OnboardingRouter())
                .environmentObject(AuthenticationState.shared)
                .environmentObject(SearchPartyAppState())
                .environmentObject(ChatViewModel())

        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
              print("App is active")
            case .inactive:
              print("App is inactive")
            case .background:
              print("App is in background")
            @unknown default:
              print("Oh - interesting: I received an unexpected new value.")
            }
          }
        
        

        
        
    }
}
