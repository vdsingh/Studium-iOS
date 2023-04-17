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

class StartViewController: FBAndGoogleAuthViewController{
    
    let app = App(id: Secret.appID)

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
//    @IBOutlet weak var fbViewHolder: UIView!
    @IBOutlet weak var facebookSignInButton: UIButton!
    @IBOutlet weak var guestSignInButton: UIButton!
    
    @IBOutlet weak var mainStackView: UIStackView!
    override func viewDidLoad() {
        signUpButton.layer.cornerRadius = 10
        loginButton.layer.cornerRadius = 10
        
        googleSignInButton.style = GIDSignInButtonStyle.wide
        googleSignInButton.colorScheme = GIDSignInButtonColorScheme.dark
        
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().delegate = self
        
        sender = self
        facebookSignInButton.addTarget(self, action: #selector(fbLoginButtonClicked), for: .touchUpInside)
        facebookSignInButton.layer.cornerRadius = 10
        guestSignInButton.addTarget(self, action: #selector(handleLoginAsGuest), for: .touchUpInside)

        navigationItem.hidesBackButton = false
        
//        let loginButton = FBLoginButton()
//        loginButton.center = fbViewHolder.center
//        loginButton.fs_width = fbViewHolder.fs_width
//        loginButton.fs_height = fbViewHolder.fs_height
//        loginButton.fs_left = fbViewHolder.fs_left
//        loginButton.fs_right = fbViewHolder.fs_right
//        loginButton.permissions = ["public_profile", "email"]
//        fbViewHolder.backgroundColor = .clear
        
        
//        let loginButton = UIButton(type: .custom)
//        loginButton.backgroundColor = .darkGray
//        loginButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
//        loginButton.center = view.center
//        loginButton.setTitle("My Login Button", for: .normal)
//        loginButton.permissions = ["public_profile", "email"]


        // Handle clicks on the button
//        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)

//        view.addSubview(loginButton)
//        mainStackView.insertSubview(loginButton, at: 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("StartViewController viewwillappear")
    }
    

//    func sign(_ signIn: GIDSignIn!, didSignInFor googleUser: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
//                print("The user has not signed in before or they have since signed out.")
//            } else {
//                print("\(error.localizedDescription)")
//            }
//            return
//        }
//        // Signed in successfully, forward credentials to MongoDB Realm.
//        let credentials = Credentials.google(serverAuthCode: googleUser.serverAuthCode)
//        K.app.login(credentials: credentials) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .failure(let error):
//                    print("Failed to log in to MongoDB Realm: \(error)")
//                case .success(let user):
//                    print("Successfully logged in to MongoDB Realm using Google OAuth.")
//                    self.handleGeneralLoginSuccess(email: googleUser.profile.email)
//                }
//            }
//        }
//    }
    
    
    // FACEBOOK AUTHENTICATION CODE:
    
    // Once the button is clicked, show the login dialog
//    @IBAction func fbLoginButtonClicked() {
//        let loginManager = LoginManager()
//
//        if AccessToken.current != nil {
//            loginManager.logOut()
//            return
//        }
//
//        loginManager.logIn(permissions: ["email", "public_profile"], from: self) { result, error in
//            if let error = error {
//                print("ERROR: encountered Error when logging in with Facebook: \(error)")
//            } else if let result = result, result.isCancelled {
//                print("LOG: User Cancelled Login with Facebook")
//            } else {
//                print("LOG: User Successfully Logged In with Facebook")
//                self.handleFBLoginSuccess()
//            }
//        }
//    }
//
//
//    func handleFBLoginSuccess(){
//        if let accessToken = AccessToken.current, !accessToken.isExpired {
//                // User is logged in, do work such as go to next view controller.
//            let credentials = Credentials.facebook(accessToken: accessToken.tokenString)
//            K.app.login(credentials: credentials) { result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .failure(let error):
//                        print("Failed to log in to MongoDB Realm: \(error)")
//                    case .success(let user):
////                        accessToke
//                        print("Successfully logged in to MongoDB Realm using Facebook OAuth.")
//                        // Now logged in, do something with user
//                        // Remember to dispatch to main if you are doing anything on the UI thread
////                        let email =
//                        self.handleGeneralLoginSuccess(email: nil)
//                    }
//                }
//            }
//        }else{
//            print("ERROR: something is wrong with AccessToken when trying to log in with Facebook on StartViewController.")
//        }
//    }
//
//    //this function just does what all authentication methods do upon success (Google, Facebook, Email, etc.)
//    func handleGeneralLoginSuccess(email: String?){
//        let defaults = UserDefaults.standard
//
//        if email != nil{
//            defaults.setValue(email, forKey: "email")
//
//        } else  {
//            defaults.setValue("Logged In", forKey: "email")
//        }
//        self.performSegue(withIdentifier: "toWakeUp", sender: self)
//    }
}
