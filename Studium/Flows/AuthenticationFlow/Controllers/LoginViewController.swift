//
//  TempLogin.swift
//  Studium
//
//  Created by Vikram Singh on 3/15/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

import VikUtilityKit

//TODO: Docstrings
class LoginViewController: AuthViewController, UIGestureRecognizerDelegate {
    
    //TODO: Docstrings
    @IBOutlet weak var emailTextField: UITextField!
    
    //TODO: Docstrings
    @IBOutlet weak var passwordTextField: UITextField!
    
    //TODO: Docstrings
    @IBOutlet weak var signInButton: UIButton!
    
    //TODO: Docstrings
    @IBOutlet weak var guestSignInButton: UIButton!
    
    //TODO: Docstrings
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    //TODO: Docstrings
    @IBOutlet weak var facebookSignInButton: UIButton!


    //TODO: Docstrings
    let textFieldIconSize = 30
    
    //TODO: Docstrings
    let tintColor: UIColor = UIColor(named: "Studium Secondary Theme Color") ?? .black
    
    //TODO: Docstrings
    let placeHolderColor: UIColor = .placeholderText
    
    //TODO: Docstrings
    let backgroundColor: UIColor =  UIColor(named: "Studium System Background Color") ?? StudiumColor.background.uiColor
    
    //TODO: Docstrings
    let textFieldBorderWidth: CGFloat = 2
    
    //TODO: Docstrings
    var email: String {
        return self.emailTextField.text!
    }
    
    //TODO: Docstrings
    var password: String {
        return self.passwordTextField.text!
    }

    
    override func viewDidLoad() {
        setupUI()
        view.backgroundColor = backgroundColor
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        self.setSelectors()
        
        self.textFieldWasEdited()
    }
    
    //TODO: Docstrings
    private func setSelectors() {
        self.googleSignInButton.addTarget(self, action: #selector(googleLoginClicked), for: .touchUpInside)
        self.facebookSignInButton.addTarget(self, action: #selector(fbLoginButtonClicked), for: .touchUpInside)
        self.guestSignInButton.addTarget(self, action: #selector(guestLoginClicked), for: .touchUpInside)
        
        self.emailTextField.addTarget(self, action: #selector(self.textFieldWasEdited), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldWasEdited), for: .editingChanged)
    }
    
    //TODO: Docstrings
    @IBAction func textFieldEditingDidBegin(_ sender: UITextField) {
        sender.tintColor = tintColor
        sender.layer.borderColor = tintColor.cgColor
    }
    
    //TODO: Docstrings
    @IBAction func textFieldEditingDidEnd(_ sender: UITextField) {
        sender.tintColor = .gray
        sender.layer.borderColor = UIColor.gray.cgColor
    }
    
    //TODO: Docstrings
    @objc func textFieldWasEdited() {
        self.signInButton.isEnabled = !self.email.isEmpty && !self.password.isEmpty && self.email.contains("@")
        self.signInButton.backgroundColor = self.signInButton.isEnabled ? StudiumColor.secondaryAccent.uiColor : .gray
    }
    
    //TODO: Docstrings
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        self.emailPasswordLoginClicked(email: email, password: password)
    }
    
    //TODO: Docstrings
    func setupUI(){
        self.googleSignInButton.colorScheme = GIDSignInButtonColorScheme.dark
        self.googleSignInButton.style = GIDSignInButtonStyle.wide
        self.facebookSignInButton.layer.cornerRadius = 10

        //EMAIL TEXT FIELD SETUP:
        let emailImageView = UIImageView(frame: CGRect(x: textFieldIconSize/4, y: textFieldIconSize/3, width: textFieldIconSize, height: textFieldIconSize))
        emailImageView.image = SystemIcon.envelope.createImage()
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
        passwordIconImageView.image = SystemIcon.lock.createImage()
        passwordIconImageView.contentMode = .scaleAspectFit

        let passwordIconView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldIconSize/3*4, height: textFieldIconSize/3*5))
        passwordIconView.addSubview(passwordIconImageView)
        self.passwordTextField.leftView = passwordIconView
        self.passwordTextField.leftViewMode = UITextField.ViewMode.always
        
        let passwordEyeImageView = UIImageView(frame: CGRect(x: -textFieldIconSize/4, y: textFieldIconSize/3, width: textFieldIconSize, height: textFieldIconSize))
        passwordEyeImageView.image = SystemIcon.eye.createImage()
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
        
        
        self.signInButton.tintColor = StudiumColor.secondaryAccent.uiColor
        self.signInButton.layer.cornerRadius = 10
        self.signInButton.setTitleColor(StudiumColor.primaryLabel.uiColor, for: .normal)
    }
    
    //TODO: Docstrings
    @IBAction func backButtonPressed(_ sender: UIButton) {
        print("$LOG (LoginViewController): Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        if(navigationController == nil){
            print("$ERR (LoginViewController): NAVIGATION CONTROLLER IS NIL")
        }
    }
    
    //TODO: Docstrings
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        return true;
    }
}
