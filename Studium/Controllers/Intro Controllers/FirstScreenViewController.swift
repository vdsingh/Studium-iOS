//
//  FirstScreenViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/16/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController {
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        //the user has already completed the intro steps, skip this screen.
        if defaults.bool(forKey: "didFinishIntro") == true{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainTabController")
            self.present(vc, animated: false)
        }
    } 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
