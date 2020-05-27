//
//  SettingsViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class HabitsViewController: UITableViewController, HabitRefreshProtocol {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("add button pressed was called.")
        if let board = self.storyboard{
            let addHabitViewController = board.instantiateViewController(withIdentifier: "AddHabitViewController") as! AddHabitViewController
            addHabitViewController.delegate = self
            self.present(addHabitViewController, animated: true, completion: nil)
        }else{
            print("story board is nil")
        }
    }
    
    func loadHabits(){
        
    }
}
