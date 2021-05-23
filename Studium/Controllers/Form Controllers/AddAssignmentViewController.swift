import Foundation
import UIKit
import RealmSwift

protocol AssignmentRefreshProtocol{
    func loadAssignments()
}

class AddAssignmentViewController: MasterForm, AlertInfoStorer{
    //holds the assignment being edited if an assignment is being edited.
    var assignment: Assignment?
    
    //boolean that tells us whether the user came from the TodoEvent form. This is so that we can fill already existing data from that form (can't use edit feature because that requires an existing assignment)
    var fromTodoForm: Bool = false;
    //String field data from todo form. [name, data]
    var todoFormData: [String] = ["", ""]
    //alert times data from todo form.
    var todoAlertTimes: [Int] = []
    var todoDueDate: Date = Date()
    
    //variables that hold the total length of the habit.
    var scheduleWorkTime: Bool = false
    var workDaysSelected: [Int] = []
    var workTimeHours = 1
    var workTimeMinutes = 0
    
    
    //a list of courses so that the user can pick which course the assignment is attached to
    var courses: Results<Course>? = nil
    
    //link to the main list of assignments, so it can refresh when we add a new one
    var delegate: AssignmentRefreshProtocol?
    
    //array variables that lay our form out into sections and rows
    var cellText: [[String]] = [["Name", "Due Date", "Remind Me"], ["Schedule Time to Work"], ["Course"], ["Additional Details", ""]]
    var cellType: [[String]] = [["TextFieldCell", "TimeCell", "LabelCell"], ["SwitchCell"], ["PickerCell"], ["TextFieldCell", "LabelCell"]]
    
    //errors string that is displayed if there are any issues (e.g: user didnt enter a name)
    var errors: String = ""
    
    //basic assignment variables
    
    var dueDate = Date()
    var selectedCourse: Course? = nil
    var name: String = ""
    var additionalDetails: String = ""
    
    var alertTimes: [Int] = []
    
    @IBOutlet weak var navButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        //registering the necessary cells for the form.
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
        tableView.register(UINib(nibName: "TimeCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
        tableView.register(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "PickerCell")
        tableView.register(UINib(nibName: "TimePickerCell", bundle: nil), forCellReuseIdentifier: "TimePickerCell")
        tableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "LabelCell")
        tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        tableView.register(UINib(nibName: "DaySelectorCell", bundle: nil), forCellReuseIdentifier: "DaySelectorCell")
        tableView.tableFooterView = UIView()
        
        //getting all courses from realm to populate the course picker.
        guard let user = app.currentUser else {
            print("Error getting user in MasterForm")
            return
        }
        realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
        courses = realm.objects(Course.self)
        
        dueDate = Calendar.current.date(bySetting: .hour, value: 23, of: dueDate)!
        dueDate = Calendar.current.date(bySetting: .minute, value: 59, of: dueDate)!
        
        if assignment != nil{
            alertTimes = [];
            for alert in assignment!.notificationAlertTimes{
                alertTimes.append(alert)
            }
            
            for day in assignment!.days{
                workDaysSelected.append(day)
            }
            guard let course = assignment!.parentCourse else{
                print("Error accessing parent course in AssignmentCell1")
                return
            }
            fillForm(name: assignment!.name, additionalDetails: assignment!.additionalDetails, alertTimes: alertTimes, dueDate: assignment!.endDate, selectedCourse: course, scheduleWorkTime: assignment!.autoschedule, workTimeMinutes: assignment!.autoLengthMinutes, workDays: workDaysSelected)
        }else if fromTodoForm{
            //THIS IS BROKEN PLEASE FIX. ASSIGNMENT IS NIL, SO THERE IS NO PARENT COURSE. FIX LATER
            fillForm(name: todoFormData[0], additionalDetails: todoFormData[1], alertTimes: todoAlertTimes, dueDate: todoDueDate, selectedCourse: assignment!.parentCourse!, scheduleWorkTime: false, workTimeMinutes: 0, workDays: [])
        }else{
            navButton.image = UIImage(systemName: "plus")
        }
    }
    
