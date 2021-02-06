//
//  RegisterViewController.swift
//  Studium
//
//  Created by Vikram Singh on 1/31/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift

class RegisterViewController: UIViewController {
//    let firestoreDB = Firestore.firestore()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
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
    
    @IBAction func haveAccountButtonPressed(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)

    }
}
