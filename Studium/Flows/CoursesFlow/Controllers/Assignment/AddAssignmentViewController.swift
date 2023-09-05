import Foundation
import UIKit

import RealmSwift

import TableViewFormKit
import VikUtilityKit

//TODO: Docstring
protocol AssignmentRefreshProtocol {
    
    // TODO: Docstrings
    func reloadData()
}

// TODO: Docstrings
class AddAssignmentViewController: MasterForm, AlertTimeSelectingForm, Storyboarded {
    
    // TODO: Docstrings
    override var debug: Bool {
        return true
    }
    
    // TODO: Docstrings
    func showAlertTimesSelectionViewController() {
        if let coordinator = coordinator as? AlertTimesSelectionShowingCoordinator {
            coordinator.showAlertTimesSelectionViewController(updateDelegate: self, selectedAlertOptions: self.alertTimes)
        } else {
            self.showError(.nonConformingCoordinator)
            Log.s(AlertTimeSelectingFormError.failedToUnwrapCoordinatorAsAlertTimesSelectionShowingCoordinator, additionalDetails: "Tried to show AlertTimesSelection Flow but the coordinator is not AlertTimesSelectionShowingCoordinator. Coordinator: \(String(describing: self.coordinator))")
        }
    }
    
    // TODO: Docstrings
    weak var coordinator: AssignmentEditingCoordinator?
    
    /// Holds the assignment being edited (if an assignment is being edited)
    var assignmentEditing: Assignment?
 
    // TODO: Docstrings
    var autoscheduleWorkTime: Bool = false
//    var autoschedulingConfig: AutoschedulingConfig?
    
    /// link to the main list of assignments, so it can refresh when we add a new one
    var refreshDelegate: AssignmentRefreshProtocol?
    
    /// The course that the user selected for this assignment
    var selectedCourse: Course!
    
    // TODO: Docstrings
    @IBOutlet weak var navButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        //FIXME: Fix force unwrap
        self.endDate = Calendar.current.date(bySetting: .hour, value: 23, of: self.endDate)!
        self.endDate = Calendar.current.date(bySetting: .minute, value: 59, of: self.endDate)!
        
        self.setCells()
        
        if let assignment = assignmentEditing {
            self.navButton.image = .none
            self.navButton.title = "Done"
            self.fillForm (
                assignment: assignment
            )
        } else {
            self.navButton.image = SystemIcon.plus.createImage()
        }
    }
    
    // TODO: Docstrings
    func setCells() {
        self.cells = [
            [
                .textFieldCell(placeholderText: "Name", text: self.name, charLimit: 100, textfieldWasEdited: { text in
                    self.name = text
                }),
                .timeCell(cellText: "Due Date", date: self.endDate, dateFormat: .fullDateWithTime, timePickerMode: .dateAndTime, id: .endTimeCell, onClick: self.timeCellClicked),
                .labelCell(cellText: "Remind Me", icon: StudiumIcon.bell.uiImage, cellAccessoryType: .disclosureIndicator, onClick: { self.showAlertTimesSelectionViewController() })
            ],
            [

            ],
            [
                .textFieldCell(placeholderText: "Additional Details", text: self.additionalDetails, charLimit: 300, textfieldWasEdited: { text in
                    self.additionalDetails = text
                })
            ],
            [
                .errorCell(errors: self.errors)
            ]
        ]
        
        self.refreshAutoscheduleSection()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.errors = self.findErrors()
        if self.errors.isEmpty {
            var autoschedulingConfig: AutoschedulingConfig? = nil
            if self.autoscheduleWorkTime,
               let autoLengthMinutes = self.totalLengthMinutes {
                autoschedulingConfig = AutoschedulingConfig(autoLengthMinutes: autoLengthMinutes, autoscheduleInfinitely: false, useDatesAsBounds: true, autoschedulingDays: self.daysSelected)
                Log.d("addButtonPressed daysSelected: \(self.daysSelected). AutoschedulingConfig days: \(autoschedulingConfig?.autoschedulingDays)")
            }
            
            let newAssignment = Assignment(
                name: self.name,
                additionalDetails: self.additionalDetails,
                complete: false,
                startDate: self.endDate - (60 * 60),
                endDate: self.endDate,
                notificationAlertTimes: self.alertTimes,
                autoschedulingConfig: autoschedulingConfig,
                parentCourse: self.selectedCourse
            )
                        
            if let assignmentEditing = self.assignmentEditing {
                self.studiumEventService.updateStudiumEvent(oldEvent: assignmentEditing, updatedEvent: newAssignment)
            } else {
                if newAssignment.autoscheduling {
                    self.databaseService.realmWrite { _ in
                        newAssignment.isGeneratingEvents = true
                    }
                }
                
                // DatabaseService will handle autoscheduling.
                self.databaseService.saveContainedEvent(
                    containedEvent: newAssignment,
                    containerEvent: self.selectedCourse,
                    autoscheduleCompletion: {
                        self.databaseService.realmWrite { _ in
                            newAssignment.isGeneratingEvents = false
                        }
                        self.refreshDelegate?.reloadData()
                    }
                )
            }
            
            self.refreshDelegate?.reloadData()
            self.dismiss(animated: true, completion: nil)
        } else {
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
        
        
        if self.autoscheduleWorkTime {
            if self.totalLengthMinutes == 0 || self.totalLengthMinutes == nil {
                errors.append(.totalTimeNotSpecified)
            }
            
            if self.daysSelected.isEmpty {
                errors.append(.oneDayNotSpecified)
            }
            
            if let autoMinutes = self.totalLengthMinutes {
                let timeChunk = TimeChunk(startDate: self.startDate, endDate: self.endDate)
                if timeChunk.lengthInMinutes < autoMinutes {
                    errors.append(.totalTimeExceedsTimeFrame)
                }
            }
        } else if self.endDate < self.startDate {
            errors.append(.endTimeOccursBeforeStartTime)
        }
        
        return errors
    }
    
    /// Called when user clicks the cancel button
    /// - Parameter sender: Button that the user clicked to cancel
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    /// Fills the form with information from an Assignment
    /// - Parameter assignment: the Assignment whose data we are filling the form with
    func fillForm(
        assignment: Assignment
    ) {
        self.selectedCourse = assignment.parentCourse
        self.name = assignment.name
        self.endDate = assignment.endDate
        self.additionalDetails = assignment.additionalDetails
        self.alertTimes = assignment.alertTimes
        self.autoscheduleWorkTime = assignment.autoscheduling

        if let autoschedulingConfig = assignment.autoschedulingConfig {
            self.daysSelected = autoschedulingConfig.autoschedulingDays
            self.totalLengthMinutes = autoschedulingConfig.autoLengthMinutes
            self.autoscheduleWorkTime = true
        } else {
            self.daysSelected = Set()
            self.totalLengthMinutes = nil
            self.autoscheduleWorkTime = false
        }
        
        self.setCells()
    }
}

