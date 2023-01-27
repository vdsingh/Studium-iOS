//
//  LoginViewController.swift
//  Studium
//
//  Created by Vikram Singh on 1/31/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleSignIn

class LoginViewController1: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    let app = App(id: Secret.appID)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
        
        emailTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",attributes:[NSAttributedString.Key.foregroundColor: UIColor.tertiaryLabel])
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 10
        
        passwordTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",attributes:[NSAttributedString.Key.foregroundColor: UIColor.tertiaryLabel])
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 10
        
        loginButton.layer.cornerRadius = 10

        
        googleSignInButton.style = GIDSignInButtonStyle.wide
        googleSignInButton.colorScheme = GIDSignInButtonColorScheme.dark
        
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().delegate = self


          // Automatically sign in the user.
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        navigationItem.hidesBackButton = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        app.login(credentials: Credentials.emailPassword(email: email, password: password)) { (result) in
            switch result {
            case .failure(let error):
                print("Login failed: \(error.localizedDescription)")
            case .success(let user):
                print("Successfully logged in as user \(user)")
                let defaults = UserDefaults.standard
                defaults.setValue(email, forKey: "email")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toWakeUp", sender: self)
                }
                // Now logged in, do something with user
                // Remember to dispatch to main if you are doing anything on the UI thread
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
    }
    @IBAction func noAccountButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toRegister", sender: self)
    }
    
    //MARK: Google Sign In Method
//    func sign(_ signIn: GIDSignIn!, didSignInFor googleUser: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
//                print("The user has not signed in before or they have since signed out.")
//            } else {
//                print("\(error.localizedDescription)")
//            }
//            return
//        }
//
//        // Signed in successfully, forward credentials to MongoDB Realm.
//        let credentials = Credentials.google(serverAuthCode: googleUser.serverAuthCode)
////        GIDSignIn.sharedInstance().serverClientID
//        app.login(credentials: credentials) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .failure(let error):
//                    print("Failed to log in to MongoDB Realm: \(error)")
//                case .success(let user):
//                    print("Successfully logged in to MongoDB Realm using Google OAuth.")
//                    let defaults = UserDefaults.standard
//                    defaults.setValue(googleUser.profile.email, forKey: "email")
//                    DispatchQueue.main.async {
//                        self.performSegue(withIdentifier: "toWakeUp", sender: self)
//                    }
//                    // Now logged in, do something with user
//                    // Remember to dispatch to main if you are doing anything on the UI thread
//                }
//            }
//        }
//    }
}
