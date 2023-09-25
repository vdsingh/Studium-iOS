//
//  AddHabitViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/27/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import FlexColorPicker

enum TextFieldCharLimit: Int {
    case shortField = 100
    case longField = 300
}

/// Guarantees that the Habit list has a method that allows it to refresh.
protocol HabitRefreshProtocol {
    
    // TODO: Docstrings
    func loadHabits()
}

/// Class used to manage the form for adding a Habit. The form is a tableView form, similar to adding an event in
class DEPRECATEDAddHabitViewController: MasterForm, AlertTimeSelectingForm, LogoSelectingForm, Coordinated, Storyboarded {
    
    // TODO: Docstrings
    weak var coordinator: HabitsCoordinator?
    
    // TODO: Docstrings
    var codeLocationString: String = "Add Habit Form"
    
    /// The habit that we're editing (nil if we're creating a new one)
    var habit: Habit?
        
    /// reference to the Habits list, so that once complete, it can update and show the new Habit
    var delegate: HabitRefreshProtocol?
    
    /// FormCells for when user wants to Autoschedule the habit
    var cellsAuto: [[FormCell]] = [[]]
    
    /// FormCells for when user does not want to Autoschedule the habit
    var cellsNoAuto: [[FormCell]] = [[]]
    
    /// Holders for the cellText and cellType. Basically these hold the above arrays and are used depending on whether the user chooses to use autoschedule or not.
    var cellText: [[String]] = [[]]
    
    // TODO: Docstrings
    var cellType: [[FormCell]] = [[]]

    /// Whether or not this habit is being autoscheduled or not
    var autoschedule = false
    
    /// Whether the user wants this habit to be scheduled earlier or later
    var earlier = true

    // TODO: Docstrings
    @IBOutlet weak var navButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        self.setCells()
        super.viewDidLoad()
        
        //makes it so that the form doesn't have a bunch of empty cells at the bottom
        self.tableView.tableFooterView = UIView()
        self.navButton.image = SystemIcon.plus.createImage()
        if let habit = self.habit {
            self.fillForm(with: habit)
        }
    }
    
    // TODO: Docstrings
    func setCells() {
        self.cellsNoAuto = [
            [
                .textFieldCell(placeholderText: "Name", text: self.name, charLimit: 100, textfieldWasEdited: { text in
                    self.name = text
                }),
                .textFieldCell(placeholderText: "Location", text: self.location, charLimit: 100, textfieldWasEdited: { text in
                    self.location = text
                }),
                .daySelectorCell(daysSelected: self.daysSelected, delegate: self),
                .labelCell(cellText: "Remind Me", icon: StudiumIcon.bell.uiImage, cellAccessoryType: .disclosureIndicator, onClick: { self.showAlertTimesSelectionViewController() })
            ],
            [
                .switchCell(cellText: "Autoschedule", isOn: false, switchDelegate: self, infoDelegate: self),
                .timeCell(cellText: "Start", date: self.startDate, dateFormat: DateFormat.standardTime, timePickerMode: .time, id: .startTimeCell, onClick: self.timeCellClicked),
                .timeCell(cellText: "Finish", date: self.endDate, dateFormat: DateFormat.standardTime, timePickerMode: .time, id: .endTimeCell, onClick: self.timeCellClicked)
            ],
            [
                .logoCell(logo: self.icon.uiImage, onClick: { self.showLogoSelectionViewController() }),
                .colorPickerCellV2(colors: StudiumEventColor.allCasesUIColors, colorWasSelected: { color in
                    self.color = UIColor(color)
                }),
                .textFieldCell(placeholderText: "Additional Details",
                               text: self.additionalDetails,
                               charLimit: 300,
                               textfieldWasEdited: { text in
                                   self.additionalDetails = text
                               })
            ],
            [
                .errorCell(errors: self.errors)
            ]
        ]
        
        self.cellsAuto = [
            [
                .textFieldCell(placeholderText: "Name", text: self.name, charLimit: TextFieldCharLimit.shortField.rawValue, textfieldWasEdited: { text in
                    self.name = text
                }),
                .textFieldCell(placeholderText: "Location", text: self.location, charLimit: TextFieldCharLimit.shortField.rawValue, textfieldWasEdited: { text in
                    self.location = text
                }),
                .daySelectorCell(daysSelected: self.daysSelected, delegate: self),
                .labelCell(cellText: "Remind Me", icon: StudiumIcon.bell.uiImage, cellAccessoryType: .disclosureIndicator, onClick: { self.showAlertTimesSelectionViewController() })
            ],
            [
                .switchCell(cellText: "Autoschedule", isOn: true, switchDelegate: self, infoDelegate: self),
                .timeCell(cellText: "Between", date: self.startDate, dateFormat: DateFormat.standardTime, timePickerMode: .time, id: .startTimeCell, onClick: self.timeCellClicked),
                .timeCell(cellText: "And", date: self.endDate, dateFormat: DateFormat.standardTime, timePickerMode: .time, id: .endTimeCell, onClick: self.timeCellClicked),
                .pickerCell(cellText: "Length of Habit", indices: self.lengthPickerIndices, tag: .lengthPickerCell, delegate: self, dataSource: self)
            ],
            [
                .logoCell(logo: self.icon.uiImage, onClick: { self.showLogoSelectionViewController() }),
                .colorPickerCellV2(colors: StudiumEventColor.allCasesUIColors, colorWasSelected: { color in
                    self.color = UIColor(color)
                }),
                .textFieldCell(placeholderText: "Additional Details", text: self.additionalDetails, charLimit: TextFieldCharLimit.longField.rawValue, textfieldWasEdited: { text in
                    self.additionalDetails = text
                })
            ],
            [
                .errorCell(errors: self.errors)
            ]
        ]
        
        self.cells = self.autoschedule ? self.cellsAuto : self.cellsNoAuto
    }
    
    //MARK: - UIElement IBActions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.errors = self.findErrors()

        // TODO: FIX FORCE UNWRAP
        self.endDate = Calendar.current.date(bySettingHour: self.endDate.hour, minute: self.endDate.minute, second: self.endDate.second, of: self.startDate)!
        
        var autoschedulingConfig: AutoschedulingConfig? = nil
        if let autoMinutes = self.totalLengthMinutes {
            AutoschedulingConfig(
                autoLengthMinutes: autoMinutes,
                autoscheduleInfinitely: true,
                useDatesAsBounds: false,
                autoschedulingDays: self.daysSelected
            )
        }
        
        // there are no errors.
        if self.errors.isEmpty {
            let newHabit = Habit(
                name: name,
                location: location,
                additionalDetails: additionalDetails,
                startDate: startDate,
                endDate: self.endDate,
                autoschedulingConfig: autoschedulingConfig,
                alertTimes: self.alertTimes,
                days: self.daysSelected,
                icon: self.icon,
                color: color
            )
            
            if let editingHabit = self.habit {
                self.studiumEventService.updateStudiumEvent(oldEvent: editingHabit, updatedEvent: newHabit)
            } else {
                // DatabaseService handles autoscheduling
                self.studiumEventService.saveStudiumEvent(newHabit)
            }
            
            self.dismiss(animated: true) {
                if let del = self.delegate {
                    del.loadHabits()
                } else {
                    print("$ERR (AddHabitViewController): delegate was not defined.")
                }
            }
        } else {
            self.reloadData()
            self.scrollToBottomOfTableView()
        }
    }
    
    //TODO: Docstring
    override func findErrors() -> [StudiumFormError] {
        var errors = [StudiumFormError]()
        
        errors.append(contentsOf: super.findErrors())
        
        if self.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append(.nameNotSpecified)
        }
        
        if self.daysSelected.isEmpty {
            errors.append(.oneDayNotSpecified)
        }
        
        if self.autoschedule && self.totalLengthMinutes == 0 {
            errors.append(.totalTimeNotSpecified)
        } else if self.endDate < self.startDate {
            errors.append(.endTimeOccursBeforeStartTime)
        } else if self.autoschedule, let autoMinutes = self.totalLengthMinutes {
            let timeChunk = TimeChunk(startDate: self.startDate, endDate: self.endDate)
            if timeChunk.lengthInMinutes < autoMinutes {
                errors.append(.totalTimeExceedsTimeFrame)
            }
        }
        
        return errors
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    //MARK: - TableView helpers
    
    /// reset cell data and reloads tableView
    func reloadData(){
        self.setCells()
        self.tableView.reloadData()
    }
}

