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
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter: OnboardingRouter

    var body: some View {
                
        
        VStack {
            if viewRouter.currentPage == "onboardingView" {
                OnboardingView().environmentObject(viewRouter)
            }else{
                if authState.loggedInUser == nil {
                //if(Auth.auth().currentUser == nil){
                    SplashView(state: AppState())
                }else{
                    Food()
                    //ModalAnchorView()

                }
        }
        }
        

        
        
    }
}
