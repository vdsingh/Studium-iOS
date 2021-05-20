
import Foundation
import UIKit
import RealmSwift
import FlexColorPicker
import EventKit

//makes sure that the course list can refresh when a new course is added
protocol CourseRefreshProtocol{
    func loadCourses()
}

class AddCourseViewController: MasterForm, LogoStorer, AlertInfoStorer{
    var course: Course?
    
    //system image string that identifies what the logo of the course will be.
    var systemImageString: String = "pencil"
    
    //link to the list that is to be refreshed when a new course is added.
    var delegate: CourseRefreshProtocol?
    
    //arrays that structure the form (determine each type of cell and what goes in them for the most part)
    var cellText: [[String]] = [["Name", "Location", "Days", "Remind Me"], ["Starts", "Ends"], ["Logo", "Color Picker", "Additional Details"], [""]]
    var cellType: [[String]] = [["TextFieldCell", "TextFieldCell", "DaySelectorCell", "LabelCell"],  ["TimeCell", "TimeCell"], ["LogoCell", "ColorPickerCell", "TextFieldCell"], ["LabelCell"]]
    
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
    
    var alertTimes: [Int] = []
    
    var partitionKey: String = ""
    
    @IBOutlet weak var navButton: UIBarButtonItem!
    //called when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        //register custom cells for form
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
        tableView.register(UINib(nibName: "TimeCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
        tableView.register(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "PickerCell") //a cell that allows user to pick time (e.g. 2 hours, 4 mins)
        
        tableView.register(UINib(nibName: "TimePickerCell", bundle: nil), forCellReuseIdentifier: "TimePickerCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "DaySelectorCell", bundle: nil), forCellReuseIdentifier: "DaySelectorCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "LabelCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "SegmentedControlCell", bundle: nil), forCellReuseIdentifier: "SegmentedControlCell")
        tableView.register(UINib(nibName: "ColorPickerCell", bundle: nil), forCellReuseIdentifier: "ColorPickerCell")
        tableView.register(UINib(nibName: "LogoCell", bundle: nil), forCellReuseIdentifier: "LogoCell")
        
        navButton.image = UIImage(systemName: "plus")
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        //makes it so that there are no empty cells at the bottom
        tableView.tableFooterView = UIView()
        
        if course != nil{
            fillForm(with: course!)
        }
    }
    
    //when we pick a logo, this function is called to update the preview on the logo cell.
    func refreshLogoCell() {
        let logoCellRow = cellType[2].firstIndex(of: "LogoCell")!
        let logoCell = tableView.cellForRow(at: IndexPath(row: logoCellRow, section: 2)) as! LogoCell
        logoCell.setImage(systemImageName: systemImageString)
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
                //            print(UIApplication.shared.scheduledLocalNotifications)
                save(course: newCourse)
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
            cellText[3][0] = errors
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
    
    //saves the new course to the Realm database.
    func save(course: Course){
        if let user = app.currentUser {
            do{
                realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
                try realm.write{
                    realm.add(course)
                    print("the user id is: \(user.id)")
                    print("saved course with partitionKey: \(course._partitionKey)")
                }
            }catch{
                print("error saving course: \(error)")
            }
            course.addToAppleCalendar()
        }else{
            print("error accessing user")
        }
    }
}

//MARK: - TableView DataSource
extension AddCourseViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellType.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellText[section].count
    }
    
    //constructs the form based on information mostly from the main arrays.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellType[indexPath.section][indexPath.row] == "TextFieldCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.textField.placeholder = cellText[indexPath.section][indexPath.row]
            cell.textField.delegate = self
            cell.delegate = self
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "TimeCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
            if cellText[indexPath.section][indexPath.row] == "Starts"{
                cell.timeLabel.text = startDate.format(with: "h:mm a")
                cell.date = startDate
            }else{
                cell.timeLabel.text = endDate.format(with: "h:mm a")
                cell.date = endDate
            }
            
            cell.label.text = cellText[indexPath.section][indexPath.row]
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "TimePickerCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimePickerCell", for: indexPath) as! TimePickerCell
            cell.delegate = self
            cell.indexPath = indexPath
            let dateString = cellText[indexPath.section][indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let date = dateFormatter.date(from: dateString)!
            cell.picker.setDate(date, animated: true)
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "DaySelectorCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DaySelectorCell", for: indexPath) as! DaySelectorCell
            cell.delegate = self
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "LabelCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
            if indexPath.section == 0 && indexPath.row == 3{
                //                cell.label.textColor = .black
                cell.accessoryType = .disclosureIndicator
            }else{
                cell.label.textColor = UIColor.red
            }
            cell.label.text = cellText[indexPath.section][indexPath.row]
            //print("added a label cell")
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "ColorPickerCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorPickerCell", for: indexPath) as! ColorPickerCell
            cell.delegate = self
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "LogoCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogoCell", for: indexPath) as! LogoCell
            //cell.delegate = self
            cell.setImage(systemImageName: systemImageString)
            return cell
        }else{
            return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
    }
}

