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
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        tableView.register(UINib(nibName: "HabitCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "RecurringEventCell", bundle: nil), forCellReuseIdentifier: "Cell")

        
        tableView.separatorStyle = .none //gets rid of dividers between cells.
        tableView.rowHeight = 140
    }
    override func viewWillAppear(_ animated: Bool) {
        loadHabits()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let addHabitViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddHabitViewController") as! AddHabitViewController
        addHabitViewController.delegate = self
        let navController = UINavigationController(rootViewController: addHabitViewController)
//        if defaults.string(forKey: "themeColor") != nil{
//            ColorPickerCell.color = UIColor(hexString: defaults.string(forKey: "themeColor")!)
//        }else{
//            ColorPickerCell.color = K.defaultThemeColor
//        }
        ColorPickerCell.color = .white
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
//        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! HabitCell
//        if let habit = habits?[indexPath.row]{
//            cell.loadData(from: habit)
//        }
//        return cell
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! RecurringEventCell
        if let habit = habits?[indexPath.row]{
            cell.event = habit
            //            cell.deloadData()
            cell.loadData(courseName: habit.name, location: habit.location, startTime: habit.startDate, endTime: habit.endDate, days: habit.days, colorHex: habit.color, recurringEvent: habit, systemImageString: habit.systemImageString)
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
    
    override func updateModelDelete(at indexPath: IndexPath) {
        let habit = self.habits![indexPath.row]
        //        print("Course Deleting: \(course.name)")
        do{
            try realm.write{
                habit.deleteNotifications()
            }
        }catch{
            print("error deleting habit.")
        }
        
        
        super.updateModelDelete(at: indexPath)
    }
}
