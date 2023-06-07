
import Foundation
import UIKit
import RealmSwift
import FlexColorPicker
import EventKit

import TableViewFormKit
import VikUtilityKit

// TODO: Docstrings
class AddCourseViewController: MasterForm, AlertTimeSelectingForm, LogoSelectingForm, Storyboarded {
    
    // TODO: Docstrings
    weak var coordinator: CoursesCoordinator?
    
    // TODO: Docstrings
    let codeLocationString = "AddCourseViewController"
    
    // TODO: Docstrings
    var course: Course?
    
    /// reference to the list that is to be refreshed when a new course is added.
    var delegate: CourseRefreshProtocol?
    
    // TODO: Docstrings
    override var debug: Bool {
        true
    }
        
    // TODO: Docstrings
    @IBOutlet weak var navButton: UIBarButtonItem!

    // TODO: Docstrings
    override func viewDidLoad() {
       
        self.setCells()
    
        super.viewDidLoad()
        navButton.image = SystemIcon.plus.createImage()
        
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
        
        // gets rid of empty cells at the bottom
        tableView.tableFooterView = UIView()
        
        if let course = self.course {
            navButton.image = .none
            navButton.title = "Done"
            self.fillForm(with: course)
            // TODO: Update course notification times
        }
    }
    
    // TODO: Docstrings
    func setCells() {
        self.cells = [
            [
                .textFieldCell(placeholderText: "Name", text: self.name, id: FormCellID.TextFieldCellID.nameTextField, textFieldDelegate: self, delegate: self),
                .textFieldCell(placeholderText: "Location", text: self.location, id: FormCellID.TextFieldCellID.locationTextField, textFieldDelegate: self, delegate: self),
                .daySelectorCell(daysSelected: self.daysSelected, delegate: self),
                .labelCell(cellText: "Remind Me", cellAccessoryType: .disclosureIndicator, onClick: {
                    self.showAlertTimesSelectionViewController() }
                )
            ],
            [
                .timeCell(cellText: "Starts", date: self.startDate, dateFormat: .standardTime, timePickerMode: .time, id: FormCellID.TimeCellID.startTimeCell, onClick: timeCellClicked),
                .timeCell(cellText: "Ends", date: self.endDate, dateFormat: .standardTime, timePickerMode: .time, id: FormCellID.TimeCellID.endTimeCell, onClick: timeCellClicked)
            ],
            [
                .logoCell(logo: self.icon.image, onClick: { self.showLogoSelectionViewController() }),
                .colorPickerCell(delegate: self),
                .textFieldCell(placeholderText: "Additional Details", text: self.additionalDetails, id: FormCellID.TextFieldCellID.additionalDetailsTextField, textFieldDelegate: self, delegate: self)
            ],
            [
                .errorCell(errors: self.errors)
//                .labelCell(cellText: "", textColor: StudiumColor.failure.uiColor, backgroundColor: StudiumColor.background.uiColor)
            ]
        ]
    }
    
    //final step that occurs when the user has filled out the form and wants to add the new course
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        self.errors = self.findErrors()
        endDate = Calendar.current.date(bySettingHour: endDate.hour, minute: endDate.minute, second: endDate.second, of: startDate)!
        
        
        if self.errors.isEmpty {
            let newCourse = Course (
                name: name,
                color: self.color,
                location: location,
                additionalDetails: additionalDetails,
                startDate: startDate,
                endDate: endDate,
                days: self.daysSelected,
                icon: self.icon,
                notificationAlertTimes: alertTimes,
                partitionKey: AuthenticationService.shared.userID!
            )
            
            if let course = self.course {
                self.databaseService.editStudiumEvent(
                    oldEvent: course,
                    newEvent: newCourse
                )
            } else {
                self.databaseService.saveStudiumObject(newCourse)
            }

            if delegate == nil {
                printDebug("Course refresh delegate is nil.")
            }
            
            dismiss(animated: true, completion: delegate?.loadCourses)
        } else {
            self.setCells()
            self.scrollToBottomOfTableView()
            tableView.reloadData()
        }
    }
    
    //TODO: Docstring
    func findErrors() -> [StudiumFormError] {
        var errors = [StudiumFormError]()
        if name == "" {
            errors.append(.nameNotSpecified)
        }
        
        if daysSelected == [] {
            errors.append(.oneDayNotSpecified)
        }
        
        if startDate > endDate {
            errors.append(.endTimeOccursBeforeStartTime)
        }
        
        return errors
    }
    
    /// handles when the user wants to cancel their form
    /// - Parameter sender: The button used to cancel the form
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

//MARK: - TableView DataSource

// TODO: Docstrings
extension AddCourseViewController {
    
    /// The number of sections in the TableView
    /// - Parameter tableView: The TableView
    /// - Returns: The number of sections in the TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    /// The number of rows in a given section of a TableView
    /// - Parameters:
    ///   - tableView: The TableView
    ///   - section: The section for which we are providing the number of rows
    /// - Returns: The number of rows in a given section of a TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
}

// TODO: Docstrings
extension AddCourseViewController: UITextFieldDelegateExtension {
    
    // TODO: Docstrings
    func textEdited(sender: UITextField, textFieldID: FormCellID.TextFieldCellID) {
        guard let text = sender.text else {
            print("$ERR: sender's text is nil when editing text in \(textFieldID).\n File: \(#file)\nFunction: \(#function)\nLine: \(#line)")
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
extension AddCourseViewController: DaySelectorDelegate {
    
    // TODO: Docstrings
    func updateDaysSelected(weekdays: Set<Weekday>) {
        self.daysSelected = weekdays
        printDebug("Updated Selected Days: \(self.daysSelected)")
    }
}

// TODO: Docstrings
extension AddCourseViewController: ColorDelegate {
    
    // TODO: Docstrings
    func colorPickerValueChanged(sender: RadialPaletteControl) {
        color = sender.selectedColor
    }
}

// TODO: Docstrings
extension AddCourseViewController {
    
    // TODO: Docstrings
    func fillForm(with course: Course) {
        printDebug("Filling Add Course form with course: \(course)")
        tableView.reloadData()
                
        if let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldCell {
            nameCell.textField.text = course.name
            name = course.name
        }
        
        if let locationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TextFieldCell {
            locationCell.textField.text = course.location
            location = course.location
        }
        
        if let daysCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? DaySelectorCell {
            daysCell.selectDays(days: course.days)
            for day in course.days {
                self.daysSelected.insert(day)
            }
        }
        
        self.alertTimes = course.alertTimes
        
        if let startCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? TimeCell {
            startDate = course.startDate
            startCell.setDate(startDate)
        }
        
        if let endCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? TimeCell {
            endDate = course.endDate
            endCell.setDate(endDate)
        }
        
        if let logoCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? LogoSelectionCell {
//            logoCell.logoImageView.image = course.logo.createImage()
            logoCell.setImage(image: course.icon.image )
            self.icon = course.icon
        }
        
        if let colorCell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as? ColorPickerCell {
            colorCell.colorPreview.backgroundColor = course.color
            self.color = course.color
        }
            
        if let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 2, section: 2)) as? TextFieldCell {
            additionalDetailsCell.textField.text = course.additionalDetails
            additionalDetails = course.additionalDetails
        }
    }
}
