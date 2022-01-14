//
//  ContentView.swift
//  sketch-elements
//
//  Created by Filip Molcik on 12/03/2020.
//  Copyright © 2020 Filip Molcik. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import Firebase

@main
struct ContentView: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var searchPartyAppState = SearchPartyAppState()

    
    var body: some Scene {
        WindowGroup {
            
            
//            if(searchPartyAppState.isLoadingDeepLink){
//
//            } else {
                
            MainView().environmentObject(ModalManager())
                .environmentObject(OnboardingRouter())
                .environmentObject(AuthenticationState.shared)
                .environmentObject(searchPartyAppState).onAppear(perform:setUpAppDelegate).onOpenURL { url in
                    print("Url found is \(url)")
                    
                    let handled = DynamicLinks.dynamicLinks()
                      .handleUniversalLink(url) { dynamiclink, error in
                        print("parsed out \(dynamiclink?.url)")
                        
                        if(error == nil) {
                            
                            let link = dynamiclink?.url?.absoluteString
                            if((link!.contains("LostPet"))){
                                let lostPetId = getQueryStringParameter(url: link!, param: "lostPetId")
                                                                
                                searchPartyAppState.deepLinkToLostPet(lostPetId: lostPetId!)

                            }else{
                               //todo invalid link
                            }
                        }
                        
                      }
                  }
                
           // }
                

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
    
    func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func setUpAppDelegate(){
            appDelegate.searchPartyAppState = searchPartyAppState
        }
}