    //method that is triggered when the user wants to finalize the form
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        errors = ""
        if name == ""{
            errors.append(" Please specify a name.")
        }
        
        if errors == "" {
            if assignment == nil{
                print("adding assignment for the first time")
                guard let user = app.currentUser else {
                    print("Error getting user")
                    return
                }
                let newAssignment = Assignment()
                newAssignment.initializeData(name: name, additionalDetails: additionalDetails, complete: false, startDate: dueDate - (60*60), endDate: dueDate, course: selectedCourse!, notificationAlertTimes: alertTimes, autoschedule: scheduleWorkTime, autoLengthMinutes: workTimeMinutes, autoDays: workDaysSelected, partitionKey: user.id)
                
                for alertTime in alertTimes{
                    let alertDate = dueDate - (Double(alertTime) * 60)
                    var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alertDate)
                    components.second = 0
                    
                    let identifier = UUID().uuidString
                    newAssignment.notificationIdentifiers.append(identifier)
                    scheduleNotification(components: components, body: "", titles: "\(name) due at \(dueDate.format(with: "h:mm a"))", repeatNotif: false, identifier: identifier)
                }
                print("Created new Assignment with \(scheduleWorkTime) workTime \(workTimeMinutes) workTimeMinutes and \(workTimeHours) workTimeHours")
                RealmCRUD.saveAssignment(assignment: newAssignment)
            }else{
                do{
                    try realm.write{
                        assignment!.updateNotifications(with: alertTimes)
                    }
                    for alertTime in alertTimes{
                        if !assignment!.notificationAlertTimes.contains(alertTime){
                            let alertDate = dueDate - (Double(alertTime) * 60)
                            var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alertDate)
                            components.second = 0
                            let identifier = UUID().uuidString
                            try realm.write{
                                print("scheduling new notification for alertTime: \(alertTime)")
                                assignment!.notificationIdentifiers.append(identifier)
                                assignment!.notificationAlertTimes.append(alertTime)
                            }
                            scheduleNotification(components: components, body: "", titles: "\(name) due at \(dueDate.format(with: "h:mm a"))", repeatNotif: false, identifier: identifier)
                        }
                    }
                    try realm.write{
                        print("Edited Assignment with \(workTimeHours) and \(workTimeMinutes)")
                        guard let user = app.currentUser else {
                            print("Error getting user")
                            return
                        }
                        assignment!.initializeData(name: name, additionalDetails: additionalDetails, complete: false, startDate: dueDate - (60*60), endDate: dueDate, course: selectedCourse!, notificationAlertTimes: alertTimes, autoschedule: scheduleWorkTime, autoLengthMinutes: workTimeMinutes, autoDays: workDaysSelected, partitionKey: user.id)
                        
                    }
                }catch{
                    print("there was an error: \(error)")
                }
            }
            delegate?.loadAssignments()
            dismiss(animated: true, completion: nil)
        }else{
            cellText[3][1] = errors
            tableView.reloadData()
        }
    }
    
    //method called when user wants to cancel
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
        
    //set the course picker to whatever course was originally selected, if any
    func setDefaultRow(picker: UIPickerView){
        var row = 0
        if selectedCourse == nil{
//            print("selectedCourse is nil. User probably initiated this form from the general add event form")
            return
        }
        if let coursesArr = courses{
            for course in coursesArr{
                if course.name == selectedCourse!.name{
                    picker.selectRow(row, inComponent: 0, animated: true)
                    break
                }
                row += 1
            }
        }else{
            print("error. courses in AddAssignment is nil")
        }
    }
    
    func fillForm(name: String, additionalDetails: String, alertTimes: [Int], dueDate: Date, selectedCourse: Course, scheduleWorkTime: Bool, workTimeMinutes: Int, workDays: [Int]){
        navButton.image = .none
        navButton.title = "Done"
        
        print("attempting to fillForm with \(scheduleWorkTime)")
        
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        nameCell.textField.text = name
        self.name = name
        
        let dueDateCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TimeCell
        self.dueDate = dueDate
//        dueDateCell.timeLabel.text = "dueDate.format(with: "h:mm a")"
//        dueDateCell.timeLabel.text = "Hello!"
        dueDateCell.date = dueDate
        
        self.alertTimes = alertTimes
//        alertTimes = []
//        for alert in assignment.notificationAlertTimes{
//            alertTimes.append(alert)
//        }
        
        
        self.scheduleWorkTime = scheduleWorkTime
        if scheduleWorkTime == true{
            
            let scheduleWorkCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! SwitchCell
            scheduleWorkCell.tableSwitch.isOn = true
            self.switchValueChanged(sender: scheduleWorkCell.tableSwitch)
            
            let daysCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! DaySelectorCell
            daysCell.selectDays(days: workDays)
            self.workDaysSelected = workDays
            
            self.workTimeHours = workTimeMinutes / 60
            self.workTimeMinutes = workTimeMinutes % 60
            
            let workTimePickerCell = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as! PickerCell
//            workTimePickerCell.picker.
            workTimePickerCell.picker.selectRow(workTimeHours, inComponent: 0, animated: true)
            workTimePickerCell.picker.selectRow(workTimeMinutes, inComponent: 1, animated: true)


        }
        
        self.selectedCourse = selectedCourse
        
        let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! TextFieldCell
        additionalDetailsCell.textField.text = additionalDetails
        self.additionalDetails = additionalDetails
    }
}



