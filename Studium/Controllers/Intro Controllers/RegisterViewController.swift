//
//  RegisterViewController.swift
//  Studium
//
//  Created by Vikram Singh on 1/31/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleSignIn

class RegisterViewController: UIViewController {
//    let firestoreDB = Firestore.firestore()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var continueAsGuestButton: UIButton!
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    //UI CONSTANTS
    let iconSize = 30
    let tintColor: UIColor = UIColor(named: "Studium Secondary Theme Color") ?? .black
    let placeHolderColor: UIColor = .placeholderText
    let backgroundColor: UIColor =  UIColor(named: "Studium System Background Color") ?? .systemBackground
    let textFieldBorderWidth: CGFloat = 2

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var stringOne = "Already have an account?"
        let stringTwo = "Sign Up."

        let range = (stringOne as NSString).range(of: stringTwo)

        let attributedText = NSMutableAttributedString.init(string: stringOne)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue , range: range)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
        
//        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
//        emailTextField.layer.borderColor = UIColor.gray.cgColor
//        emailTextField.layer.borderWidth = 1
//        emailTextField.layer.cornerRadius = 10
//
//
//        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
//        passwordTextField.layer.borderColor = UIColor.gray.cgColor
//        passwordTextField.layer.borderWidth = 1
//        passwordTextField.layer.cornerRadius = 10
//
//
//
//        signUpButton.layer.cornerRadius = 10
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
