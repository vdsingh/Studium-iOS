
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
    
    //arrays that structure the form (determine each type of cell and what goes in them for the most part)
//    var cellText: [[String]] = [
//        ["Name", "Location", "Days", "Remind Me"],
//        ["Starts", "Ends"], ["Logo", "Color Picker", "Additional Details"],
//        [""]
//    ]
    
//    cell.label.text = cellText[indexPath.section][indexPath.row]
//    return cell
    
//    lazy var cells: [[FormCell]] = {
//        [
//            [
//                .textFieldCell(placeholderText: "Name", textFieldDelegate: self),
//                .textFieldCell(placeholderText: "Location", textFieldDelegate: self),
//                .daySelectorCell,
//                .labelCell
//            ],
//            [
//                .timeCell, .timeCell
//            ],
//            [
//                .logoCell,
//                .colorPickerCell,
//                .textFieldCell(placeholderText: "Additional Details", textFieldDelegate: self)
//            ],
//            [
//                .labelCell
//            ]
//        ]
//    }()
//    var cellType: [[String]] = [["TextFieldCell", "TextFieldCell", "DaySelectorCell", "LabelCell"],  ["TimeCell", "TimeCell"], ["LogoCell", "ColorPickerCell", "TextFieldCell"], ["LabelCell"]]
    
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
    
//    var alertTimes: [Int] = []
    
    var partitionKey: String = ""
    
    @IBOutlet weak var navButton: UIBarButtonItem!
    //called when the view loads
    
//    var cellText: [[String]] = [
//        ["Name", "Location", "Days", "Remind Me"],
//        ["Starts", "Ends"],
//        ["Logo", "Color Picker", "Additional Details"],
//        [""]
    
