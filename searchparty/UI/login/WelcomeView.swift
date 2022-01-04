//
//  WelcomeView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/15/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    @State private var index = 1
    @State private var pushActive = false
    @EnvironmentObject var authState: AuthenticationState

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIConfiguration.tintColor)
                    .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                NavigationLink(destination: destinationView(),
                               isActive: self.$pushActive) {
                                EmptyView()
                }
                .navigationBarHidden(true)

                VStack(spacing: 40) {
                    Image("flashlight")
                        .resizable()
                        .frame(width: 120, height: 120, alignment: .center)
                        .padding(.top, 100)
                    
                    Text("Welcome to Search Party")
                        .modifier(TextModifier(font: UIConfiguration.titleFont,
                                               color: UIConfiguration.white))
                    
                    Text("Sign in to get access to all features")
                        .modifier(TextModifier(font: UIConfiguration.subtitleFont,
                                               color: UIConfiguration.white))
                        .padding(.horizontal, 60)
                    
                    VStack(spacing: 25) {
                        
                        ButtonSecondary(action: signInClicked) {
                                Text("Sign In")
                                    .font(.headline)
                        }.padding(.horizontal, 60)
                        
                        
                        ButtonSecondary(action: signUpClicked) {
                                Text("Sign Up")
                                    .font(.headline)
                        }.padding(.horizontal, 60)
                        
                        

                        
                        Button(action: {
                            self.signInAnonymously()
                        }) {
                            Text("Skip for now")
                                .modifier(TextModifier(font: UIConfiguration.buttonFont,
                                                       color: UIConfiguration.white))
                                .frame(width: 275, height: 55)
                                
                            
                        }
                        
                    }
                    
                }
                Spacer()
                
            }
            }
        }.navigationViewStyle(StackNavigationViewStyle()).accentColor(.white)
    }
    
    private func signInClicked() {
        self.index = 1
        self.pushActive = true
    }
    
    private func signUpClicked() {
        self.index = 2
        self.pushActive = true
    }
    
    private func signInAnonymously() {
        authState.signInAnonymously()

    }
    
    private func destinationView() -> AnyView {
        switch index {
        case 1:
            return AnyView(SignInView())
        default:
            return AnyView(SignUpView())
        }
    }
}
