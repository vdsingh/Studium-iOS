
import Foundation
import UIKit
import RealmSwift
import FlexColorPicker
import EventKit

//makes sure that the course list can refresh when a new course is added
//protocol CourseRefreshProtocol{
//    func loadCourses()
//}

class AddCourseViewController: MasterForm {
    
    let codeLocationString = "AddCourseViewController"
    
    var course: Course?
    
    //link to the list that is to be refreshed when a new course is added.
//    var delegate: CourseRefreshProtocol?

    //error string that is displayed when there are errors
    var errors: String = ""
    
    //basic course elements
    var name: String = ""
    var colorValue: String = "ffffff"
    var additionalDetails: String = ""
    var location: String = ""
    var daysSelected: [Int] = []
    var logoString: String = "pencil"
        
    var partitionKey: String = ""
    
    @IBOutlet weak var navButton: UIBarButtonItem!

    override func viewDidLoad() {
        self.cells = [
            [
                .textFieldCell(placeholderText: "Name", id: FormCellID.TextFieldCell.nameTextField, textFieldDelegate: self, delegate: self),
                .textFieldCell(placeholderText: "Location", id: FormCellID.TextFieldCell.locationTextField, textFieldDelegate: self, delegate: self),
                .daySelectorCell(delegate: self),
                .labelCell(cellText: "Remind Me", cellAccessoryType: .disclosureIndicator, onClick: self.navigateToAlertTimes)
            ],
            [
                .timeCell(cellText: "Starts", date: self.startDate, dateFormat: "h:mm a", id: FormCellID.TimeCell.startTimeCell, onClick: timeCellClicked),
                .timeCell(cellText: "Ends", date: self.endDate, dateFormat: "h:mm a", id: FormCellID.TimeCell.endTimeCell, onClick: timeCellClicked)
            ],
            [
                .logoCell(imageString: self.systemImageString, onClick: self.navigateToLogoSelection),
                .colorPickerCell(delegate: self),
                .textFieldCell(placeholderText: "Additional Details", id: FormCellID.TextFieldCell.additionalDetailsTextField, textFieldDelegate: self, delegate: self)
            ],
            [
                .labelCell(cellText: "", textColor: .systemRed, backgroundColor: .systemBackground)
            ]
        ]
    
        super.viewDidLoad()
        navButton.image = UIImage(systemName: "plus")
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        // gets rid of empty cells at the bottom
        tableView.tableFooterView = UIView()
        
        if let course = self.course {
            fillForm(with: course)
            // TODO: Update course notification times
        } else {
            //we are creating a new course
            if UserDefaults.standard.object(forKey: K.defaultNotificationTimesKey) != nil {
//                Logs.Notifications.loadingDefaultNotificationTimes(logLocation: self.codeLocationString).printLog()
                alertTimes = UserDefaults.standard.value(forKey: K.defaultNotificationTimesKey) as! [Int]
            }
        }
    }
    
    //final step that occurs when the user has filled out the form and wants to add the new course
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        errors = ""
        endDate = Calendar.current.date(bySettingHour: endDate.hour, minute: endDate.minute, second: endDate.second, of: startDate)!
        if name == "" {
            errors.append(" Please specify a course name.")
        }
        
        if daysSelected == [] {
            errors.append(" Please specify at least one day.")
        }
        
        if endDate.isEarlier(than: startDate){
            errors.append(" End time cannot occur before start time.")
        }
        
        if errors.count == 0 {
            if let course = self.course {
                // TODO: Move deleteNotifications to NotificationHandler
                
//                course.deleteNotifications()
//                NotificationHandler.scheduleNotificationsForCourse(course: course)
                
                if let user = app.currentUser {
                    partitionKey = user.id
                } else {
                    print("$ ERROR: user is nil")
                }
                do {
                    // TODO: Abstract away realm to state
                    try realm.write {
                        course.initializeData(name: name, colorHex: colorValue, location: location, additionalDetails: additionalDetails, startDate: startDate, endDate: endDate, days: daysSelected, systemImageString: systemImageString, notificationAlertTimes: alertTimes, partitionKey: partitionKey)
                    }
                } catch {
                    print("$ ERROR: error updating course data: \(error)")
                }
            } else {
                let newCourse = Course()
                if let user = app.currentUser {
                    partitionKey = user.id
                }
                
                newCourse.initializeData(name: name, colorHex: colorValue, location: location, additionalDetails: additionalDetails, startDate: startDate, endDate: endDate, days: daysSelected, systemImageString: systemImageString, notificationAlertTimes: alertTimes, partitionKey: partitionKey)
                //scheduling the appropriate notifications
                NotificationHandler.scheduleNotificationsForCourse(course: newCourse)
                RealmCRUD.saveCourse(course: newCourse)
                newCourse.addToAppleCalendar()
            }
            dismiss(animated: true, completion: StudiumState.state.updateCourses)
        }else{
            self.replaceLabelText(text: errors, section: 3, row: 0)
            tableView.reloadData()
        }
    }
    
    //handles when the user wants to cancel their form
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

//MARK: - TableView DataSource
extension AddCourseViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
}

extension AddCourseViewController: UITextFieldDelegateExt{
    func textEdited(sender: UITextField, textFieldID: FormCellID.TextFieldCell) {
        guard let text = sender.text else {
            print("$ ERROR: sender's text is nil when editing text in \(textFieldID).\n File: \(#file)\nFunction: \(#function)\nLine: \(#line)")
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

extension AddCourseViewController: DaySelectorDelegate{
    func dayButtonPressed(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            for i in 0...daysSelected.count-1 {
                if daysSelected[i] == K.weekdayDict[sender.titleLabel!.text!]!{
                    daysSelected.remove(at: i)
                }
            }
        } else {
            //day was not selected, and we are now selecting it.
            sender.isSelected = true
            
            // TODO: Fix force unwrap
            daysSelected.append(K.weekdayDict[sender.titleLabel!.text!]!)
        }
    }
}

extension AddCourseViewController: ColorDelegate{
    func colorPickerValueChanged(sender: RadialPaletteControl) {
        colorValue = sender.selectedColor.hexValue()
    }
    
}

extension AddCourseViewController{
    func fillForm(with course: Course){
        tableView.reloadData()
        
        navButton.image = .none
        navButton.title = "Done"
        
        // TODO: Fix force typing 
        
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        nameCell.textField.text = course.name
        name = course.name
        
        let locationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TextFieldCell
        locationCell.textField.text = course.location
        location = course.location
        
        let daysCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! DaySelectorCell
        daysCell.selectDays(days: course.days)
        for day in course.days{
            daysSelected.append(day)
        }
        
        alertTimes = []
        for alert in course.notificationAlertTimes{
            alertTimes.append(alert)
        }
        
        let startCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TimeCell
        startDate = course.startDate
        startCell.timeLabel.text = startDate.format(with: "h:mm a")
        startCell.date = startDate
        
        let endCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! TimeCell
        endDate = course.endDate
        endCell.timeLabel.text = endDate.format(with: "h:mm a")
        endCell.date = endDate
        
        let logoCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! LogoCell
        logoCell.logoImageView.image = UIImage(systemName: course.systemImageString)
        systemImageString = course.systemImageString
        
        let colorCell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as! ColorPickerCell
        colorCell.colorPreview.backgroundColor = UIColor(hexString: course.color)!
        colorValue = course.color
        
        let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 2, section: 2)) as! TextFieldCell
        additionalDetailsCell.textField.text = course.additionalDetails
        additionalDetails = course.additionalDetails
    }
}
