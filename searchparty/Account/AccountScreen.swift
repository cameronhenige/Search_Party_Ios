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

    var tintColor: Color = Constant.color.tintColor
    
    var body: some View {
        NavigationView {

        Text("My Account").background(Constant.color.gray)
            .navigationBarColor(tintColor.uiColor())
            .navigationBarTitle(Text("Account"), displayMode: .large)
            .navigationBarItems(trailing: Button(action: signoutTapped, label: {
                Image(systemName: "person.circle")
                Text("Logout")
            }))
        }
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
