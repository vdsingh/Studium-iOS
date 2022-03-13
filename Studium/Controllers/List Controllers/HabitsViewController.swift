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
    var habitsArr: [[Habit]] = [[],[]]
    let defaults = UserDefaults.standard
    
    let sectionHeaders: [String] = ["Today", "Not Today"]
    
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
        habitsArr = [[],[]]
        for habit in habits!{
            if habit.days.contains(Date().week){
                habitsArr[0].append(habit)
            }else{
                habitsArr[1].append(habit)
            }
        }
        
        //sort all the habits happening today by startTime (the ones that are first come first in the list)
        habitsArr[0].sort(by: {$0.startDate.format(with: "HH:mm") < $1.startDate.format(with: "HH:mm")})
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitsArr[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! RecurringEventCell
        let habit = habitsArr[indexPath.section][indexPath.row]
        cell.event = habit
        cell.loadData(courseName: habit.name, location: habit.location, startTime: habit.startDate, endTime: habit.endDate, days: habit.days, colorHex: habit.color, recurringEvent: habit, systemImageString: habit.systemImageString)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
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
        let habit = self.habitsArr[indexPath.section][indexPath.row]
        do{
            try realm.write{
                habit.deleteNotifications()
            }
        }catch{
            print("ERROR: error deleting habit notifications.")
        }
        super.updateModelDelete(at: indexPath)
    }
}
