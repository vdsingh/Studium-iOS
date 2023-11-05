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
    
    override func loadView() {
        super.loadView()
        self.emptyDetailIndicatorViewModel = ImageDetailViewModel(
            image: FlatImage.travelingAndSports.uiImage,
            title: "No Habits here yet",
            subtitle: nil,
            buttonText: "Add a Habit",
            buttonAction: self.addButtonPressed
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Habits"

        self.eventTypeString = "Habits"

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none //gets rid of dividers between cells.
        self.tableView.rowHeight = 140
        
        self.sectionHeaders = ["Today:", "Not Today:"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadHabits()
    }
    
    //TODO: Docstrings
    override func addButtonPressed() {
        self.unwrapCoordinatorOrShowError()
        self.coordinator?.showAddHabitViewController(refreshDelegate: self)
    }
    
    //TODO: Docstrings
    func loadHabits() {
        self.habits = self.databaseService.getStudiumObjects(expecting: Habit.self)
        self.eventsArray = [[],[]]
        for habit in self.habits {
            if habit.days.contains(Date().weekdayValue){
                self.eventsArray[0].append(habit)
            } else {
                self.eventsArray[1].append(habit)
            }
        }
        
        // sort all the habits happening today by startTime (the ones that are first come first in the list)
        self.eventsArray[0].sort(by: { $0.startDate.format(with: DateFormat.standardTime) < $1.startDate.format(with: DateFormat.standardTime)})
        self.tableView.reloadData()
        
        self.updateEmptyEventsIndicator()
    }
    
    //TODO: Docstrings
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.swipeCellId = DEPRECATEDRecurringEventCell.id
        if let cell = super.tableView(tableView, cellForRowAt: indexPath) as? DEPRECATEDRecurringEventCell,
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let habit = self.eventsArray[indexPath.section][indexPath.row] as? Habit {
            let vc = HabitViewController(
                habit: habit,
                editButtonPressed: {
                    self.edit(at: indexPath)
                },
                deleteButtonPressed: {
                    PopUpService.presentDeleteAlert {
                        self.delete(at: indexPath)
                    }
                }
            )
            
            self.navigationController?.modalPresentationStyle = .formSheet
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    //TODO: Docstrings
    override func edit(at indexPath: IndexPath) {
        let deletableEventCell = self.tableView.cellForRow(at: indexPath) as! DeletableEventCell
        let eventForEdit = deletableEventCell.event! as! Habit
        self.coordinator?.showEditHabitViewController(refreshDelegate: self, habitToEdit: eventForEdit)
    }
    
    //TODO: Docstrings
    override func delete(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        let habit: Habit = cell.event as! Habit
        self.studiumEventService.deleteStudiumEvent(habit)
        self.eventsArray[indexPath.section].remove(at: indexPath.row)
        super.updateHeader(section: indexPath.section)
        self.updateEmptyEventsIndicator()
    }
}