//    let cell = tableView.dequeueReusableCell(withIdentifier: TimeCell.id, for: indexPath) as! TimeCell
//    if cellText[indexPath.section][indexPath.row] == "Starts" {
//        cell.timeLabel.text = startDate.format(with: "h:mm a")
//        cell.date = startDate
//    } else {
//        cell.timeLabel.text = endDate.format(with: "h:mm a")
//        cell.date = endDate
//    }
//
//    cell.label.text = cellText[indexPath.section][indexPath.row]
//    return cell
    
    override func viewDidLoad() {
        self.cells = [
            [
                .textFieldCell(placeholderText: "Name", textFieldDelegate: self, delegate: self),
                .textFieldCell(placeholderText: "Location", textFieldDelegate: self, delegate: self),
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
                .textFieldCell(placeholderText: "Additional Details", textFieldDelegate: self, delegate: self)
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
//        let logoCell = tableView.cellForRow(at: indexPath) as! LogoCell
//        logoCell.setImage(systemImageName: systemImageString)
//        logoCell.systemImageString = systemImageString
    }
    
    //final step that occurs when the user has filled out the form and wants to add the new course
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        errors = ""
//        retrieveData()
        endDate = Calendar.current.date(bySettingHour: endDate.hour, minute: endDate.minute, second: endDate.second, of: startDate)!
        if name == ""{
            errors.append(" Please specify a course name.")
        }
        
        if daysSelected == []{
            errors.append(" Please specify at least one day.")
        }
        
        if endDate.isEarlier(than: startDate){
            //            print("start date: \(startDate), end date: \(endDate)")
            errors.append(" End time cannot occur before start time.")
        }
        
        if errors.count == 0{
            if course == nil{
                let newCourse = Course()
                if let user = app.currentUser {
                    partitionKey = user.id
                }
                newCourse.initializeData(name: name, colorHex: colorValue, location: location, additionalDetails: additionalDetails, startDate: startDate, endDate: endDate, days: daysSelected, systemImageString: systemImageString, notificationAlertTimes: alertTimes, partitionKey: partitionKey)
                //scheduling the appropriate notifications
                for alertTime in alertTimes{
                    for day in daysSelected{
//                        let weekday = Date.convertDayToWeekday(day: day)
//                        let weekdayAsInt = Date.convertDayToInt(day: day)
                        var alertDate = Date()
                        if startDate.weekday != day{ //the course doesn't occur today
                            alertDate = Date.today().next(Date.convertDayToWeekday(day: day))
                        }
                        
                        alertDate = Calendar.current.date(bySettingHour: startDate.hour, minute: startDate.minute, second: 0, of: alertDate)!
                        
                        alertDate -= (60 * Double(alertTime))
                        //                    alertDate = startDate - (60 * Double(alertTime))
                        //consider how subtracting time from alertDate will affect the weekday component.
                        let courseComponents = DateComponents(hour: alertDate.hour, minute: alertDate.minute, second: 0, weekday: alertDate.weekday)
                        //                    print(courseComponents)
                        
                        //adjust title as appropriate
                        var title = ""
                        if alertTime < 60{
                            title = "\(name) starts in \(alertTime) minutes."
                        }else if alertTime == 60{
                            title = "\(name) starts in 1 hour"
                        }else{
                            title = "\(name) starts in \(alertTime / 60) hours"
                        }
                        //                    let alertTimeDouble: Double = Double(alertTime)
                        let timeFormat = startDate.format(with: "h:mm a")
                        
                        
                        let identifier = UUID().uuidString
                        //keeping track of the identifiers of notifs associated with the course.
                        newCourse.notificationIdentifiers.append(identifier)

                        scheduleNotification(components: courseComponents, body: "Be there by \(timeFormat). Don't be late!", titles: title, repeatNotif: true, identifier: identifier)
                    }
                }
                RealmCRUD.saveCourse(course: newCourse)
                newCourse.addToAppleCalendar()
            }else{
                do{
                    try realm.write{
                        print("the system image string: \(systemImageString)")
                        course!.deleteNotifications()
                        for alertTime in alertTimes{
                            for day in daysSelected{
//                                let weekday = Date.convertDayToWeekday(day: day)
//                                let weekdayAsInt = Date.convertDayToInt(day: day)
                                var alertDate = Date()
                                if startDate.weekday != day{
                                    alertDate = Date.today().next(Date.convertDayToWeekday(day: day))
                                }
                                
                                alertDate = Calendar.current.date(bySettingHour: startDate.hour, minute: startDate.minute, second: 0, of: alertDate)!
                            
                                alertDate -= (60 * Double(alertTime))
                                let courseComponents = DateComponents(hour: alertDate.hour, minute: alertDate.minute, second: 0, weekday: alertDate.weekday)
                            
                            //adjust title as appropriate
                                var title = ""
                                if alertTime < 60{
                                    title = "\(name) starts in \(alertTime) minutes."
                                }else if alertTime == 60{
                                    title = "\(name) starts in 1 hour"
                                }else{
                                    title = "\(name) starts in \(alertTime / 60) hours"
                                }
                            //                    let alertTimeDouble: Double = Double(alertTime)
                            let timeFormat = startDate.format(with: "h:mm a")
                            
                            let identifier = UUID().uuidString
                            //keeping track of the identifiers of notifs associated with the course.
                            course!.notificationIdentifiers.append(identifier)

                            scheduleNotification(components: courseComponents, body: "Be there by \(timeFormat). Don't be late!", titles: title, repeatNotif: true, identifier: identifier)
                            }
                        }
                        if let user = app.currentUser {
                            partitionKey = user.id
                        }
                        course!.initializeData(name: name, colorHex: colorValue, location: location, additionalDetails: additionalDetails, startDate: startDate, endDate: endDate, days: daysSelected, systemImageString: systemImageString, notificationAlertTimes: alertTimes, partitionKey: partitionKey)
                    }
                }catch{
                    print(error)
                }
            }
            dismiss(animated: true, completion: delegate?.loadCourses)
        }else{
            self.replaceLabelText(text: errors, section: 3, row: 0)
//            cellText[3][0] = errors
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
    
    // Constructs the form based on information mostly from the main arrays.
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellType = cellType[indexPath.section][indexPath.row]
//        let cellText = cellText[indexPath.section][indexPath.row]
//        switch cellType {
//        case .textFieldCell:
//            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.id, for: indexPath) as! TextFieldCell
//            cell.textField.placeholder = cellText
//            cell.textField.delegate = self
//            cell.delegate = self
//            return cell
//        case .timeCell:
//            let cell = tableView.dequeueReusableCell(withIdentifier: TimeCell.id, for: indexPath) as! TimeCell
//            if cellText[indexPath.section][indexPath.row] == "Starts" {
//                cell.timeLabel.text = startDate.format(with: "h:mm a")
//                cell.date = startDate
//            } else {
//                cell.timeLabel.text = endDate.format(with: "h:mm a")
//                cell.date = endDate
//            }
//
//            cell.label.text = cellText[indexPath.section][indexPath.row]
//            return cell
//        case .timePickerCell:
//            let cell = tableView.dequeueReusableCell(withIdentifier: TimePickerCell.id, for: indexPath) as! TimePickerCell
//            cell.delegate = self
//            cell.indexPath = indexPath
//            let dateString = cellText[indexPath.section][indexPath.row]
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "h:mm a"
//            let date = dateFormatter.date(from: dateString)!
//            cell.picker.setDate(date, animated: true)
//            return cell
//        case .daySelectorCell:
//            let cell = tableView.dequeueReusableCell(withIdentifier: DaySelectorCell.id, for: indexPath) as! DaySelectorCell
//            cell.delegate = self
//            return cell
//        case .labelCell:
//            let cell = tableView.dequeueReusableCell(withIdentifier: LabelCell.id, for: indexPath) as! LabelCell
//            if indexPath.section == 0 && indexPath.row == 3{
//                //                cell.label.textColor = .black
//                cell.accessoryType = .disclosureIndicator
//            }else{
//                cell.backgroundColor = .systemBackground
//                cell.label.textColor = UIColor.red
//            }
//            cell.label.text = cellText[indexPath.section][indexPath.row]
//            //print("added a label cell")
//            return cell
//
//        case .colorPickerCell:
//            let cell = tableView.dequeueReusableCell(withIdentifier: ColorPickerCell.id, for: indexPath) as! ColorPickerCell
//            cell.delegate = self
//            return cell
//        case .logoCell:
//            let cell = tableView.dequeueReusableCell(withIdentifier: LogoCell.id, for: indexPath) as! LogoCell
//            //cell.delegate = self
//            cell.setImage(systemImageName: systemImageString)
//            return cell
//        default:
//            return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        }
//    }
}

//MARK: - TableView Delegate
extension AddCourseViewController{
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if cellType[indexPath.section][indexPath.row] == .pickerCell ||
//            cellType[indexPath.section][indexPath.row] == .timePickerCell ||
//            cellType[indexPath.section][indexPath.row] == .colorPickerCell
//        {
//            return 150
//        }
//        if(cellType[indexPath.section][indexPath.row] == .logoCell){
//            return 60
//        }
//        return 50
//    }
    
    private func findFirstPickerCellIndex(section: Int) -> Int? {
        for i in 0...cells[section].count {
            switch cells[section][i] {
            case .timePickerCell(_, _):
                return i
            default:
                continue
            }
        }
        return nil
    }

    private func timeCellClicked(indexPath: IndexPath) {
        guard let timeCell = tableView.cellForRow(at: indexPath) as? TimeCell else {
            return
        }
//        let timeCell = cells[indexPath.section][indexPath.row] as? TimeCell
//        var pickerIndex: Int? =
//        tableView.beginUpdates()

        if let index = findFirstPickerCellIndex(section: indexPath.section) {
            cells[indexPath.section].remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: indexPath.section)], with: .right)
            if index == indexPath.row + 1{
                tableView.endUpdates()
                return
            }
        }

//        let newIndex = cellText[indexPath.section].firstIndex(of: selectedRowText)! + 1
//        tableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .left)
        
        cells[indexPath.section].insert(.timePickerCell(dateString: "\(timeCell.date!.format(with: "h:mm a"))", delegate: self), at: indexPath.row + 1)
        tableView.reloadData()
//        cellType[indexPath.section].insert(.timePickerCell, at: newIndex)
//        cellText[indexPath.section].insert("\(timeCell.date!.format(with: "h:mm a"))", at: newIndex)
//        tableView.endUpdates()
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
//            let colorCellIndexPath = self.findFirstOccurrenceOfCell(cell: .colorPickerCell, section: 2)
            guard let colorCellRow = cells[2].firstIndex(where: { cell in
                if case .colorPickerCell = cell {
                    return true
                }
                return false
            }) else {
                return
            }
//            let colorCellIndexPath = cells[2].ind
        
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
    func textEdited(sender: UITextField) {
        if sender.placeholder == "Name"{
            name = sender.text!
        }else if sender.placeholder == "Location"{
            location = sender.text!
        }else if sender.placeholder == "Additional Details"{
            additionalDetails = sender.text!
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

//makes the keyboard dismiss when user clicks done
extension UIViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}



//date extension to get the next weekday of the week (i.e. next monday)
extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
}

// MARK: Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case next
        case previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
    
    //own added methods
    static func convertDayToInt(day: String) -> Int{
        switch day{
        case "Mon":
            return 2
        case "Tue":
            return 3
        case "Wed":
            return 4
        case "Thu":
            return 5
        case "Fri":
            return 6
        case "Sat":
            return 7
        case "Sun":
            return 1
        default:
            return -1
        }
    }
    
    static func convertDayToWeekday(day: Int) -> Weekday{
        switch day{
        case 2:
            return .monday
        case 3:
            return .tuesday
        case 4:
            return .wednesday
        case 5:
            return .thursday
        case 6:
            return .friday
        case 7:
            return .saturday
        case 1:
            return .sunday
        default:
            return .monday
        }
    }
}
