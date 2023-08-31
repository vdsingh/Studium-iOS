import Foundation
import UIKit
import FlexColorPicker
import TableViewFormKit
import VikUtilityKit

// TODO: Docstrings
class AddCourseViewController: MasterForm, AlertTimeSelectingForm, LogoSelectingForm, Storyboarded {
    
    // TODO: Docstrings
    weak var coordinator: CoursesCoordinator?
    
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
        super.viewDidLoad()
        self.setCells()
    
        self.navButton.image = SystemIcon.plus.createImage()
        
        // gets rid of empty cells at the bottom
        self.tableView.tableFooterView = UIView()
        
        // We are currently editing
        if let course = self.course {
            self.navButton.image = .none
            self.navButton.title = "Done"
            self.fillForm(with: course)
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
                .daySelectorCell(daysSelected: self.daysSelected, delegate: self),
                .labelCell(
                    cellText: "Remind Me", icon: StudiumIcon.bell.uiImage,
                    cellAccessoryType: .disclosureIndicator,
                    onClick: {
                        self.showAlertTimesSelectionViewController()
                    }
                )
            ],
            [
                .timeCell(cellText: "Starts", date: self.startDate, dateFormat: .standardTime, timePickerMode: .time, id: FormCellID.TimeCellID.startTimeCell, onClick: timeCellClicked),
                .timeCell(cellText: "Ends", date: self.endDate, dateFormat: .standardTime, timePickerMode: .time, id: FormCellID.TimeCellID.endTimeCell, onClick: timeCellClicked)
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
    }
    
    // final step that occurs when the user has filled out the form and wants to add the new course
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.endDate = Calendar.current.date(bySettingHour: self.endDate.hour, minute: self.endDate.minute, second: self.endDate.second, of: self.startDate)!

        self.errors = self.findErrors()
        
        if self.errors.isEmpty {
            let newCourse = Course (
                name: self.name,
                color: self.color,
                location: self.location,
                additionalDetails: self.additionalDetails,
                startDate: self.startDate,
                endDate: self.endDate,
                days: self.daysSelected,
                icon: self.icon,
                notificationAlertTimes: self.alertTimes,
                partitionKey: AuthenticationService.shared.userID!
            )
            
            if let course = self.course {
                self.studiumEventService.updateStudiumEvent(oldEvent: course, updatedEvent: newCourse)
            } else {
                self.studiumEventService.saveStudiumEvent(newCourse)
            }

            if let delegate = self.delegate {
                self.dismiss(animated: true, completion: delegate.loadCourses)
            } else {
                Log.e("courseRefreshDelegate was nil. Didn't refresh list.")
                PopUpService.shared.presentGenericError()
                self.dismiss(animated: true)
            }
        } else {
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
        
        if self.daysSelected.isEmpty {
            errors.append(.oneDayNotSpecified)
        }
        
        if self.startDate > self.endDate {
            errors.append(.endTimeOccursBeforeStartTime)
        }

        return errors
    }
    
    /// handles when the user wants to cancel their form
    /// - Parameter sender: The button used to cancel the form
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}

//MARK: - TableView DataSource

// TODO: Docstrings
extension AddCourseViewController {
    
    /// The number of sections in the TableView
    /// - Parameter tableView: The TableView
    /// - Returns: The number of sections in the TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.cells.count
    }
    
    /// The number of rows in a given section of a TableView
    /// - Parameters:
    ///   - tableView: The TableView
    ///   - section: The section for which we are providing the number of rows
    /// - Returns: The number of rows in a given section of a TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells[section].count
    }
}

// TODO: Docstrings
//extension AddCourseViewController: UITextFieldDelegateExtension {
//    
//    // TODO: Docstrings
//    func textEdited(sender: UITextField, textFieldID: FormCellID.TextFieldCellID) {
//        guard let text = sender.text else {
//            Log.e("sender's text is nil when editing text in \(textFieldID).")
//            return
//        }
//
//        switch textFieldID {
//        case .nameTextField:
//            self.name = text
//        case .locationTextField:
//            self.location = text
//        case .additionalDetailsTextField:
//            self.additionalDetails = text
//        }
//    }
//}

// TODO: Docstrings
extension AddCourseViewController: DaySelectorDelegate {
    
    // TODO: Docstrings
    func updateDaysSelected(weekdays: Set<Weekday>) {
        self.daysSelected = weekdays
        Log.d("Updated Selected Days: \(self.daysSelected)")
    }
}

// TODO: Docstrings
extension AddCourseViewController: ColorDelegate {
    
    // TODO: Docstrings
    func colorPickerValueChanged(sender: RadialPaletteControl) {
        self.color = sender.selectedColor
    }
}

// TODO: Docstrings
extension AddCourseViewController {
    
    // TODO: Docstrings
    func fillForm(with course: Course) {
        Log.d("Filling Add Course form with course: \(course)")
        self.tableView.reloadData()
                
        if let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldCell {
            nameCell.textField.text = course.name
            self.name = course.name
        }
        
        if let locationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TextFieldCell {
            locationCell.textField.text = course.location
            self.location = course.location
        }
        
        if let daysCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? DaySelectorCell {
            daysCell.selectDays(days: course.days)
            for day in course.days {
                self.daysSelected.insert(day)
            }
        }
        
        self.alertTimes = course.alertTimes
        
        if let startCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? TimeCell {
            self.startDate = course.startDate
            startCell.setDate(self.startDate)
        }
        
        if let endCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? TimeCell {
            self.endDate = course.endDate
            endCell.setDate(self.endDate)
        }
        
        if let logoCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? LogoSelectionCell {
            logoCell.setImage(image: course.icon.uiImage )
            self.icon = course.icon
        }
        
        if let colorCell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as? ColorPickerCell {
            colorCell.colorPreview.backgroundColor = course.color
            self.color = course.color
        }
            
        if let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 2, section: 2)) as? TextFieldCell {
            additionalDetailsCell.textField.text = course.additionalDetails
            self.additionalDetails = course.additionalDetails
        }
    }
}
