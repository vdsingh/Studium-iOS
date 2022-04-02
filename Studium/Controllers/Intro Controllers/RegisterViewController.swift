//
//  RegisterViewController.swift
//  Studium
//
//  Created by Vikram Singh on 1/31/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import UIKit

import FBSDKLoginKit
import RealmSwift
import GoogleSignIn

class RegisterViewController: FBAndGoogleAuthViewController, UIGestureRecognizerDelegate {
    
    
//    let firestoreDB = Firestore.firestore()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var continueAsGuestButton: UIButton!
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var facebookSignInButton: UIButton!
    @IBOutlet weak var guestSignInButton: UIButton!
    //    @IBOutlet weak var fbViewHolder: UIView!
    
    //UI CONSTANTS
    let iconSize = 30
    let tintColor: UIColor = UIColor(named: "Studium Secondary Theme Color") ?? .black
    let placeHolderColor: UIColor = .placeholderText
    let backgroundColor: UIColor =  UIColor(named: "Studium System Background Color") ?? .systemBackground
    let textFieldBorderWidth: CGFloat = 2

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //Google Sign In Button Code
        googleSignInButton.style = GIDSignInButtonStyle.wide
        googleSignInButton.colorScheme = GIDSignInButtonColorScheme.dark
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        sender = self
        facebookSignInButton.layer.cornerRadius = 10
        facebookSignInButton.addTarget(self, action: #selector(fbLoginButtonClicked), for: .touchUpInside)
        
        guestSignInButton.addTarget(self, action: #selector(handleLoginAsGuest), for: .touchUpInside)

        
        setupUI()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let app = App(id: Secret.appID)
        let client = app.emailPasswordAuth
        let email = emailTextField.text!
        let password = passwordTextField.text!
        client.registerUser(email: email, password: password) { (error) in
            guard error == nil else {
                print("Failed to register: \(error!.localizedDescription)")
                return
            }
            // Registering just registers. You can now log in.
            
            print("Successfully registered user.")
            
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
//                    let defaults = UserDefaults.standard
//                    defaults.setValue(googleUser.profile.email, forKey: "email")
//                    DispatchQueue.main.async {
//                        self.performSegue(withIdentifier: "toWakeUp", sender: self)
//                    }
//                }
//            }
//        }
//    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        print("nav controllerrr \(self.navigationController)")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textFieldEditingDidBegin(_ sender: UITextField) {
        sender.tintColor = tintColor
        sender.layer.borderColor = tintColor.cgColor
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: UITextField) {
        sender.tintColor = .gray
        sender.layer.borderColor = UIColor.gray.cgColor
    }
    
    //this function sets up the textfields (adds the left image and right image.)
    func setupUI(){
//        let loginButton = FBLoginButton()
//        loginButton.center = fbViewHolder.center
//        loginButton.fs_width = fbViewHolder.fs_width
//        loginButton.fs_height = fbViewHolder.fs_height
//        loginButton.fs_left = fbViewHolder.fs_left
//        loginButton.fs_right = fbViewHolder.fs_right
//        loginButton.permissions = ["public_profile", "email"]
//        fbViewHolder.isHidden = true
        
//        view.addSubview(loginButton)
        
        //EMAIL TEXT FIELD SETUP:
        let emailImageView = UIImageView(frame: CGRect(x: iconSize/4, y: iconSize/3, width: iconSize, height: iconSize))
        emailImageView.image = UIImage(systemName: "envelope")
        emailImageView.contentMode = .scaleAspectFit

        let emailView = UIView(frame: CGRect(x: 0, y: 0, width: iconSize/3*4, height: iconSize/3*5))
        emailView.addSubview(emailImageView)
        emailTextField.tintColor = .gray
        emailTextField.leftViewMode = UITextField.ViewMode.always
        emailTextField.leftView = emailView
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.borderColor = UIColor.gray.cgColor
        emailTextField.layer.borderWidth = textFieldBorderWidth
        
        let emailPlaceholderAttributedString = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        emailTextField.attributedPlaceholder = emailPlaceholderAttributedString
        emailTextField.backgroundColor = backgroundColor
        emailTextField.returnKeyType = .done
        emailTextField.delegate = self


        
        //PASSWORD TEXT FIELD SETUP:
        let passwordIconImageView = UIImageView(frame: CGRect(x: iconSize/4, y: iconSize/3, width: iconSize, height: iconSize))
        passwordIconImageView.image = UIImage(systemName: "lock")
        passwordIconImageView.contentMode = .scaleAspectFit

        let passwordIconView = UIView(frame: CGRect(x: 0, y: 0, width: iconSize/3*4, height: iconSize/3*5))
        passwordIconView.addSubview(passwordIconImageView)
        passwordTextField.leftView = passwordIconView
        passwordTextField.leftViewMode = UITextField.ViewMode.always
        
        let passwordEyeImageView = UIImageView(frame: CGRect(x: -iconSize/4, y: iconSize/3, width: iconSize, height: iconSize))
        passwordEyeImageView.image = UIImage(systemName: "eye")
        passwordEyeImageView.contentMode = .scaleAspectFit

        let passwordEyeView = UIView(frame: CGRect(x: 0, y: 0, width: iconSize/3*4, height: iconSize/3*5))
        passwordEyeView.addSubview(passwordEyeImageView)
        passwordTextField.tintColor = .gray
        passwordTextField.rightViewMode = UITextField.ViewMode.always
        passwordTextField.rightView = passwordEyeView
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.borderWidth = textFieldBorderWidth
        
        let passwordPlaceholderAttributedString = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        passwordTextField.attributedPlaceholder = passwordPlaceholderAttributedString
        passwordTextField.backgroundColor = backgroundColor
        passwordTextField.returnKeyType = .done
        passwordTextField.delegate = self
        
        
        signUpButton.backgroundColor = tintColor
        signUpButton.layer.cornerRadius = 10
        signUpButton.setTitleColor(.white, for: .normal)
    
        continueAsGuestButton.tintColor = tintColor
    }
    
}
