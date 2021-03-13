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
        VStack {

            VStack(alignment: .leading, spacing: 30) {
                Text("Sign Up")
                    .modifier(TextModifier(font: UIConfiguration.titleFont,
                                           color: UIConfiguration.tintColor))
                    .padding(.leading, 25)
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .center, spacing: 25) {
                        CustomTextField(placeHolderText: "Full Name",
                                      text: $fullName)
                        CustomTextField(placeHolderText: "E-mail Address",
                                      text: $email)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(MyTextFieldStyle()).textContentType(.newPassword)
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(MyTextFieldStyle()).textContentType(.newPassword)
                        
                    }.padding(.horizontal, 25)
                    
                    
                        Button(action: signUpTapped) {
                            Text("Create Account")
                                .modifier(ButtonModifier(font: UIConfiguration.buttonFont,
                                                         color: UIConfiguration.tintColor,
                                                         textColor: .white,
                                                         width: 275,
                                                         height: 55))
                        }
                        
                }
            }
            Spacer()
        }.alert(item: $authState.error) { error in
            Alert(title: Text("Error"), message: Text(error.localizedDescription))
        }
        

    }
    
    private func signUpTapped() {
        authState.signup(email: email, password: password, passwordConfirmation: confirmPassword, fullName: fullName)

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
                                         height: 45))
        }
    }
}
