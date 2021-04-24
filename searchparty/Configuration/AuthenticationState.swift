//
//  AuthenticationState.swift
//  SwiftUIAuthentication
//
//  Created by Alfian Losari on 16/11/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Combine
import AuthenticationServices
import FirebaseAuth

enum LoginOption {
    case signInWithApple
    case emailAndPassword(email: String, password: String)
}

class AuthenticationState: NSObject, ObservableObject {
    
    @Published var loggedInUser: User?
    @Published var isAuthenticating = false
    @Published var isResettingPassword = false
    @Published var didResetPassword = false
    @Published var error: NSError?
    
    static let shared = AuthenticationState()
    
    private let auth = Auth.auth()
    fileprivate var currentNonce: String?
    fileprivate var fullName: String?

    override private init() {
        loggedInUser = auth.currentUser
        super.init()
        
        auth.addStateDidChangeListener(authStateChanged)
    }
    
    private func authStateChanged(with auth: Auth, user: User?) {
        guard user != self.loggedInUser else { return }
        self.loggedInUser = user
    }
    
    func login(with loginOption: LoginOption) {
        self.isAuthenticating = true
        self.error = nil
                
        switch loginOption {
        case .signInWithApple:
            handleSignInWithApple()
            
        case let .emailAndPassword(email, password):
            handleSignInWith(email: email, password: password)
        }
    }
    
    func forgotPassword(email: String) {

        self.isAuthenticating = true
        self.error = nil
        auth.sendPasswordReset(withEmail: email, completion: handleResetPasswordCompletion)
    }
    
    func signup(email: String, password: String, passwordConfirmation: String, fullName: String) {
        guard password == passwordConfirmation else {
            self.error = NSError(domain: "", code: 9210, userInfo: [NSLocalizedDescriptionKey: "Password and confirmation does not match"])
            return
        }
        
        self.fullName = fullName
        
        self.isAuthenticating = true
        self.error = nil
        
        auth.createUser(withEmail: email, password: password, completion: handleAuthResultCompletion)
    }
    
    func handleSignInWith(email: String, password: String) {
        auth.signIn(withEmail: email, password: password, completion: handleAuthResultCompletion)
    }
    
    func signInAnonymously(){
        auth.signInAnonymously(completion: handleAuthResultCompletion)
    }
    
    private func handleResetPasswordCompletion(error: Error?) {
        self.isAuthenticating = false

        if(error != nil){
            self.error = error as! NSError
        }else{
            didResetPassword = true
            isResettingPassword = false
        }
    }
    
    
    private func handleAuthResultCompletion(auth: AuthDataResult?, error: Error?) {
        DispatchQueue.main.async {
            if let user = auth?.user {
                if(self.fullName != nil){
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.fullName
                    changeRequest?.commitChanges { (error) in
                        self.loggedInUser = user
                        self.isAuthenticating = false

                    }
                }else{
                    self.loggedInUser = user
                    self.isAuthenticating = false
                }
            
            } else if let error = error {
                self.error = error as NSError
            }
        }
    }
  
    func signout() {
        try? auth.signOut()
    }
    
}

extension AuthenticationState: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private func handleSignInWithApple() {
        //todo maybe do this later
//        let nonce = String.randomNonceString()
//        currentNonce = nonce
//
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//        request.nonce = nonce.sha256
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows[0]
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential, completion: handleAuthResultCompletion)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple error: \(error)")
        self.isAuthenticating = false
        self.error = error as NSError
    }
    
}
