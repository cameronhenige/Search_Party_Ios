//
//  SignUpView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/15/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject private var viewModel: SignUpViewModel
    @State var pushActive = false
    @EnvironmentObject var authState: AuthenticationState
    
    init(state: AppState) {
        self.viewModel = SignUpViewModel(authAPI: AuthService(), state: state)
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
                                      text: $viewModel.fullName)
                        CustomTextField(placeHolderText: "Phone Number",
                                      text: $viewModel.phoneNumber)
                        CustomTextField(placeHolderText: "E-mail Address",
                                      text: $viewModel.email)
                        CustomTextField(placeHolderText: "Password",
                                      text: $viewModel.password,
                                      isPasswordType: true)
                    }.padding(.horizontal, 25)
                    
                    VStack(alignment: .center, spacing: 40) {
                        customButton(title: "Create Account",
                                     backgroundColor: UIColor(hexString: "#334D92"),
                                     action: self.viewModel.signUp)
                        
                        Button(action: signUpTapped, label: {
                            Text("Sign Up")
                        })
                    }
                }
            }
            Spacer()
        }.alert(item: self.$viewModel.statusViewModel) { status in
            Alert(title: Text(status.title),
                  message: Text(status.message),
                  dismissButton: .default(Text("OK"), action: { self.pushActive = true }))
        }
        

    }
    
    private func signUpTapped() {
        authState.signup(email: viewModel.email, password: viewModel.password, passwordConfirmation: viewModel.password)

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
