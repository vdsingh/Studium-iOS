//
//  RegisterViewController.swift
//  Studium
//
//  Created by Vikram Singh on 1/31/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    let firestoreDB = Firestore.firestore()
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
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
            if error == nil{
                if let email = Auth.auth().currentUser?.email{
//                    self.firestoreDB.collection("users").addDocument(data: ["email": email])
                    self.firestoreDB.collection("users").document(email).setData(["email": email])

                    self.performSegue(withIdentifier: "toWakeUp", sender: self)
                }
            }else{
                print(error!)
            }
        }
    }
    
    @IBAction func haveAccountButtonPressed(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)

    }
}
