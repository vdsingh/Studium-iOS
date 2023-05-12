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

class RegisterViewController: AuthViewController, UIGestureRecognizerDelegate {
    
    //TODO: Docstrings
    @IBOutlet weak var emailTextField: UITextField!
    
    //TODO: Docstrings
    @IBOutlet weak var passwordTextField: UITextField!
    
    //TODO: Docstrings
    @IBOutlet weak var signUpButton: UIButton!
    
    //TODO: Docstrings
    @IBOutlet weak var continueAsGuestButton: UIButton!
    
    //TODO: Docstrings
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    //TODO: Docstrings
    @IBOutlet weak var facebookSignInButton: UIButton!
    
    //TODO: Docstrings
    @IBOutlet weak var guestSignInButton: UIButton!
    
    //UI CONSTANTS
    
    //TODO: Docstrings
    let iconSize = 30
    
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
        signUpButton.tintColor = StudiumColor.secondaryAccent.uiColor
        
        sender = self
        self.facebookSignInButton.layer.cornerRadius = 10
        self.facebookSignInButton.addTarget(self, action: #selector(fbLoginButtonClicked), for: .touchUpInside)
        self.guestSignInButton.addTarget(self, action: #selector(guestLoginClicked), for: .touchUpInside)
        self.signUpButton.addTarget(self, action: #selector(self.registerButtonPressed), for: .touchUpInside)
        
        self.emailTextField.addTarget(self, action: #selector(self.textFieldWasEdited), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldWasEdited), for: .editingChanged)
        self.textFieldWasEdited()
        

        setupUI()

    }
    
    //TODO: Docstrings
    @objc func registerButtonPressed(_ sender: UIButton) {
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        self.emailPasswordRegisterClicked(email: email, password: password)
    }

    //TODO: Docstrings
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        self.signUpButton.isEnabled = !self.email.isEmpty && !self.password.isEmpty && self.email.contains("@")
        self.signUpButton.backgroundColor = self.signUpButton.isEnabled ? StudiumColor.secondaryAccent.uiColor : .gray
    }
    
    //TODO: Docstrings
    func setupUI(){
        
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
        
        
        signUpButton.layer.cornerRadius = 10
        signUpButton.setTitleColor(StudiumColor.primaryLabel.uiColor, for: .normal)
    
        continueAsGuestButton.tintColor = tintColor
    }
}
