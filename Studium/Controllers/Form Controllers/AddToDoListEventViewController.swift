//
//  AddToDoListEvent.swift
//  Studium
//
//  Created by Vikram Singh on 6/26/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftUI

// TODO: Docstrings
protocol ToDoListRefreshProtocol {
    
    // TODO: Docstrings
    func reloadData()
}

/// Form to add a To-Do List Event
class AddToDoListEventViewController: MasterForm {
    
    /// tracks the event being edited, if one is being edited.
    var otherEvent: OtherEvent?
    
    /// link to the list of OtherEvents, so that when a new ToDo Event is created, the list refreshes.
    var delegate: ToDoListRefreshProtocol?
    
    // TODO: Docstrings
    @IBOutlet weak var navButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        self.setCells()
        super.viewDidLoad()
        
        //makes it so that the form doesn't have a bunch of empty cells at the bottom
        tableView.tableFooterView = UIView()
        
        if let otherEvent = otherEvent {
            fillForm(with: otherEvent)
        } else {
            navButton.image = UIImage(systemName: "plus")
            //we are creating a new ToDoEvent
//            if UserDefaults.standard.object(forKey: K.defaultNotificationTimesKey) != nil {
//                print("LOG: Loading User's Default Notification Times for ToDoEvent Form.")
//                alertTimes = UserDefaults.standard.value(forKey: K.defaultNotificationTimesKey) as! [Int]
//            }
        }
    }
    
    // TODO: Docstrings
    func setCells() {
        self.cells = [
            [
                .labelCell(cellText: "This Event is a Course Assignment", onClick: self.isAssignmentClicked)
            ],
            [
                .textFieldCell(placeholderText: "Name", text: self.name, id: FormCellID.TextFieldCell.nameTextField, textFieldDelegate: self, delegate: self),
                .textFieldCell(placeholderText: "Location", text: self.location, id: FormCellID.TextFieldCell.locationTextField, textFieldDelegate: self, delegate: self),
                .labelCell(cellText: "Remind Me", cellAccessoryType: .disclosureIndicator, onClick: self.navigateToAlertTimes)
            ],
            [
                .timeCell(cellText: "Starts", date: self.startDate, dateFormat: .standardTime, timePickerMode: .dateAndTime, id: FormCellID.TimeCell.startTimeCell, onClick: self.timeCellClicked),
                .timeCell(cellText: "Ends", date: self.endDate, dateFormat: .standardTime, timePickerMode: .dateAndTime, id: FormCellID.TimeCell.endTimeCell, onClick: self.timeCellClicked)
            ],
            [
                .textFieldCell(placeholderText: "Additional Details", text: self.additionalDetails, id: FormCellID.TextFieldCell.additionalDetailsTextField, textFieldDelegate: self, delegate: self),
                .labelCell(cellText: "", textColor: .systemRed)
            ]
        ]
    }
    
    // TODO: Docstrings
    //function that is called when the user wants to finish editing in the form and create the new object.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.errors = self.findErrors()
        if self.errors.isEmpty {
            let newEvent = OtherEvent(name: self.name, location: self.location, additionalDetails: self.additionalDetails, startDate: self.startDate, endDate: self.endDate, color: self.color, logo: self.logo, alertTimes: self.alertTimes)
            if let otherEvent = self.otherEvent {
                // We are editing
                self.databaseService.editStudiumEvent(oldEvent: otherEvent, newEvent: newEvent)
            
            } else {
                // We are creating new
                self.databaseService.saveStudiumObject(newEvent)
            }
            
            guard let delegate = delegate else {
                print("$ERR (AddToDoListEventViewController): delegate is nil in AddToDoListEventViewController.")
                return
            }

            delegate.reloadData()
            dismiss(animated: true, completion: nil)
        } else {
            // update the errors cell to show all of the errors with the form
            self.setCells()
            self.replaceLabelText(text: FormError.constructErrorString(errors: self.errors), section: 3, row: 1)
            tableView.reloadData()
        }
    }
    
    //TODO: Docstring
    func findErrors() -> [FormError] {
        var errors = [FormError]()
        if self.name == "" {
            errors.append(.nameNotSpecified)
        }
        
        if startDate > endDate {
            errors.append(.endTimeOccursBeforeStartTime)
        }
        
        return errors
    }
    
    /// Cancel the form
    /// - Parameter sender: The UIBarButtonItem used to cancel the form
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    /// Prepare to segue
    /// - Parameters:
    ///   - segue: The segue
    ///   - sender: The sender
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AlertTableViewController {
            destinationVC.delegate = self
        }
    }
}

// TODO: Docstrings
extension AddToDoListEventViewController: UITextFieldDelegateExt {
    
    // TODO: Docstrings
    func textEdited(sender: UITextField, textFieldID: FormCellID.TextFieldCell) {
        guard let text = sender.text else {
            print("$ ERROR: sender's text was nil. \nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
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
extension AddToDoListEventViewController {
    
    // TODO: Docstrings
    func fillForm(with otherEvent: OtherEvent) {
        print("$ LOG: fillform called in AddToDoListEventController")
        navButton.image = .none
        navButton.title = "Done"
        
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TextFieldCell
        nameCell.textField.text = otherEvent.name
        name = otherEvent.name
        
        let locationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! TextFieldCell
        locationCell.textField.text = otherEvent.location
        location = otherEvent.location
        
        let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! TextFieldCell
        additionalDetailsCell.textField.text = otherEvent.additionalDetails
        additionalDetails = otherEvent.additionalDetails
        
        self.alertTimes = otherEvent.alertTimes

        let startCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! TimeCell
        startDate = otherEvent.startDate
//        startCell.timeLabel.text = startDate.format(with: "MMM d, h:mm a")
//        startCell.date = startDate
        startCell.setDate(startDate)
        
        let endCell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as! TimeCell
        endDate = otherEvent.endDate
        endCell.setDate(endDate)
    }
}

// TODO: Docstrings
extension AddToDoListEventViewController {
    
    // TODO: Docstrings
    private func isAssignmentClicked() {
        let courses = self.databaseService.getStudiumObjects(expecting: Course.self)
        if courses.count != 0 {
            
            // TODO: Fix force typing
            guard let delegate = delegate as? ToDoListViewController else {
                print("$ERR: delegate is not a ToDoListViewController")
                return
            }
            
            self.dismiss(animated: true) {
                
                //make sure that the data in our variables is updated before we transfer it to the new form.
//                    self.retrieveDataFromCells()
                
                //go to the assignment form instead of todo item form. Also provide the assignment form the information from the current form.
                delegate.openAssignmentForm (
                    name: self.name,
                    location: self.location,
                    additionalDetails: self.additionalDetails,
                    alertTimes: self.alertTimes,
                    dueDate: self.endDate
                )
            }
        } else {
            let alert = UIAlertController(title: "No Courses Available", message: "You haven't added any Courses yet. To add an Assignment, please add a Course first.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
}