//MARK: - TableView Delegate
extension AddCourseViewController{
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellType[indexPath.section][indexPath.row] == "PickerCell" || cellType[indexPath.section][indexPath.row] == "TimePickerCell" || cellType[indexPath.section][indexPath.row] == "ColorPickerCell"{
            return 150
        }
        if(cellType[indexPath.section][indexPath.row] == "LogoCell"){
            return 60
        }
        return 50
    }
    
    //mostly handles what occurs when the user selects a TimeCell, and pickers must be removed/added
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedRowText = cellText[indexPath.section][indexPath.row]
        if cellType[indexPath.section][indexPath.row] == "TimeCell"{
            let timeCell = tableView.cellForRow(at: indexPath) as! TimeCell
            let pickerIndex = cellType[indexPath.section].firstIndex(of: "TimePickerCell")
            
            tableView.beginUpdates()
            
            if let index = pickerIndex{
                cellText[indexPath.section].remove(at: index)
                cellType[indexPath.section].remove(at: index)
                tableView.deleteRows(at: [IndexPath(row: index, section: indexPath.section)], with: .right)
                if index == indexPath.row + 1{
                    tableView.endUpdates()
                    return
                }
            }
            
            let newIndex = cellText[indexPath.section].firstIndex(of: selectedRowText)! + 1
            tableView.insertRows(at: [IndexPath(row: newIndex, section: indexPath.section)], with: .left)
            
            cellType[indexPath.section].insert("TimePickerCell", at: newIndex)
            cellText[indexPath.section].insert("\(timeCell.date!.format(with: "h:mm a"))", at: newIndex)
            tableView.endUpdates()
        }else if cellType[indexPath.section][indexPath.row] == "LogoCell"{
            performSegue(withIdentifier: "toLogoSelection", sender: self)
        }else if cellText[indexPath.section][indexPath.row] == "Remind Me"{ //user selected "Remind Me"
            performSegue(withIdentifier: "toAlertSelection", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? LogoSelectorViewController {
            destinationVC.delegate = self
            let colorCell = tableView.cellForRow(at: IndexPath(row: cellType[2].firstIndex(of: "ColorPickerCell")!, section: 2)) as! ColorPickerCell
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
            print("name edited")
            name = sender.text!
        }else if sender.placeholder == "Location"{
            print("location edited")
            location = sender.text!
        }else if sender.placeholder == "Additional Details"{
            print("additionalDetails edited")
            additionalDetails = sender.text!
        }
    }
}

extension AddCourseViewController: DaySelectorDelegate{
    func dayButtonPressed(sender: UIButton) {
        print("dayButton pressed")
//        let dayTitle =
        if sender.isSelected{
            sender.isSelected = false
            for i in 0...daysSelected.count-1 {
                if daysSelected[i] == K.weekdayDict[sender.titleLabel!.text!]!{
                    daysSelected.remove(at: i)
                }
            }
//            if (daysSelected.contains(K.weekdayDict[sender.titleLabel!.text!]!)){
//                daysSelected.remove(at: daysSelected.firstIndex(of: K.weekdayDict[sender.titleLabel!.text!]!)!)
//            }
//            for day in daysSelected{
//                if day == dayTitle{//if day is already selected, and we select it again
//                    daysSelected.remove(at: daysSelected.firstIndex(of: day)!)
//                }
//            }
        }else{//day was not selected, and we are now selecting it.
            sender.isSelected = true
            daysSelected.append(K.weekdayDict[sender.titleLabel!.text!]!)

//            daysSelected.append(dayTitle!)
        }
    }
}

extension AddCourseViewController: ColorDelegate{
    func colorPickerValueChanged(sender: RadialPaletteControl) {
        print("colorValue changed")
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
        
        if cellText[indexPath.section][indexPath.row - 1] == "Starts"{
            print("startDate changed")
            startDate = sender.date
        }else{
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
//
//        colorCell.colorPicker.selectedColor = .purple
//        colorCell.colorPicker.reloadInputViews()
        
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
