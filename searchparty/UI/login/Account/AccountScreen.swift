//
//  AccountScreen.swift
//  searchparty
//
//  Created by Hannah Krolewski on 4/24/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI

struct AccountScreen: View {
    @EnvironmentObject var authState: AuthenticationState

    
    var body: some View {
        NavigationView {

        Text("My Account").background(Constant.color.gray)
            .navigationBarTitle(Text("Account"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: signoutTapped, label: {
                Image(systemName: "person.circle")
                Text("Logout")
            }))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func signoutTapped() {
        authState.signout()
    }
}

struct AccountScreen_Previews: PreviewProvider {
    static var previews: some View {
        AccountScreen()
    }
}
