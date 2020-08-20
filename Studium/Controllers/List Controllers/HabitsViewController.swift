//
//  SettingsViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class HabitsViewController: SwipeTableViewController, HabitRefreshProtocol {
    //let realm = try! Realm()
    var habits: Results<Habit>?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "HabitCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 100
    }
    override func viewWillAppear(_ animated: Bool) {
        loadHabits()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let addHabitViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddHabitViewController") as! AddHabitViewController
        addHabitViewController.delegate = self
        let navController = UINavigationController(rootViewController: addHabitViewController)
//        ColorPickerCell.color = K.defaultColorPickerColor
        self.present(navController, animated:true, completion: nil)
        
    }
    
    func loadHabits(){
        habits = realm.objects(Habit.self)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! HabitCell
        if let habit = habits?[indexPath.row]{
            cell.loadData(from: habit)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func updateModelEdit(at indexPath: IndexPath) {
        let deletableEventCell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        
        let eventForEdit = deletableEventCell.event! as! Habit
        let addHabitViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddHabitViewController") as! AddHabitViewController
        addHabitViewController.delegate = self
        addHabitViewController.habit = eventForEdit
        ColorPickerCell.color = UIColor(hexString: eventForEdit.color)
        addHabitViewController.title = "View/Edit Habit"
        let navController = UINavigationController(rootViewController: addHabitViewController)
        self.present(navController, animated:true, completion: nil)
        
    }
}
