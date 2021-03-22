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
    @ObservedObject var state: AppState
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
                        Button(action: {
                            self.index = 1
                            self.pushActive = true
                        }) {
                            Text("Sign In")
                                .modifier(ButtonModifier(font: UIConfiguration.buttonFont,
                                                         color: UIConfiguration.white,
                                                         textColor: UIConfiguration.tintColor,
                                                         width: 275,
                                                         height: 55))
                        }
                        Button(action: {
                            self.index = 2
                            self.pushActive = true
                        }) {
                            Text("Sign Up")
                                .modifier(TextModifier(font: UIConfiguration.buttonFont,
                                                       color: UIConfiguration.white))
                                .frame(width: 275, height: 55)
                                .overlay(RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        }
                        
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
                
            }.navigationBarColor(UIConfiguration.tintColor)
            }
        }
    }
    
    private func signInAnonymously() {
        authState.signInAnonymously()

    }
    
    private func destinationView() -> AnyView {
        switch index {
        case 1:
            return AnyView(SignInView(state: state))
        default:
            return AnyView(SignUpView(state: state))
        }
    }
}
