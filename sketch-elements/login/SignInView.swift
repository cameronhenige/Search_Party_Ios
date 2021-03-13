//
//  SignUpView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/8/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import SwiftUI
import Combine
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

struct SignInView: View {
    @State var pushActive = false
    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var authState: AuthenticationState

    init(state: AppState) {
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: Food(),
                           isActive: self.$pushActive) {
              EmptyView()
            }.hidden()
            VStack(alignment: .leading, spacing: 30) {
                Text("Log in")
                    .modifier(TextModifier(font: UIConfiguration.titleFont,
                                           color: UIConfiguration.tintColor))
                    .padding(.leading, 25)
                    .padding(.bottom, 80)
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .center, spacing: 25) {
                        CustomTextField(placeHolderText: "E-mail",
                                      text: $email)
                        CustomTextField(placeHolderText: "Password",
                                      text: $password,
                                      isPasswordType: true)
                    }.padding(.horizontal, 25)
                    
                    VStack(alignment: .center, spacing: 40) {
                        customButton(title: "Log In",
                                     backgroundColor: UIConfiguration.tintColor,
                                     action: { signInTapped() })

                    }
                }
            }
            Spacer()
        }.alert(item: $authState.error) { error in
            Alert(title: Text("Error"), message: Text(error.localizedDescription))
        }
    }
    
    private func signInTapped() {
        authState.handleSignInWith(email: email, password: password)

    }
    
    private func customButton(title: String,
                              backgroundColor: UIColor,
                              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .modifier(ButtonModifier(font: UIConfiguration.buttonFont,
                                         color: backgroundColor,
                                         textColor: .white,
                                         width: 275,
                                         height: 55))
        }
    }
}
