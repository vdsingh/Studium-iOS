//
//  AddToDoListEvent.swift
//  Studium
//
//  Created by Vikram Singh on 6/26/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift
import TableViewFormKit
import VikUtilityKit

// TODO: Docstrings
protocol ToDoListRefreshProtocol {
    
    // TODO: Docstrings
    func reloadData()
}

/// Form to add a To-Do List Event
class AddToDoListEventViewController: MasterForm, AlertTimeSelectingForm, Coordinated {
    
    // TODO: Docstrings
    weak var coordinator: ToDoCoordinator?
    
    /// tracks the event being edited, if one is being edited.
    var otherEvent: OtherEvent?
    
    /// link to the list of OtherEvents, so that when a new ToDo Event is created, the list refreshes.
    var delegate: ToDoListRefreshProtocol?
    
    // TODO: Docstrings
    @IBOutlet weak var navButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        self.setCells()
        super.viewDidLoad()
        
        // makes it so that the form doesn't have a bunch of empty cells at the bottom
        tableView.tableFooterView = UIView()
        
        if let otherEvent = otherEvent {
            fillForm(with: otherEvent)
            navButton.image = .none
            navButton.title = "Done"
        } else {
            navButton.image = SystemIcon.plus.createImage()
        }
    }
    
    // TODO: Docstrings
    func setCells() {
        self.cells = [
            [
                .textFieldCell(placeholderText: "Name", text: self.name, id: FormCellID.TextFieldCellID.nameTextField, textFieldDelegate: self, delegate: self),
                .textFieldCell(placeholderText: "Location", text: self.location, id: FormCellID.TextFieldCellID.locationTextField, textFieldDelegate: self, delegate: self),
                .labelCell(cellText: "Remind Me", cellAccessoryType: .disclosureIndicator, onClick: { self.showAlertTimesSelectionViewController() })
            ],
            [
                .timeCell(cellText: "Starts", date: self.startDate, dateFormat: .fullDateWithTime, timePickerMode: .dateAndTime, id: FormCellID.TimeCellID.startTimeCell, onClick: self.timeCellClicked),
                .timeCell(cellText: "Ends", date: self.endDate, dateFormat: .fullDateWithTime, timePickerMode: .dateAndTime, id: FormCellID.TimeCellID.endTimeCell, onClick: self.timeCellClicked)
            ],
            [
                .textFieldCell(placeholderText: "Additional Details", text: self.additionalDetails, id: FormCellID.TextFieldCellID.additionalDetailsTextField, textFieldDelegate: self, delegate: self),
            ],
            [
                .errorCell(errors: self.errors)
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
            self.scrollToBottomOfTableView()
            tableView.reloadData()
        }
    }
    
    //TODO: Docstring
    func findErrors() -> [StudiumFormError] {
        var errors = [StudiumFormError]()
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
        if let destinationVC = segue.destination as? AlertTimeSelectionTableViewForm {
            destinationVC.delegate = self
        }
    }
}

// TODO: Docstrings
extension AddToDoListEventViewController: UITextFieldDelegateExtension {
    
    // TODO: Docstrings
    func textEdited(sender: UITextField, textFieldID: FormCellID.TextFieldCellID) {
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
        printDebug("fillform called in AddToDoListEventController")
        self.name = otherEvent.name
        self.location = otherEvent.location
        self.additionalDetails = otherEvent.additionalDetails
        self.alertTimes = otherEvent.alertTimes
        self.startDate = otherEvent.startDate
        self.endDate = otherEvent.endDate
        self.setCells()
    }
}