//MARK: - TableView DataSource

//sets the amount of sections and rows of the form
extension AddAssignmentViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellType.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellText[section].count
    }
    
    //information on what to do/other important calls when the form is being created
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellType[indexPath.section][indexPath.row] == "TextFieldCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.textField.placeholder = cellText[indexPath.section][indexPath.row]
            cell.textField.delegate = self
            cell.delegate = self
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "TimeCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
            cell.date = dueDate
            cell.timeLabel.text = dueDate.format(with: "MMM d, h:mm a")
            cell.label.text = cellText[indexPath.section][indexPath.row]
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "PickerCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as! PickerCell
            cell.picker.delegate = self
            cell.picker.dataSource = self
            
            if cellText[indexPath.section][indexPath.row] == "Course"{
                cell.picker.tag = 1
                setDefaultRow(picker: cell.picker)
            }else if cellText[indexPath.section][indexPath.row] == "Length"{
                cell.picker.tag = 0
            }
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "TimePickerCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimePickerCell", for: indexPath) as! TimePickerCell
            cell.picker.datePickerMode = .dateAndTime
            cell.picker.date = dueDate
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "LabelCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
            cell.label.text = cellText[indexPath.section][indexPath.row]
            
            if indexPath.section == 3{
                cell.label.textColor = UIColor.red
            }else{
                cell.accessoryType = .disclosureIndicator
            }
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "SwitchCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.delegate = self
            cell.label.text = cellText[indexPath.section][indexPath.row]
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "DaySelectorCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DaySelectorCell", for: indexPath) as! DaySelectorCell
            cell.delegate = self
            return cell
        }else{
            return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
    }
}

//MARK: - TableView Delegate

//determines other important featuers of the form
extension AddAssignmentViewController{
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    //handles adding and removing Pickers when necessary
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        
        let selectedRowText = cellText[indexPath.section][indexPath.row]
        if cellType[indexPath.section][indexPath.row] == "TimeCell"{
            let timeCell = tableView.cellForRow(at: indexPath) as! TimeCell
            var pickerIndex = cellType[indexPath.section].firstIndex(of: "TimePickerCell")
            if pickerIndex == nil{
                pickerIndex = cellType[indexPath.section].firstIndex(of: "PickerCell")
            }
            tableView.beginUpdates()
            
            if let index = pickerIndex{
                cellText[indexPath.section].remove(at: index)
                cellType[indexPath.section].remove(at: index)
                tableView.deleteRows(at: [IndexPath(row: index, section: indexPath.section)], with: .right)
                if index == indexPath.row + 1{
                    //print(cellText[indexPath.row - 1])
                    tableView.endUpdates()
                    return
                }
            }
            
            let newIndex = cellText[indexPath.section].firstIndex(of: selectedRowText)! + 1
            
            tableView.insertRows(at: [IndexPath(row: newIndex, section: indexPath.section)], with: .left)
            cellType[indexPath.section].insert("TimePickerCell", at: newIndex)
            cellText[indexPath.section].insert("\(timeCell.date!.format(with: "h:mm a"))", at: newIndex)
            tableView.endUpdates()
        }else if cellText[indexPath.section][indexPath.row] == "Remind Me"{ //user selected "Remind Me"
            performSegue(withIdentifier: "toAlertSelection", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AlertTableViewController{
            destinationVC.delegate = self
            //            destinationVC.alertTimes = alertTimes
        }
    }
}

