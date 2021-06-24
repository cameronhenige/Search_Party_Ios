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

    
    var body: some View {
        TabView() {
            LostPets().environmentObject(LostViewRouter()).tabItem {
                Text("Lost")
                Image("lost_icon").renderingMode(.template)
            }
            AccountScreen().tabItem {
                Text("Found")
                Image("found_icon").renderingMode(.template)
            }
            AccountScreen().tabItem {
                Text("Account")
                Image(systemName: "person.circle").renderingMode(.template)
            }
        }
        .accentColor(Constant.color.foodPrimary).onAppear {
            syncFcmTokenViewModel.syncFcmTokenIfNeeded()
        
    }
        
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainScreen().environmentObject(UserData())
//    }
//}


