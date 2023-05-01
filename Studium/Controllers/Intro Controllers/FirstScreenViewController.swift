//
//  FirstScreenViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/16/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

// TODO: Docstrings
class FirstScreenViewController: UIViewController {
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("Nav controller: \(self.navigationController)")
        //the user has already completed the intro steps, skip this screen.
        if defaults.bool(forKey: "didFinishIntro") == true{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainTabController")
            self.present(vc, animated: false)
        }
    }
}
