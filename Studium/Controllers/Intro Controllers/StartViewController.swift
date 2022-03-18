//
//  StartViewController.swift
//  Studium
//
//  Created by Vikram Singh on 6/5/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

import GoogleSignIn
import RealmSwift
import FBSDKLoginKit

class StartViewController: UIViewController, GIDSignInDelegate{
    
    let app = App(id: Secret.appID)

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var fbViewHolder: UIView!
    
    @IBOutlet weak var mainStackView: UIStackView!
    override func viewDidLoad() {
        signUpButton.layer.cornerRadius = 10
        loginButton.layer.cornerRadius = 10
        
        googleSignInButton.style = GIDSignInButtonStyle.wide
        googleSignInButton.colorScheme = GIDSignInButtonColorScheme.dark
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        navigationItem.hidesBackButton = false
        
        let loginButton = FBLoginButton()
        loginButton.center = fbViewHolder.center
        loginButton.fs_width = fbViewHolder.fs_width
        loginButton.fs_height = fbViewHolder.fs_height
        loginButton.fs_left = fbViewHolder.fs_left
        loginButton.fs_right = fbViewHolder.fs_right
        loginButton.permissions = ["public_profile", "email"]
        fbViewHolder.backgroundColor = .clear
        view.addSubview(loginButton)
//        mainStackView.insertSubview(loginButton, at: 2)
    }

    

    func sign(_ signIn: GIDSignIn!, didSignInFor googleUser: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Signed in successfully, forward credentials to MongoDB Realm.
        let credentials = Credentials.google(serverAuthCode: googleUser.serverAuthCode)
        K.app.login(credentials: credentials) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Failed to log in to MongoDB Realm: \(error)")
                case .success(let user):
                    print("Successfully logged in to MongoDB Realm using Google OAuth.")
                    let defaults = UserDefaults.standard
//                    app.currentUser.id
                    defaults.setValue(googleUser.profile.email, forKey: "email")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toWakeUp", sender: self)
                    }
                }
            }
        }
    }
    
    
    // FACEBOOK AUTHENTICATION CODE:
    
    // Once the button is clicked, show the login dialog
        func loginButtonClicked() {
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["email, public_profile"], from: self) { result, error in
                if let error = error {
                    print("ERROR: encountered Error when logging in with Facebook: \(error)")
                } else if let result = result, result.isCancelled {
                    print("LOG: User Cancelled Login with Facebook")
                } else {
                    print("LOG: User Successfully Logged In with Facebook")
                    self.handleFBLoginSuccess()
                }
            }
        }
    
    func handleFBLoginSuccess(){
        if let accessToken = AccessToken.current, !accessToken.isExpired {
                // User is logged in, do work such as go to next view controller.
            
            let credentials = Credentials.facebook(accessToken: accessToken.tokenString)
            K.app.login(credentials: credentials) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print("Failed to log in to MongoDB Realm: \(error)")
                    case .success(let user):
//                        accessToke
                        print("Successfully logged in to MongoDB Realm using Facebook OAuth.")
                        // Now logged in, do something with user
                        // Remember to dispatch to main if you are doing anything on the UI thread
                    }
                }
            }
        }else{
            print("ERROR: something is wrong with AccessToken when trying to log in with Facebook on StartViewController.")
        }
    }
    
//    func manageLogin(){
//        let loginManager = LoginManager()
//        loginManager.logIn(permissions: [ .email ]) { loginResult in
//            switch loginResult {
//            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
//
//            case .failed(let error):
//                print("Facebook login failed: \(error)")
//            case .cancelled:
//                print("The user cancelled the login flow.")
//            }
//        }
//    }
}
