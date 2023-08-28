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

import TableViewFormKit
import VikUtilityKit

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
class AddHabitViewController: MasterForm, AlertTimeSelectingForm, LogoSelectingForm, Coordinated, Storyboarded {
    
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
        
        //used to decipher which TimeCell should have which dates
//        times = [self.startDate, self.endDate]
        
//        self.cells = self.cellsNoAuto
        
        //makes it so that the form doesn't have a bunch of empty cells at the bottom
        tableView.tableFooterView = UIView()
        
        navButton.image = SystemIcon.plus.createImage()
        if let habit = habit {
//            if habit.autoschedule {
//                self.cells = self.cellsAuto
//                self.reloadData()
//            }
            
            fillForm(with: habit)
        }
        

    }
    
    // TODO: Docstrings
    func setCells() {
        self.cellsNoAuto = [
            [
                .textFieldCell(placeholderText: "Name", text: self.name, charLimit: 100, id: .nameTextField, textFieldDelegate: self, delegate: self),
                .textFieldCell(placeholderText: "Location", text: self.location, charLimit: 100, id: .locationTextField, textFieldDelegate: self, delegate: self),
                .daySelectorCell(daysSelected: self.daysSelected, delegate: self),
                .labelCell(cellText: "Remind Me", icon: StudiumIcon.bell.uiImage, cellAccessoryType: .disclosureIndicator, onClick: { self.showAlertTimesSelectionViewController() })
            ],
            [
                .switchCell(cellText: "Autoschedule", isOn: false, switchDelegate: self, infoDelegate: self),
                .timeCell(cellText: "Start", date: self.startDate, dateFormat: .standardTime, timePickerMode: .time, id: .startTimeCell, onClick: self.timeCellClicked),
                .timeCell(cellText: "Finish", date: self.endDate, dateFormat: .standardTime, timePickerMode: .time, id: .endTimeCell, onClick: self.timeCellClicked)
            ],
            [
                .logoCell(logo: self.icon.uiImage, onClick: { self.showLogoSelectionViewController() }),
//                .colorPickerCell(delegate: self),
                .colorPickerCellV2(colors: StudiumEventColor.allCasesUIColors, colorWasSelected: { color in
                    self.color = UIColor(color)
                }),
                .textFieldCell(placeholderText: "Additional Details",
                               text: self.additionalDetails,
                               charLimit: 300,
                               id: FormCellID.TextFieldCellID.additionalDetailsTextField,
                               textFieldDelegate: self,
                               delegate: self)
            ],
            [
                .errorCell(errors: self.errors)
            ]
        ]
        
        self.cellsAuto = [
            [
                .textFieldCell(placeholderText: "Name", text: self.name, charLimit: TextFieldCharLimit.shortField.rawValue, id: .nameTextField, textFieldDelegate: self, delegate: self),
                .textFieldCell(placeholderText: "Location", text: self.location, charLimit: TextFieldCharLimit.shortField.rawValue, id: .locationTextField, textFieldDelegate: self, delegate: self),
                .daySelectorCell(daysSelected: self.daysSelected, delegate: self),
                .labelCell(cellText: "Remind Me", icon: StudiumIcon.bell.uiImage, cellAccessoryType: .disclosureIndicator, onClick: { self.showAlertTimesSelectionViewController() })
            ],
            [
                .switchCell(cellText: "Autoschedule", isOn: true, switchDelegate: self, infoDelegate: self),
                .timeCell(cellText: "Between", date: self.startDate, dateFormat: .standardTime, timePickerMode: .time, id: .startTimeCell, onClick: self.timeCellClicked),
                .timeCell(cellText: "And", date: self.endDate, dateFormat: .standardTime, timePickerMode: .time, id: .endTimeCell, onClick: self.timeCellClicked),
                .pickerCell(cellText: "Length of Habit", indices: self.lengthPickerIndices, tag: .lengthPickerCell, delegate: self, dataSource: self)
            ],
            [
                .logoCell(logo: self.icon.uiImage, onClick: { self.showLogoSelectionViewController() }),
//                .colorPickerCell(delegate: self),
                .colorPickerCellV2(colors: StudiumEventColor.allCasesUIColors, colorWasSelected: { color in
                    self.color = UIColor(color)
                }),
                .textFieldCell(placeholderText: "Additional Details", text: self.additionalDetails, charLimit: TextFieldCharLimit.longField.rawValue, id: .additionalDetailsTextField, textFieldDelegate: self, delegate: self),
            ],
            [
                .errorCell(errors: self.errors)
            ]
        ]
        
        self.cells = self.autoschedule ? self.cellsAuto : self.cellsNoAuto
    }
    
    //MARK: - UIElement IBActions
    
    // TODO: Docstrings
    //final step that occurs when the user finishes the form and adds the habit
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.errors = self.findErrors()

        // TODO: FIX FORCE UNWRAP
        self.endDate = Calendar.current.date(bySettingHour: self.endDate.hour, minute: self.endDate.minute, second: self.endDate.second, of: self.startDate)!
        
        
        // there are no errors.
        if self.errors.isEmpty {
            let newHabit = Habit(
                name: name,
                location: location,
                additionalDetails: additionalDetails,
                startDate: startDate,
                endDate: self.endDate,
                autoscheduling: autoschedule,
                startEarlier: earlier,
                autoLengthMinutes: totalLengthMinutes,
                alertTimes: self.alertTimes,
                days: daysSelected,
                icon: self.icon,
                color: color,
                partitionKey: AuthenticationService.shared.userID!
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
        
        if self.name == "" {
            errors.append(.nameNotSpecified)
        }
        
        if  self.daysSelected == [] {
            errors.append(.oneDayNotSpecified)
        }
        
        if self.autoschedule && self.totalLengthMinutes == 0 {
            errors.append(.totalTimeNotSpecified)
        } else if self.endDate < self.startDate {
            errors.append(.endTimeOccursBeforeStartTime)
        } else if self.autoschedule && (self.endDate.hour - self.startDate.hour) * 60 + (self.endDate.minute - self.startDate.minute) < self.totalLengthMinutes {
            errors.append(.totalTimeExceedsTimeFrame)
        }
        
        return errors
    }
    
    // TODO: Docstrings
    // Handles whenever the user decides to cancel.
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    //MARK: - TableView helpers
    
    // TODO: Docstrings
    //reset data and reloads tableView
    func reloadData(){
        self.setCells()
//        self.cells = self.autoschedule ? self.cellsAuto : self.cellsNoAuto
        tableView.reloadData()
    }
}

