
import Foundation
import UIKit
import RealmSwift
import FlexColorPicker
import EventKit

/// Makes sure that the course list can refresh when a new course is added
protocol CourseRefreshProtocol {
    
    // TODO: Docstrings
    func loadCourses()
}

// TODO: Docstrings
class AddCourseViewController: MasterForm {
    
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
            self.fillForm(with: course)
            // TODO: Update course notification times
        } else {
            //we are creating a new course
//            if UserDefaults.standard.object(forKey: K.defaultNotificationTimesKey) != nil {
//                Logs.Notifications.loadingDefaultNotificationTimes(logLocation: self.codeLocationString).printLog()
//                alertTimes = UserDefaults.standard.value(forKey: K.defaultNotificationTimesKey) as! [Int]
//            }
        }
    }
    
    // TODO: Docstrings
    func setCells() {
        self.cells = [
            [
                .textFieldCell(placeholderText: "Name", text: self.name, id: FormCellID.TextFieldCell.nameTextField, textFieldDelegate: self, delegate: self),
                .textFieldCell(placeholderText: "Location", text: self.location, id: FormCellID.TextFieldCell.locationTextField, textFieldDelegate: self, delegate: self),
                .daySelectorCell(daysSelected: self.daysSelected, delegate: self),
                .labelCell(cellText: "Remind Me", cellAccessoryType: .disclosureIndicator, onClick: self.navigateToAlertTimes)
            ],
            [
                .timeCell(cellText: "Starts", date: self.startDate, dateFormat: .standardTime, timePickerMode: .time, id: FormCellID.TimeCell.startTimeCell, onClick: timeCellClicked),
                .timeCell(cellText: "Ends", date: self.endDate, dateFormat: .standardTime, timePickerMode: .time, id: FormCellID.TimeCell.endTimeCell, onClick: timeCellClicked)
            ],
            [
                .logoCell(logo: self.logo, onClick: self.navigateToLogoSelection),
                .colorPickerCell(delegate: self),
                .textFieldCell(placeholderText: "Additional Details", text: self.additionalDetails, id: FormCellID.TextFieldCell.additionalDetailsTextField, textFieldDelegate: self, delegate: self)
            ],
            [
                .labelCell(cellText: "", textColor: .systemRed)
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
                logo: self.logo,
                notificationAlertTimes: alertTimes,
                partitionKey: self.databaseService.user?.id ?? ""
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
            self.replaceLabelText(
                text: FormError.constructErrorString(errors: self.errors),
                section: 3,
                row: 0
            )
            tableView.reloadData()
        }
    }
    
    //TODO: Docstring
    func findErrors() -> [FormError] {
        var errors = [FormError]()
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
    
    // TODO: Docstrings
    /// handles when the user wants to cancel their form
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

//MARK: - TableView DataSource

// TODO: Docstrings
extension AddCourseViewController {
    
    // TODO: Docstrings
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    // TODO: Docstrings
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
}

// TODO: Docstrings
extension AddCourseViewController: UITextFieldDelegateExt {
    
    // TODO: Docstrings
    func textEdited(sender: UITextField, textFieldID: FormCellID.TextFieldCell) {
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
        
        navButton.image = .none
        navButton.title = "Done"
                
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
        
        alertTimes = course.alertTimes
        
        if let startCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? TimeCell {
            startDate = course.startDate
            startCell.setDate(startDate)
        }
        
        if let endCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? TimeCell {
            endDate = course.endDate
            endCell.setDate(endDate)
        }
        
        if let logoCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? LogoCell {
            logoCell.logoImageView.image = course.logo.createImage()
            self.logo = course.logo
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