//MARK: - Picker Delegate Methods

// TODO: Docstrings
extension AddAssignmentViewController {
    
    // TODO: Docstrings
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        switch pickerView.tag {
        case FormCellID.PickerCellID.lengthPickerCell.rawValue:
            let lengthHours = pickerView.selectedRow(inComponent: 0)
            let lengthMinutes = pickerView.selectedRow(inComponent: 1)
            self.totalLengthMinutes = (lengthHours * 60) + lengthMinutes
        default:
            break
        }
    }
}

// TODO: Docstrings
extension AddAssignmentViewController: CanHandleSwitch {
    
    // TODO: Docstrings
    func switchValueChanged(sender: UISwitch) {
        Log.d("autoschedule value changed")
        self.autoscheduleWorkTime = sender.isOn
        self.setCells()
//        self.refreshAutoscheduleSection()
    }
    
    // TODO: Docstrings
    func refreshAutoscheduleSection() {
        
        self.cells[1] = [.switchCell(cellText: "Autoschedule Work Time", isOn: self.autoscheduleWorkTime, switchDelegate: self, infoDelegate: self)]
        if self.autoscheduleWorkTime {
            Log.d("refreshAutoscheduleSection. Length picker indices: \(self.lengthPickerIndices). Days Selected: \(self.daysSelected)")
            self.cells[1].append(contentsOf: [
                .daySelectorCell(daysSelected: self.daysSelected, delegate: self),
                .pickerCell(cellText: "Length", indices: self.lengthPickerIndices, tag: FormCellID.PickerCellID.lengthPickerCell, delegate: self, dataSource: self)
            ])
        }
        
        self.tableView.reloadData()
    }
}

// TODO: Docstrings
extension AddAssignmentViewController: CanHandleInfoDisplay {
    func displayInformation() {
        let alert = UIAlertController(
            title: "Autoscheduling",
            message: "We'll analyze your schedule and find time for you to work on this!",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Ok",
                style: .cancel,
                handler: { (action: UIAlertAction!) in
                    
                }
            )
        )
        
        self.present(alert, animated: true, completion: nil)
    }
}

// TODO: Docstrings
extension AddAssignmentViewController: DaySelectorDelegate {
    func updateDaysSelected(weekdays: Set<Weekday>) {
        self.daysSelected = weekdays
        Log.d("Updated daysSelected: \(self.daysSelected)")
    }
}