//MARK: - Picker DataSource
//extension AddHabitViewController: UIPickerViewDataSource {
//
//    //how many rows in the picker view, given the component
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if component == 0 { //hours
//            return 24
//        }
//        //minutes
//        return 60
//    }
//
//    //number of components in the pickerView
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
//}

//MARK: - Picker Delegate
//extension AddHabitViewController: UIPickerViewDelegate{
//    
//    //determines the text in each row, given the row and component
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if component == 0{
//            return "\(row) hours"
//        }
//        return "\(row) min"
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let lengthIndex = cellText[1].lastIndex(of: "Length of Habit")
//        let timeCell = tableView.cellForRow(at: IndexPath(row: lengthIndex!, section: 1)) as! TimeCell
//        totalLengthHours = pickerView.selectedRow(inComponent: 0)
//        totalLengthMinutes = pickerView.selectedRow(inComponent: 1)
//        timeCell.timeLabel.text = "\(totalLengthHours) hours \(totalLengthMinutes) mins"
//    }
//}


// TODO: Docstrings
extension AddHabitViewController: DaySelectorDelegate {
    
    // TODO: Docstrings
    func updateDaysSelected(weekdays: Set<Weekday>) {
        self.daysSelected = weekdays
    }
}

// TODO: Docstrings
extension AddHabitViewController: UITextFieldDelegateExtension {
    
    // TODO: Docstrings
    func textEdited(sender: UITextField, textFieldID: FormCellID.TextFieldCellID) {
        guard let text = sender.text else {
            print("$ERR: sender's text is nil when editing text.")
            return
        }
        
        switch textFieldID {
        case .nameTextField:
            self.name = text
        case .locationTextField:
            self.location = text
        case .additionalDetailsTextField:
            self.additionalDetails = text
        }
    }
}

// TODO: Docstrings
extension AddHabitViewController: ColorDelegate {
    
    // TODO: Docstrings
    func colorPickerValueChanged(sender: RadialPaletteControl) {
        self.color = sender.selectedColor
        print("$LOG: Changed color")
    }
}

// TODO: Docstrings
extension AddHabitViewController: SegmentedControlDelegate {
    
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
extension AddHabitViewController: CanHandleSwitch {
    
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
extension AddHabitViewController: CanHandleInfoDisplay {
    
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
extension AddHabitViewController {
    
    /// Fills the FormCells with information from a provided habit
    /// - Parameter habit: The habit that we want to fill the Form with
    func fillForm(with habit: Habit) {
        printDebug("Filling form for habit: \(habit.name)")
        
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
        self.totalLengthMinutes = habit.autoLengthMinutes
        
        self.setCells()
        self.tableView.reloadData()
    }
}