 //MARK: - Cell DataSource and Delegates
extension AddAssignmentViewController: UITextFieldDelegateExt{
    func textEdited(sender: UITextField) {
        if sender.placeholder == "Name"{
            print("name edited")
            name = sender.text!
        }else if sender.placeholder == "Additional Details"{
            print("additionalDetails edited")
            additionalDetails = sender.text!
        }
    }
}

//MARK: - TimerPicker DataSource Methods
extension AddAssignmentViewController: UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return courses?.count ?? 1
        }else if pickerView.tag == 0{
            if component == 0{
                return 24
            }
            return 60
        }
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0{
            return 2
        }else if pickerView.tag == 1{
            return 1
        }
        return 0
    }
}

//MARK: - Picker Delegate Methods
extension AddAssignmentViewController: UIPickerViewDelegate{
    //helps set up information in the UIPickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            return courses![row].name
        }else if pickerView.tag == 0{
            if component == 0{
                return "\(row) hours"
            }
            return "\(row) min"
        }
        return "Unknown Picker"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellType[indexPath.section][indexPath.row] == "PickerCell" || cellType[indexPath.section][indexPath.row] == "TimePickerCell"{
            return 150
        }
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView.tag == 1{ //course selection
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            selectedCourse = courses![selectedRow]
        }else if pickerView.tag == 0{
            if component == 0{
                workTimeHours = row
            }else{
                workTimeMinutes = row
            }
           
        }
    }
}

//MARK: - Date/TimePicker Delegate Methods
extension AddAssignmentViewController: UITimePickerDelegate{
    
    //method that auto updates a corresponding TimeCell when a TimePicker is changed.
    func pickerValueChanged(sender: UIDatePicker, indexPath: IndexPath) {
        let correspondingTimeCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as! TimeCell
        correspondingTimeCell.date = sender.date
        correspondingTimeCell.timeLabel.text = sender.date.format(with: "MMM d, h:mm a")
        
        dueDate = sender.date
    }
}

extension AddAssignmentViewController: CanHandleSwitch{
    func switchValueChanged(sender: UISwitch) {
        print("switch changed")
        if sender.isOn{
            scheduleWorkTime = true
            cellText[1].append("New Cell")
            cellType[1].append("DaySelectorCell")
            
            cellText[1].append("Length")
            cellType[1].append("PickerCell")
            tableView.reloadData()
        }else{
            scheduleWorkTime = false
            cellText[1].removeAll()
            cellType[1].removeAll()
            cellText[1].append("Schedule Time to Work")
            cellType[1].append("SwitchCell")
            tableView.reloadData()
        }
    }
}

extension AddAssignmentViewController: DaySelectorDelegate{
    func dayButtonPressed(sender: UIButton) {
        let dayTitle = sender.titleLabel!.text!
        if sender.isSelected{
            sender.isSelected = false
            for day in workDaysSelected{
                if day == K.weekdayDict[dayTitle]{//if day is already selected, and we select it again
                    workDaysSelected.remove(at: workDaysSelected.firstIndex(of: day)!)
                }
            }
        }else{//day was not selected, and we are now selecting it.
            sender.isSelected = true
            workDaysSelected.append(K.weekdayDict[dayTitle]!)
        }
    }
}

