//
//  MainView.swift
//  searchparty
//
//  Created by Hannah Krolewski on 6/23/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var authState: AuthenticationState
    @EnvironmentObject var viewRouter: OnboardingRouter
    @EnvironmentObject var searchPartyAppState: SearchPartyAppState

    var body: some View {
        if viewRouter.currentPage == "onboardingView" {
            OnboardingView().environmentObject(viewRouter)
        }else{
            if authState.loggedInUser != nil  && !authState.isAuthenticating {
                MainScreen(syncFcmTokenViewModel: SyncFcmTokenViewModel()).environmentObject(searchPartyAppState)
                

            //if(Auth.auth().currentUser == nil){
            }else{
                
                SplashView(state: AppState())

                //ModalAnchorView()

            }
    }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
