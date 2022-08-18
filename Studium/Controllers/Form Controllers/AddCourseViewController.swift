
import Foundation
import UIKit
import RealmSwift
import FlexColorPicker
import EventKit

//makes sure that the course list can refresh when a new course is added
protocol CourseRefreshProtocol{
    func loadCourses()
}

class AddCourseViewController: MasterForm, LogoStorer {
    
    let codeLocationString = "AddCourseViewController"
    
    var course: Course?
    
    //system image string that identifies what the logo of the course will be.
    var systemImageString: String = "pencil"
    
    //link to the list that is to be refreshed when a new course is added.
    var delegate: CourseRefreshProtocol?
    //start and end time for the course. The date doesn't actually matter because the days are selected elsewhere
    var startDate: Date = Date()
    var endDate: Date = Date() + (60*60)
    
    //variables that help determine what TimeCells display what times. times does NOT indicate alert times.
//    var times: [Date] = []
//    var timeCounter = 0
//    var pickerCounter = 0
    
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
    
//    enum CellID: String {
//        case nameTextField
//        case locationTextField
//        case additionalDetailsTextField
//    }

    override func viewDidLoad() {
        self.cells = [
            [
                .textFieldCell(placeholderText: "Name", id: FormCellID.nameTextField, textFieldDelegate: self, delegate: self),
                .textFieldCell(placeholderText: "Location", id: FormCellID.locationTextField, textFieldDelegate: self, delegate: self),
                .daySelectorCell(delegate: self),
                .labelCell(cellText: "Remind Me", cellAccessoryType: .disclosureIndicator, onClick: {
                    self.performSegue(withIdentifier: "toAlertSelection", sender: self)
                })
            ],
            [
                .timeCell(cellText: "Starts", date: self.startDate, onClick: timeCellClicked),
                .timeCell(cellText: "Ends", date: self.endDate, onClick: timeCellClicked)
            ],
            [
                .logoCell(imageString: self.systemImageString, onClick: {
//                    self.segue(to: "toLogoSelection")
                    self.performSegue(withIdentifier: "toLogoSelection", sender: self)
                }),
                .colorPickerCell(delegate: self),
                .textFieldCell(placeholderText: "Additional Details", id: FormCellID.additionalDetailsTextField, textFieldDelegate: self, delegate: self)
            ],
            [
                .labelCell(cellText: "", textColor: .systemRed, backgroundColor: .systemBackground, cellAccessoryType: .disclosureIndicator)
            ]
        ]
    
        super.viewDidLoad()
        navButton.image = UIImage(systemName: "plus")
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        //makes it so that there are no empty cells at the bottom
        tableView.tableFooterView = UIView()
        
        if course != nil{
            fillForm(with: course!)
        }else{
            
            //we are creating a new course
            if UserDefaults.standard.object(forKey: K.defaultNotificationTimesKey) != nil {
                Logs.Notifications.loadingDefaultNotificationTimes(logLocation: self.codeLocationString).printLog()
                alertTimes = UserDefaults.standard.value(forKey: K.defaultNotificationTimesKey) as! [Int]
            }
        }
    }
    //when we pick a logo, this function is called to update the preview on the logo cell.
    func refreshLogoCell() {
//        let logoCellRow = cellType[2].firstIndex(of: .logoCell)!
        guard let logoCellIndexPath = self.findFirstLogoCellIndex(section: 2) else {
            print("$ ERROR: Can't locate logo cell")
            return
        }
        guard let logoCell = tableView.cellForRow(at: logoCellIndexPath) as? LogoCell else {
            print("$ ERROR: LogoCell not found")
            return
        }
        logoCell.setImage(systemImageName: systemImageString)
//        logoCell.systemImageString = systemImageString
    }
    
    //final step that occurs when the user has filled out the form and wants to add the new course
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        errors = ""
//        retrieveData()
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
                course.deleteNotifications()
                NotificationHandler.scheduleNotificationsForCourse(course: course)
                
