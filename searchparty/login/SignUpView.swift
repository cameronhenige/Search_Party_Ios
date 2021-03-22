//
//  SignUpView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/15/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @State var pushActive = false
    
    @State var fullName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
    @EnvironmentObject var authState: AuthenticationState
    
    init(state: AppState) {
    }
    
    var body: some View {
        ZStack {
            Color(UIConfiguration.tintColor)
                .edgesIgnoringSafeArea(.all)
        
        VStack {

            VStack(alignment: .leading, spacing: 30) {
                Text("Sign Up")
                    .modifier(TextModifier(font: UIConfiguration.titleFont,
                                           color: UIConfiguration.white))
                    .padding(.leading, 25)
                    .padding(.bottom, 80)
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .center, spacing: 25) {
                        TextField("Full Name", text: $fullName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("E-mail Address", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle()).textContentType(.newPassword)
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle()).textContentType(.newPassword)
                        
                    }.padding(.horizontal, 25)
                    VStack(alignment: .center, spacing: 40) {

                        
                        ButtonSecondary(action: signUpTapped) {
                                Text("Create Account")
                                    .font(.headline)
                        }.padding(.horizontal, 60)

                    }
                        
                }
            }
            Spacer()
        }.alert(item: $authState.error) { error in
            Alert(title: Text("Error"), message: Text(error.localizedDescription))
        }
        }
        

    }
    
    private func signUpTapped() {
        authState.signup(email: email, password: password, passwordConfirmation: confirmPassword, fullName: fullName)

    }
    
}
