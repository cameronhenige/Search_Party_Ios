//
//  ForgotPasswordView.swift
//  searchparty
//
//  Created by Hannah Krolewski on 3/21/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @State var email: String = ""
    @EnvironmentObject var authState: AuthenticationState
    
    var body: some View {
        
        ZStack {
            Color(UIConfiguration.tintColor)
                .edgesIgnoringSafeArea(.all)
        
        VStack {

            VStack(alignment: .leading, spacing: 30) {
                Text("Forgot Password")
                    .modifier(TextModifier(font: UIConfiguration.titleFont,
                                           color: UIConfiguration.white))
                    .padding(.leading, 25)
                    .padding(.bottom, 80)
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .center, spacing: 25) {

                        TextField("E-mail Address", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
    
                    }.padding(.horizontal, 25)
                    VStack(alignment: .center, spacing: 40) {

                        
                        ButtonSecondary(action: forgotPasswordTapped) {
                                Text("Reset Password")
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
    
    private func forgotPasswordTapped(){
        authState.isResettingPassword = false
        authState.forgotPassword(email: email)
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
