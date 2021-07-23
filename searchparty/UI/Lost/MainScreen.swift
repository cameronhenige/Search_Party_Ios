//
//  ContentView.swift
//  sketch-elements
//
//  Created by Filip Molcik on 26/02/2020.
//  Copyright © 2020 Filip Molcik. All rights reserved.
//

import SwiftUI

struct MainScreen: View {
    @ObservedObject var syncFcmTokenViewModel: SyncFcmTokenViewModel
    @EnvironmentObject var appState: SearchPartyAppState

    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            LostPets().tabItem {
                Text("Lost")
                Image("lost_icon").renderingMode(.template)
            }.tag(1)
            AccountScreen().tabItem {
                Text("Found")
                Image("found_icon").renderingMode(.template)
            }.tag(2)
            AccountScreen().tabItem {
                
                Text("Account")
                Image(systemName: "person.circle").renderingMode(.template)
                
            }.tag(3)
                
            
        }
        .accentColor(Constant.color.tintColor).onAppear {
            syncFcmTokenViewModel.syncFcmTokenIfNeeded()
        
    }
        
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainScreen().environmentObject(UserData())
//    }
//}


