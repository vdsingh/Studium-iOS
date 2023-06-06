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
class AddAssignmentViewController: MasterForm, StudiumForm, Coordinated {
    
    // TODO: Docstrings
    override var debug: Bool {
        return true
    }
    
    // TODO: Docstrings
    weak var coordinator: CoursesCoordinator?
    
    /// Holds the assignment being edited (if an assignment is being edited)
    var assignmentEditing: Assignment?
 
    // TODO: Docstrings
    var scheduleWorkTime: Bool = false
    
    /// link to the main list of assignments, so it can refresh when we add a new one
    var delegate: AssignmentRefreshProtocol?
    
    /// The course that the user selected for this assignment
    var selectedCourse: Course!
    
    // TODO: Docstrings
    @IBOutlet weak var navButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        // TODO: Fix force unwrap
        self.endDate = Calendar.current.date(bySetting: .hour, value: 23, of: self.endDate)!
        self.endDate = Calendar.current.date(bySetting: .minute, value: 59, of: self.endDate)!
        
        self.setCells()
        
        if let assignment = assignmentEditing {
            navButton.image = .none
            navButton.title = "Done"
            fillForm (
                assignment: assignment
            )
        } else {
            navButton.image = SystemIcon.plus.createImage()
        }
    }
    
    // TODO: Docstrings
    func setCells() {
        self.cells = [
            [
                .textFieldCell(placeholderText: "Name", text: self.name, id: FormCellID.TextFieldCellID.nameTextField, textFieldDelegate: self, delegate: self),
                .timeCell(cellText: "Due Date", date: self.endDate, dateFormat: .fullDateWithTime, timePickerMode: .dateAndTime, id: .endTimeCell, onClick: self.timeCellClicked),
                .labelCell(cellText: "Remind Me", cellAccessoryType: .disclosureIndicator, onClick: { self.showAlertTimesSelectionViewController() })
            ],
            [
                .switchCell(cellText: "Schedule Time to Work", isOn: self.scheduleWorkTime, switchDelegate: self, infoDelegate: self)
            ],
            [
                .textFieldCell(placeholderText: "Additional Details", text: self.additionalDetails, id: FormCellID.TextFieldCellID.additionalDetailsTextField, textFieldDelegate: self, delegate: self)
            ],
            [
                .errorCell(errors: self.errors)
            ]
        ]
    }
    
    //method that is triggered when the user wants to finalize the form
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.errors = self.findErrors()
        if self.errors.isEmpty {
            let newAssignment = Assignment(
                name: self.name,
                additionalDetails: self.additionalDetails,
                complete: false,
                startDate: self.endDate - (60 * 60),
                endDate: self.endDate,
                notificationAlertTimes: self.alertTimes,
                autoschedule: self.scheduleWorkTime,
                autoLengthMinutes: self.totalLengthMinutes,
                autoDays: self.daysSelected,
                partitionKey: AuthenticationService.shared.userID ?? "",
                parentCourse: self.selectedCourse
            )
            
            if let assignmentEditing = self.assignmentEditing {
                self.databaseService.editStudiumEvent(
                    oldEvent: assignmentEditing,
                    newEvent: newAssignment
                )
            } else {
                self.databaseService.saveStudiumObject(newAssignment)
            }
            
            self.autoscheduleService.autoscheduleStudyTime(parentAssignment: newAssignment)
            delegate?.reloadData()
            dismiss(animated: true, completion: nil)
        } else {
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
        
        return errors
    }
    
    /// Called when user clicks the cancel button
    /// - Parameter sender: Button that the user clicked to cancel
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    /// Fills the form with information from an Assignment
    /// - Parameter assignment: the Assignment whose data we are filling the form with
    func fillForm(
        assignment: Assignment
    ) {
        
        printDebug("attempting to fillForm with \(assignment)")
        self.selectedCourse = assignment.parentCourse
        self.name = assignment.name
        self.endDate = assignment.endDate
        self.additionalDetails = assignment.additionalDetails
        self.alertTimes = assignment.alertTimes
        self.scheduleWorkTime = assignment.autoscheduling
        self.daysSelected = assignment.days
        self.totalLengthMinutes = assignment.autoLengthMinutes
        
        self.setCells()
        self.refreshAutoscheduleSection()
    }
}

//MARK: - Cell DataSource and Delegates

// TODO: Docstrings
extension AddAssignmentViewController: UITextFieldDelegateExtension {
    
    //TODO: Implement IDs here
    // TODO: Docstrings
    func textEdited(sender: UITextField, textFieldID: FormCellID.TextFieldCellID) {
        guard let text = sender.text else {
            print("$ERR (AddAssignmentViewController): sender's text was nil. File: \(#file), Function: \(#function), Line: \(#line)")
            return
        }
        
        switch textFieldID {
        case .nameTextField:
            self.name = text
        case .additionalDetailsTextField:
            self.additionalDetails = text
        default:
            print("$ERR (AddAssignmentViewController): edited text for non-existent field. File: \(#file), Function: \(#function), Line: \(#line)")
            break
        }
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
        printDebug("Switch value changed")
        self.scheduleWorkTime = sender.isOn
        self.setCells()
        
        self.refreshAutoscheduleSection()
    }
    
    // TODO: Docstrings
    func refreshAutoscheduleSection() {
        // TODO: Use tableview updates so these actions are animated.
        if self.scheduleWorkTime {
            self.cells[1].append(.daySelectorCell(daysSelected: self.daysSelected, delegate: self))
            self.cells[1].append(.pickerCell(cellText: "Length", indices: self.lengthPickerIndices, tag: FormCellID.PickerCellID.lengthPickerCell, delegate: self, dataSource: self))
        } else {
            self.cells[1].removeAll()
            self.cells[1].append(.switchCell(cellText: "Schedule Time to Work", isOn: false, switchDelegate: self, infoDelegate: self))
        }
        
        tableView.reloadData()
    }
}

// TODO: Docstrings
extension AddAssignmentViewController: CanHandleInfoDisplay {
    func displayInformation() {
        let alert = UIAlertController(
            title: "Autoscheduling",
            message: "We'll analyze your schedule and find time for you to get it done.",
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
        
        present(alert, animated: true, completion: nil)
    }
}

// TODO: Docstrings
extension AddAssignmentViewController: DaySelectorDelegate {
    func updateDaysSelected(weekdays: Set<Weekday>) {
        self.daysSelected = weekdays
    }
}
