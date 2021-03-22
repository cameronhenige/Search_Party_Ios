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
    //@State var pushActive = false
    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var authState: AuthenticationState

    init(state: AppState) {
    }
    
    var body: some View {
        ZStack {
            Color(UIConfiguration.tintColor)
                .edgesIgnoringSafeArea(.all)
        
        VStack {
            
            NavigationLink(destination: ForgotPasswordView(),
                           isActive: $authState.isResettingPassword) {
                            EmptyView()
            }
            
            VStack(alignment: .leading, spacing: 30) {
                Text("Log in")
                    .modifier(TextModifier(font: UIConfiguration.titleFont,
                                           color: UIConfiguration.white))
                    .padding(.leading, 25)
                    .padding(.bottom, 80)
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .center, spacing: 25) {
                        
                        TextField("E-Mail", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                    }.padding(.horizontal, 25)
                    
                    VStack(alignment: .center, spacing: 40) {

                        
                        ButtonSecondary(action: signInTapped) {
                                Text("Log In")
                                    .font(.headline)
                        }.padding(.horizontal, 60)
                        
                        Button(action: {
                            self.authState.isResettingPassword = true
                            
                        }) {
                            Text("Forgot Password")
                                .modifier(TextModifier(font: UIConfiguration.buttonFont,
                                                       color: UIConfiguration.white))
                                .frame(width: 275, height: 55)
                                
                            
                        }

                    }
                }
            }
            Spacer()
        }.alert(item: $authState.error) { error in
            Alert(title: Text("Error"), message: Text(error.localizedDescription))
        }
        }
    }
    
    private func signInTapped() {
        authState.handleSignInWith(email: email, password: password)

    }
    
}
