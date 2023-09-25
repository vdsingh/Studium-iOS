//
//  AddToDoListEvent.swift
//  Studium
//
//  Created by Vikram Singh on 6/26/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift

/// Form to add a To-Do List Event
class AddToDoListEventViewController: MasterForm, AlertTimeSelectingForm, Storyboarded {
    
    weak var coordinator: OtherEventEditingCoordinator?
    
    /// tracks the event being edited, if one is being edited.
    var otherEvent: OtherEvent?
    
    /// link to the list of OtherEvents, so that when a new ToDo Event is created, the list refreshes.
    var delegate: ToDoListRefreshProtocol?
    
    // TODO: Docstrings
    @IBOutlet weak var navButton: UIBarButtonItem!
    
    func showAlertTimesSelectionViewController() {
        Log.d("showAlertTimesSelectionViewController called")
        
        if let coordinator = coordinator {
            coordinator.showAlertTimesSelectionViewController(updateDelegate: self, selectedAlertOptions: self.alertTimes)
        } else {
            self.showError(.nonConformingCoordinator)
            Log.s(AlertTimeSelectingFormError.failedToUnwrapCoordinatorAsAlertTimesSelectionShowingCoordinator, additionalDetails: "Tried to show AlertTimesSelection Flow but the coordinator is not AlertTimesSelectionShowingCoordinator. Coordinator: \(String(describing: self.coordinator))")
        }
    }
    
    override func viewDidLoad() {
        self.setCells()
        super.viewDidLoad()
        
        // makes it so that the form doesn't have a bunch of empty cells at the bottom
        self.tableView.tableFooterView = UIView()
        
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
                .textFieldCell(placeholderText: "Name", text: self.name, charLimit: TextFieldCharLimit.shortField.rawValue, textfieldWasEdited: { text in
                    self.name = text
                }),
                .textFieldCell(placeholderText: "Location", text: self.location, charLimit: TextFieldCharLimit.shortField.rawValue, textfieldWasEdited: { text in
                    self.location = text
                }),
                .labelCell(cellText: "Remind Me", icon: StudiumIcon.bell.uiImage, cellAccessoryType: .disclosureIndicator, onClick: { self.showAlertTimesSelectionViewController() })
            ],
            [
                .timeCell(cellText: "Starts", date: self.startDate, dateFormat: DateFormat.fullDateWithTime, timePickerMode: .dateAndTime, id: FormCellID.TimeCellID.startTimeCell, onClick: self.timeCellClicked),
                .timeCell(cellText: "Ends", date: self.endDate, dateFormat: DateFormat.fullDateWithTime, timePickerMode: .dateAndTime, id: FormCellID.TimeCellID.endTimeCell, onClick: self.timeCellClicked)
            ],
            [
                .textFieldCell(placeholderText: "Additional Details", text: self.additionalDetails, charLimit: TextFieldCharLimit.longField.rawValue, textfieldWasEdited: { text in
                    self.additionalDetails = text
                }),
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
            let newEvent = OtherEvent(name: self.name.trimmed(), location: self.location.trimmed(), additionalDetails: self.additionalDetails.trimmed(), startDate: self.startDate, endDate: self.endDate, color: self.color, icon: self.icon, alertTimes: self.alertTimes)
            if let otherEvent = self.otherEvent {
                // We are editing
                self.studiumEventService.updateStudiumEvent(oldEvent: otherEvent, updatedEvent: newEvent)
            
            } else {
                // We are creating new
                self.studiumEventService.saveStudiumEvent(newEvent)
            }
            
            guard let delegate = delegate else {
                Log.e("delegate is nil in AddToDoListEventViewController.")
                return
            }

            delegate.reloadData()
            self.dismiss(animated: true, completion: nil)
        } else {
            // update the errors cell to show all of the errors with the form
            self.setCells()
            self.scrollToBottomOfTableView()
            self.tableView.reloadData()
        }
    }
    
    //TODO: Docstring
    override func findErrors() -> [StudiumFormError] {
        var errors = [StudiumFormError]()
        errors.append(contentsOf: super.findErrors())
        
        if self.name.trimmed().isEmpty {
            errors.append(.nameNotSpecified)
        }
        
        if self.startDate > self.endDate {
            errors.append(.endTimeOccursBeforeStartTime)
        }
        
        return errors
    }
    
    /// Cancel the form
    /// - Parameter sender: The UIBarButtonItem used to cancel the form
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}

// TODO: Docstrings
extension AddToDoListEventViewController {
    
    // TODO: Docstrings
    func fillForm(with otherEvent: OtherEvent) {
        Log.d("fillform called in AddToDoListEventController")
        self.name = otherEvent.name
        self.location = otherEvent.location
        self.additionalDetails = otherEvent.additionalDetails
        self.alertTimes = otherEvent.alertTimes
        self.startDate = otherEvent.startDate
        self.endDate = otherEvent.endDate
        self.setCells()
    }
}

extension String {
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
