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
//    var eventsArray: [[Habit]] = [[],[]]
    let defaults = UserDefaults.standard
    
//    let sectionHeaders: [String] = ["Today:", "Not Today:"]
    
    //keep references to the custom headers so that when we want to change their texts, we can do so. The initial elements are just placeholders, to be replaced when the real headers are created
//    var headerViews: [HeaderView] = [HeaderView(), HeaderView()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        tableView.register(UINib(nibName: "HabitCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "RecurringEventCell", bundle: nil), forCellReuseIdentifier: "Cell")
//        tableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: K.headerCellID)

        tableView.separatorStyle = .none //gets rid of dividers between cells.
        tableView.rowHeight = 140
        
        sectionHeaders = ["Today:", "Not Today:"]
        eventTypeString = "Habits"
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
        eventsArray = [[],[]]
        for habit in habits!{
            if habit.days.contains(Date().week){
                eventsArray[0].append(habit)
            }else{
                eventsArray[1].append(habit)
            }
        }
        
        //sort all the habits happening today by startTime (the ones that are first come first in the list)
        eventsArray[0].sort(by: {$0.startDate.format(with: "HH:mm") < $1.startDate.format(with: "HH:mm")})
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! RecurringEventCell
        let habit = eventsArray[indexPath.section][indexPath.row] as! Habit
        cell.event = habit
        cell.loadData(courseName: habit.name, location: habit.location, startTime: habit.startDate, endTime: habit.endDate, days: habit.days, colorHex: habit.color, recurringEvent: habit, systemImageString: habit.systemImageString)
    
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
        let cell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        let habit: Habit = cell.event as! Habit
        print("LOG: attempting to delete Habit \(habit.name) at section \(indexPath.section) and row \(indexPath.row)")
        eventsArray[indexPath.section].remove(at: indexPath.row)
        RealmCRUD.deleteHabit(habit: habit)
    }
}
