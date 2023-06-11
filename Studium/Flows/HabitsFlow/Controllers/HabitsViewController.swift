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

//TODO: Docstrings
class HabitsViewController: StudiumEventListViewController, HabitRefreshProtocol, Storyboarded, Coordinated {
    
    //TODO: Docstrings
    weak var coordinator: HabitsCoordinator?
    
    //TODO: Docstrings
    var habits: [Habit] = []
    
    override func viewDidLoad() {
        self.eventTypeString = "Habits"

        super.viewDidLoad()

        tableView.separatorStyle = .none //gets rid of dividers between cells.
        tableView.rowHeight = 140
        
        sectionHeaders = ["Today:", "Not Today:"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadHabits()
    }
    
    //TODO: Docstrings
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.unwrapCoordinatorOrShowError()
        self.coordinator?.showAddHabitViewController(refreshDelegate: self)
    }
    
    //TODO: Docstrings
    func loadHabits() {
        self.habits = self.databaseService.getStudiumObjects(expecting: Habit.self)
        eventsArray = [[],[]]
        for habit in self.habits {
            if habit.days.contains(Date().weekdayValue){
                eventsArray[0].append(habit)
            } else {
                eventsArray[1].append(habit)
            }
        }
        
        //sort all the habits happening today by startTime (the ones that are first come first in the list)
        eventsArray[0].sort(by: { $0.startDate.format(with: "HH:mm") < $1.startDate.format(with: "HH:mm" )})
        tableView.reloadData()
    }
    
    //TODO: Docstrings
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.swipeCellId = RecurringEventCell.id
        if let cell = super.tableView(tableView, cellForRowAt: indexPath) as? RecurringEventCell,
           let habit = eventsArray[indexPath.section][indexPath.row] as? Habit {
            cell.event = habit
            cell.loadData(
                courseName: habit.name,
                location: habit.location,
                startTime: habit.startDate,
                endTime: habit.endDate,
                days: habit.days,
                color: habit.color,
                recurringEvent: habit,
                icon: habit.icon
            )
            
            return cell
        }
    
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
    
    //TODO: Docstrings
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //TODO: Docstrings
    override func edit(at indexPath: IndexPath) {
        let deletableEventCell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        let eventForEdit = deletableEventCell.event! as! Habit
        let addHabitViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddHabitViewController") as! AddHabitViewController
        addHabitViewController.delegate = self
        addHabitViewController.habit = eventForEdit
//        ColorPickerCell.color = eventForEdit.color
        addHabitViewController.title = "View/Edit Habit"
        let navController = UINavigationController(rootViewController: addHabitViewController)
        self.present(navController, animated:true, completion: nil)
    }
    
    //TODO: Docstrings
    override func delete(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        let habit: Habit = cell.event as! Habit
        print("LOG: attempting to delete Habit \(habit.name) at section \(indexPath.section) and row \(indexPath.row)")
        
//        RealmCRUD.deleteHabit(habit: habit)
        self.databaseService.deleteStudiumObject(habit)
        eventsArray[indexPath.section].remove(at: indexPath.row)
        super.updateHeader(section: indexPath.section)
    }
}