// TODO: Docstrings
extension DEPRECATEDAddHabitViewController: DaySelectorDelegate {
    
    // TODO: Docstrings
    func updateDaysSelected(weekdays: Set<Weekday>) {
        self.daysSelected = weekdays
    }
}

// TODO: Docstrings
extension DEPRECATEDAddHabitViewController: ColorDelegate {
    
    // TODO: Docstrings
    func colorPickerValueChanged(sender: RadialPaletteControl) {
        self.color = sender.selectedColor
        print("$LOG: Changed color")
    }
}

// TODO: Docstrings
extension DEPRECATEDAddHabitViewController: SegmentedControlDelegate {
    
    // TODO: Docstrings
    func controlValueChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            earlier = true
        } else {
            earlier = false
        }
    }
}

//MARK: - Switch Delegate
extension DEPRECATEDAddHabitViewController: CanHandleSwitch {
    
    /// Method triggered when the autoschedule switch is triggered
    /// - Parameter sender: The switch used
    func switchValueChanged(sender: UISwitch) {
        if sender.isOn { //auto schedule
            self.cells = self.cellsAuto
            self.autoschedule = true
        } else {
            self.cells = self.cellsNoAuto
            self.autoschedule = false
        }
        
        self.reloadData()
    }
}

// TODO: Docstrings
extension DEPRECATEDAddHabitViewController: CanHandleInfoDisplay {
    
    /// Displays information via an Alert
    func displayInformation() {
        let alert = UIAlertController(
            title: "Autoscheduling",
            message: "We'll analyze your schedule and find time for you to work on this!",
            preferredStyle: UIAlertController.Style.alert
        )
        
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in }))
        self.present(alert, animated: true, completion: nil)
    }
}

// TODO: Docstrings
extension DEPRECATEDAddHabitViewController {
    
    /// Fills the FormCells with information from a provided habit
    /// - Parameter habit: The habit that we want to fill the Form with
    func fillForm(with habit: Habit) {
        
        self.navButton.image = .none
        self.navButton.title = "Done"
        self.name = habit.name
        self.location = habit.location
        self.daysSelected = habit.days
        self.alertTimes = habit.alertTimes
        self.icon = habit.icon
        self.color = habit.color
        self.additionalDetails = habit.additionalDetails
        self.startDate = habit.startDate
        self.endDate = habit.endDate
        self.autoschedule = habit.autoscheduling
        self.totalLengthMinutes = habit.autoschedulingConfig?.autoLengthMinutes
        
        self.setCells()
        self.tableView.reloadData()
    }
}
