//
//  ContentView.swift
//  sketch-elements
//
//  Created by Filip Molcik on 12/03/2020.
//  Copyright © 2020 Filip Molcik. All rights reserved.
//

import SwiftUI
import FirebaseAuth


struct ContentView: View {
    @EnvironmentObject var authState: AuthenticationState
    @EnvironmentObject var viewRouter: OnboardingRouter

    var body: some View {
                
        
            if viewRouter.currentPage == "onboardingView" {
                OnboardingView().environmentObject(viewRouter)
            }else{
                if authState.loggedInUser != nil  && !authState.isAuthenticating {
                    MainScreen(syncFcmTokenViewModel: SyncFcmTokenViewModel())
                    

                //if(Auth.auth().currentUser == nil){
                }else{
                    
                    SplashView(state: AppState())

                    //ModalAnchorView()

                }
        }
        
        

        
        
    }
}
