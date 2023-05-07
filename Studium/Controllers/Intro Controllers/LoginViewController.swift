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


class LoginViewController: AuthViewController, UIGestureRecognizerDelegate{
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var guestSignInButton: UIButton!
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var facebookSignInButton: UIButton!
    //    @IBOutlet weak var fbLoginView: UIView!
//    @IBOutlet weak var fbViewHolder: UIView!
//    let app = App(id: Secret.appID)

    
    //UI CONSTANT PARAMETERS: these parameters control elements of the UI
    let textFieldIconSize = 30
    let tintColor: UIColor = UIColor(named: "Studium Secondary Theme Color") ?? .black
    let placeHolderColor: UIColor = .placeholderText
    let backgroundColor: UIColor =  UIColor(named: "Studium System Background Color") ?? StudiumColor.background.uiColor
    
    
    let textFieldBorderWidth: CGFloat = 2
    
    override func viewDidLoad() {
        setupUI()
        view.backgroundColor = backgroundColor
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        self.setSelectors()


    }
    
    private func setSelectors() {
        self.googleSignInButton.addTarget(self, action: #selector(googleLoginClicked), for: .touchUpInside)
        self.facebookSignInButton.addTarget(self, action: #selector(fbLoginButtonClicked), for: .touchUpInside)
        self.guestSignInButton.addTarget(self, action: #selector(guestLoginClicked), for: .touchUpInside)
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
        self.emailPasswordLoginClicked(email: email, password: password)
    }
    
    //this function sets up the textfields (adds the left image and right image.)
    func setupUI(){
        
        self.signInButton.tintColor = StudiumColor.secondaryAccent.uiColor
        self.googleSignInButton.style = GIDSignInButtonStyle.wide
        self.facebookSignInButton.layer.cornerRadius = 10

        //EMAIL TEXT FIELD SETUP:
        let emailImageView = UIImageView(frame: CGRect(x: textFieldIconSize/4, y: textFieldIconSize/3, width: textFieldIconSize, height: textFieldIconSize))
        emailImageView.image = UIImage(systemName: "envelope")
        emailImageView.contentMode = .scaleAspectFit

        let emailView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldIconSize/3*4, height: textFieldIconSize/3*5))
        emailView.addSubview(emailImageView)
        self.emailTextField.tintColor = .gray
        self.emailTextField.leftViewMode = UITextField.ViewMode.always
        self.emailTextField.leftView = emailView
        self.emailTextField.layer.masksToBounds = true
        self.emailTextField.layer.cornerRadius = 10
        self.emailTextField.layer.masksToBounds = true
        self.emailTextField.layer.borderColor = UIColor.gray.cgColor
        self.emailTextField.layer.borderWidth = textFieldBorderWidth
        
        let emailPlaceholderAttributedString = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        self.emailTextField.attributedPlaceholder = emailPlaceholderAttributedString
        self.emailTextField.backgroundColor = backgroundColor
        self.emailTextField.returnKeyType = .done
        self.emailTextField.delegate = self


        
        //PASSWORD TEXT FIELD SETUP:
        let passwordIconImageView = UIImageView(frame: CGRect(x: textFieldIconSize/4, y: textFieldIconSize/3, width: textFieldIconSize, height: textFieldIconSize))
        passwordIconImageView.image = UIImage(systemName: "lock")
        passwordIconImageView.contentMode = .scaleAspectFit

        let passwordIconView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldIconSize/3*4, height: textFieldIconSize/3*5))
        passwordIconView.addSubview(passwordIconImageView)
        self.passwordTextField.leftView = passwordIconView
        self.passwordTextField.leftViewMode = UITextField.ViewMode.always
        
        let passwordEyeImageView = UIImageView(frame: CGRect(x: -textFieldIconSize/4, y: textFieldIconSize/3, width: textFieldIconSize, height: textFieldIconSize))
        passwordEyeImageView.image = UIImage(systemName: "eye")
        passwordEyeImageView.contentMode = .scaleAspectFit

        let passwordEyeView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldIconSize/3*4, height: textFieldIconSize/3*5))
        passwordEyeView.addSubview(passwordEyeImageView)
        self.passwordTextField.tintColor = .gray
        self.passwordTextField.rightViewMode = UITextField.ViewMode.always
        self.passwordTextField.rightView = passwordEyeView
        self.passwordTextField.layer.cornerRadius = 10
        self.passwordTextField.layer.masksToBounds = true
        self.passwordTextField.layer.borderColor = UIColor.gray.cgColor
        self.passwordTextField.layer.borderWidth = textFieldBorderWidth
        
        let passwordPlaceholderAttributedString = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        self.passwordTextField.attributedPlaceholder = passwordPlaceholderAttributedString
        self.passwordTextField.backgroundColor = backgroundColor
        self.passwordTextField.returnKeyType = .done
        self.passwordTextField.delegate = self
        
        
        self.signInButton.backgroundColor = tintColor
        self.signInButton.layer.cornerRadius = 10
        self.signInButton.setTitleColor(StudiumColor.primaryLabel.uiColor, for: .normal)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        print("$LOG (LoginViewController): Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        if(navigationController == nil){
            print("$ERR (LoginViewController): NAVIGATION CONTROLLER IS NIL")
        }
    }
    
    //close the keyboard - do nothing
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        return true;
    }
}