                if let user = app.currentUser {
                    partitionKey = user.id
                }
                course.initializeData(name: name, colorHex: colorValue, location: location, additionalDetails: additionalDetails, startDate: startDate, endDate: endDate, days: daysSelected, systemImageString: systemImageString, notificationAlertTimes: alertTimes, partitionKey: partitionKey)
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
            dismiss(animated: true, completion: delegate?.loadCourses)
        }else{
            self.replaceLabelText(text: errors, section: 3, row: 0)
            reloadData()
        }
    }
    
    
    
    //handles when the user wants to cancel their form
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    //resets necessary data and reloads the tableView
    func reloadData(){
//        times = [startDate, endDate]
//        timeCounter = 0
//        pickerCounter = 0
        tableView.reloadData()
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

//MARK: - TableView Delegate
extension AddCourseViewController{
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
                    
    private func timeCellClicked(indexPath: IndexPath) {
        guard let timeCell = tableView.cellForRow(at: indexPath) as? TimeCell else {
            return
        }
        var timeCellIndex = indexPath.row

//        let timeCell = cells[indexPath.section][indexPath.row] as? TimeCell
//        var pickerIndex: Int? =
        tableView.beginUpdates()
        
        /// Find the first time picker (if there is one) and remove it
        if let indexOfFirstTimePicker = self.findFirstPickerCellIndex(section: indexPath.section) {
            cells[indexPath.section].remove(at: indexOfFirstTimePicker)
            tableView.deleteRows(at: [IndexPath(row: indexOfFirstTimePicker, section: indexPath.section)], with: .right)
            /// Clicked on time cell while corresopnding timepicker is already expanded.
            if indexOfFirstTimePicker == indexPath.row + 1 {
                tableView.endUpdates()
                return
            /// Clicked on time cell while above timepicker is expanded
            } else if indexOfFirstTimePicker == indexPath.row - 1 {
                /// Remove one from the index since we removed a cell above
                timeCellIndex -= 1
            }
        }

//        let newIndex = cellText[indexPath.section].firstIndex(of: selectedRowText)! + 1
        cells[indexPath.section].insert(.timePickerCell(dateString: "\(timeCell.date!.format(with: "h:mm a"))", delegate: self), at: timeCellIndex + 1)
        tableView.insertRows(at: [IndexPath(row: timeCellIndex + 1, section: indexPath.section)], with: .left)
//        tableView.reloadData()
//        cellType[indexPath.section].insert(.timePickerCell, at: newIndex)
//        cellText[indexPath.section].insert("\(timeCell.date!.format(with: "h:mm a"))", at: newIndex)
        tableView.endUpdates()
//        }
    }
    
    //mostly handles what occurs when the user selects a TimeCell, and pickers must be removed/added
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        view.endEditing(true)
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let selectedRowText = cellText[indexPath.section][indexPath.row]
//        if cellType[indexPath.section][indexPath.row] == .timeCell{
//            let timeCell = tableView.cellForRow(at: indexPath) as! TimeCell
//            let pickerIndex = cellType[indexPath.section].firstIndex(of: .timePickerCell)
//
//            tableView.beginUpdates()
//
//            if let index = pickerIndex{
//                cellText[indexPath.section].remove(at: index)
//                cellType[indexPath.section].remove(at: index)
//                tableView.deleteRows(at: [IndexPath(row: index, section: indexPath.section)], with: .right)
//                if index == indexPath.row + 1{
//                    tableView.endUpdates()
//                    return
//                }
//            }
//
//            let newIndex = cellText[indexPath.section].firstIndex(of: selectedRowText)! + 1
//            tableView.insertRows(at: [IndexPath(row: newIndex, section: indexPath.section)], with: .left)
//
//            cellType[indexPath.section].insert(.timePickerCell, at: newIndex)
//            cellText[indexPath.section].insert("\(timeCell.date!.format(with: "h:mm a"))", at: newIndex)
//            tableView.endUpdates()
//        }else if cellType[indexPath.section][indexPath.row] == .logoCell {
//            performSegue(withIdentifier: "toLogoSelection", sender: self)
//        }else if cellText[indexPath.section][indexPath.row] == "Remind Me"{ //user selected "Remind Me"
//            performSegue(withIdentifier: "toAlertSelection", sender: self)
//        }
//
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? LogoSelectorViewController {
            destinationVC.delegate = self
            guard let colorCellRow = cells[2].firstIndex(where: { cell in
                if case .colorPickerCell = cell {
                    return true
                }
                return false
            }) else {
                return
            }
            guard let colorCell = tableView.cellForRow(at: IndexPath(row: colorCellRow, section: 2)) as? ColorPickerCell else {
                return
            }
            destinationVC.color = colorCell.colorPreview.backgroundColor ?? .white
        }else if let destinationVC = segue.destination as? AlertTableViewController{
            destinationVC.delegate = self
//            destinationVC.alertTimes = alertTimes
        }
    }
}

extension AddCourseViewController: UITextFieldDelegateExt{
    func textEdited(sender: UITextField, textFieldID: FormCellID) {
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
        default:
            print("$ ERROR: unknown field when editing text.\n File: \(#file)\nFunction: \(#function)\nLine: \(#line)")
        }
    }
}

extension AddCourseViewController: DaySelectorDelegate{
    func dayButtonPressed(sender: UIButton) {
        print("dayButton pressed")
        if sender.isSelected {
            sender.isSelected = false
            for i in 0...daysSelected.count-1 {
                if daysSelected[i] == K.weekdayDict[sender.titleLabel!.text!]!{
                    daysSelected.remove(at: i)
                }
            }
        }else{//day was not selected, and we are now selecting it.
            sender.isSelected = true
            daysSelected.append(K.weekdayDict[sender.titleLabel!.text!]!)
        }
    }
}

extension AddCourseViewController: ColorDelegate{
    func colorPickerValueChanged(sender: RadialPaletteControl) {
        colorValue = sender.selectedColor.hexValue()
    }
    
}

//MARK: - TimePicker Delegate
extension AddCourseViewController: UITimePickerDelegate{
    func pickerValueChanged(sender: UIDatePicker, indexPath: IndexPath) {
        //we are getting the timePicker's corresponding timeCell by accessing its indexPath and getting the element in the tableView right before it. This is always the timeCell it needs to update. The indexPath of the timePicker is stored in the cell's class upon creation, so that it can be passed to this function when needed.
        let correspondingTimeCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as! TimeCell
        correspondingTimeCell.date = sender.date
        correspondingTimeCell.timeLabel.text = correspondingTimeCell.date!.format(with: "h:mm a")
        
        if case .timeCell = cells[indexPath.section][indexPath.row - 1] {
//        if cellText[indexPath.section][indexPath.row - 1] == "Starts" {
            print("startDate changed")
            startDate = sender.date
        } else {
            print("endDate changed")
            endDate = sender.date
        }
    }
}

extension AddCourseViewController{
    func fillForm(with course: Course){
        reloadData()
        
        navButton.image = .none
        navButton.title = "Done"
        
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
