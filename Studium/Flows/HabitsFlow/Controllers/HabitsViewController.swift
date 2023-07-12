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
import SwiftUI

//TODO: Docstrings
class HabitsViewController: StudiumEventListViewController, HabitRefreshProtocol, Storyboarded, Coordinated {
    
    //TODO: Docstrings
    weak var coordinator: HabitsCoordinator?
    
    //TODO: Docstrings
    var habits: [Habit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Habits"

        self.eventTypeString = "Habits"

        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.separatorStyle = .none //gets rid of dividers between cells.
        self.tableView.rowHeight = 140
        
        self.sectionHeaders = ["Today:", "Not Today:"]
        
        self.emptyDetailIndicator.setImage(FlatImage.travelingAndSports.uiImage)
        self.emptyDetailIndicator.setTitle("No Habits here yet")
        self.emptyDetailIndicator.setSubtitle("Tap + to add a Habit")
        self.emptyDetailIndicator.configureButton(buttonText: "Button") { button in
            self.studiumEventService.updateNextTenAssignments()
            let assignmentsModels = AssignmentsWidgetDataService.shared.getAssignments()
            button.setTitle("\(assignmentsModels.map({ $0.name }))", for: .normal)
            WidgetsService.shared.reloadAssignmentsWidget()
        }
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
        eventsArray = [[],[]]
        for habit in self.habits {
            if habit.days.contains(Date().weekdayValue){
                eventsArray[0].append(habit)
            } else {
                eventsArray[1].append(habit)
            }
        }
        
        // sort all the habits happening today by startTime (the ones that are first come first in the list)
        eventsArray[0].sort(by: { $0.startDate.format(with: "HH:mm") < $1.startDate.format(with: "HH:mm" )})
        self.tableView.reloadData()
        
        self.updateEmptyEventsIndicator()
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
        self.coordinator?.showEditHabitViewController(refreshDelegate: self, habitToEdit: eventForEdit )
    }
    
    //TODO: Docstrings
    override func delete(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        let habit: Habit = cell.event as! Habit
        self.studiumEventService.deleteStudiumEvent(habit)
        eventsArray[indexPath.section].remove(at: indexPath.row)
        super.updateHeader(section: indexPath.section)
        self.updateEmptyEventsIndicator()
    }
}
