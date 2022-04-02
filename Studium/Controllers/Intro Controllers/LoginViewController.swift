//
//  TempLogin.swift
//  Studium
//
//  Created by Vikram Singh on 3/15/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//
import Foundation
import UIKit

//AUTHENTICATION
import RealmSwift
import GoogleSignIn
//import FacebookLogin
import FBSDKLoginKit


class LoginViewController: FBAndGoogleAuthViewController, UIGestureRecognizerDelegate{
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var guestSignInButton: UIButton!
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var facebookSignInButton: UIButton!
    //    @IBOutlet weak var fbLoginView: UIView!
//    @IBOutlet weak var fbViewHolder: UIView!
    let app = App(id: Secret.appID)

    
    //UI CONSTANT PARAMETERS: these parameters control elements of the UI
    let textFieldIconSize = 30
    let tintColor: UIColor = UIColor(named: "Studium Secondary Theme Color") ?? .black
    let placeHolderColor: UIColor = .placeholderText
    let backgroundColor: UIColor =  UIColor(named: "Studium System Background Color") ?? .systemBackground
    
    
    let textFieldBorderWidth: CGFloat = 2
    
    override func viewDidLoad() {
        setupUI()
        view.backgroundColor = backgroundColor
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        //Google Sign In Button Code
        googleSignInButton.style = GIDSignInButtonStyle.wide
        googleSignInButton.colorScheme = GIDSignInButtonColorScheme.dark
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        sender = self
        facebookSignInButton.addTarget(self, action: #selector(fbLoginButtonClicked), for: .touchUpInside)
        facebookSignInButton.layer.cornerRadius = 10
        guestSignInButton.addTarget(self, action: #selector(handleLoginAsGuest), for: .touchUpInside)


    }
    
    @IBAction func textFieldEditingDidBegin(_ sender: UITextField) {
        sender.tintColor = tintColor
        sender.layer.borderColor = tintColor.cgColor
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: UITextField) {
        sender.tintColor = .gray
        sender.layer.borderColor = UIColor.gray.cgColor
    }
    
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
    
    //this function sets up the textfields (adds the left image and right image.)
    func setupUI(){
//        googleSignInButton.fs_left = 20
//        googleSignInButton.fs_right = 20
//        googleSignInButton.fs_height = 50
//        
//        let loginButton = FBLoginButton()
//        loginButton.center = fbViewHolder.center
//        loginButton.fs_width = fbViewHolder.fs_width
//        loginButton.fs_height = fbViewHolder.fs_height
//        loginButton.fs_left = fbViewHolder.fs_left
//        loginButton.fs_right = fbViewHolder.fs_right
//        
//        loginButton.permissions = ["public_profile", "email"]
//        fbViewHolder.isHidden = true
//        view.addSubview(loginButton)

        //EMAIL TEXT FIELD SETUP:
        let emailImageView = UIImageView(frame: CGRect(x: textFieldIconSize/4, y: textFieldIconSize/3, width: textFieldIconSize, height: textFieldIconSize))
        emailImageView.image = UIImage(systemName: "envelope")
        emailImageView.contentMode = .scaleAspectFit

        let emailView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldIconSize/3*4, height: textFieldIconSize/3*5))
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
        let passwordIconImageView = UIImageView(frame: CGRect(x: textFieldIconSize/4, y: textFieldIconSize/3, width: textFieldIconSize, height: textFieldIconSize))
        passwordIconImageView.image = UIImage(systemName: "lock")
        passwordIconImageView.contentMode = .scaleAspectFit

        let passwordIconView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldIconSize/3*4, height: textFieldIconSize/3*5))
        passwordIconView.addSubview(passwordIconImageView)
        passwordTextField.leftView = passwordIconView
        passwordTextField.leftViewMode = UITextField.ViewMode.always
        
        let passwordEyeImageView = UIImageView(frame: CGRect(x: -textFieldIconSize/4, y: textFieldIconSize/3, width: textFieldIconSize, height: textFieldIconSize))
        passwordEyeImageView.image = UIImage(systemName: "eye")
        passwordEyeImageView.contentMode = .scaleAspectFit

        let passwordEyeView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldIconSize/3*4, height: textFieldIconSize/3*5))
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
        
        
        signInButton.backgroundColor = tintColor
        signInButton.layer.cornerRadius = 10
        signInButton.setTitleColor(.white, for: .normal)
    
//        continueAsGuestButton.tintColor = tintColor
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        if(navigationController == nil){
            print("NAVIGATION CONTROLLER IS NIL")
        }
    }
    
    //close the keyboard - do nothing
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        return true;
    }
}
