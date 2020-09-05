import Foundation
import UIKit
import RealmSwift

protocol AssignmentRefreshProtocol{
    func loadAssignments()
}

class AddAssignmentViewController: MasterForm, AlertInfoStorer{
    //holds the assignment being edited if an assignment is being edited.
    var assignment: Assignment?
    
    //a list of courses so that the user can pick which course the assignment is attached to
    var courses: Results<Course>? = nil
    
    //link to the main list of assignments, so it can refresh when we add a new one
    var delegate: AssignmentRefreshProtocol?
    
    //array variables that lay our form out into sections and rows
    var cellText: [[String]] = [["Name", "Due Date", "Remind Me"], ["Course"], ["Additional Details", ""]]
    var cellType: [[String]] = [["TextFieldCell", "TimeCell", "LabelCell"], ["PickerCell"], ["TextFieldCell", "LabelCell"]]
    
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
        tableView.tableFooterView = UIView()
        
        //getting all courses from realm to populate the course picker.
        courses = realm.objects(Course.self)
        
        if assignment != nil{
            fillForm(with: assignment!)
        }else{
            navButton.image = UIImage(systemName: "plus")
        }
    }
    
    //method that is triggered when the user wants to finalize the form
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        errors = ""
        retrieveData()
        if name == ""{
            errors.append(" Please specify a name.")
        }
        
        if errors == "" {
            if assignment == nil{
                print("adding assignment for the first time")
                let newAssignment = Assignment()
                newAssignment.initializeData(name: name, additionalDetails: additionalDetails, complete: false, startDate: dueDate - (60*60), endDate: dueDate, course: selectedCourse!, notificationAlertTimes: alertTimes)
                
                for alertTime in alertTimes{
                    let alertDate = dueDate - (Double(alertTime) * 60)
                    var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alertDate)
                    components.second = 0
                    
                    let identifier = UUID().uuidString
                    newAssignment.notificationIdentifiers.append(identifier)
                    scheduleNotification(components: components, body: "", titles: "\(name) due at \(dueDate.format(with: "h:mm a"))", repeatNotif: false, identifier: identifier)
                }
                save(assignment: newAssignment)
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
                        assignment!.initializeData(name: name, additionalDetails: additionalDetails, complete: false, startDate: dueDate - (60*60), endDate: dueDate, course: selectedCourse!)
                        
                    }
                }catch{
                    print("there was an error: \(error)")
                }
            }
            delegate?.loadAssignments()
            dismiss(animated: true, completion: nil)
        }else{
            cellText[2][1] = errors
            tableView.reloadData()
        }
    }
    
    //method called when user wants to cancel
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    //saves the new assignment to the realm
    func save(assignment: Assignment){
        do{ //adding the assignment to the courses list of assignments
            try realm.write{
                if let course = selectedCourse{
                    course.assignments.append(assignment)
                }else{
                    print("course is nil.")
                }
            }
        }catch{
            print("error appending assignment")
        }
    }
    
    //method that retrieves data from cells, instead of data updating whenever something is edited (this is more efficient)
    func retrieveData(){
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        name = nameCell.textField.text!
        
        let dueDateCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TimeCell
        dueDate = dueDateCell.date!
        
        let courseCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! PickerCell
        let selectedRow = courseCell.picker.selectedRow(inComponent: 0)
        selectedCourse = courses![selectedRow]
        
        let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! TextFieldCell
        additionalDetails = additionalDetailsCell.textField.text!
    }
    
    //set the course picker to whatever course was originally selected, if any
    func setDefaultRow(picker: UIPickerView){
        var row = 0
        if selectedCourse == nil{
            print("selectedCourse is nil. User probably initiated this form from the general add event form")
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
            setDefaultRow(picker: cell.picker)
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
            
            if indexPath.section == 2{
                cell.label.textColor = UIColor.red
            }else{
                cell.accessoryType = .disclosureIndicator
            }
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

//MARK: - TimerPicker DataSource Methods
extension AddAssignmentViewController: UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return courses?.count ?? 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

//MARK: - TimerPicker Delegate Methods
extension AddAssignmentViewController: UIPickerViewDelegate{
    //helps set up information in the UIPickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return courses![row].name
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellType[indexPath.section][indexPath.row] == "PickerCell" || cellType[indexPath.section][indexPath.row] == "TimePickerCell"{
            return 150
        }
        return 50
    }
}

//MARK: - Date/TimePicker Delegate Methods
extension AddAssignmentViewController: UITimePickerDelegate{
    
    //method that auto updates a corresponding TimeCell when a TimePicker is changed.
    func pickerValueChanged(sender: UIDatePicker, indexPath: IndexPath) {
        let correspondingTimeCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as! TimeCell
        correspondingTimeCell.date = sender.date
        correspondingTimeCell.timeLabel.text = sender.date.format(with: "MMM d, h:mm a")
    }
}

extension AddAssignmentViewController{
    func fillForm(with assignment: Assignment){
        
        navButton.image = .none
        navButton.title = "Done"
        
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        nameCell.textField.text = assignment.name
        
        let dueDateCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TimeCell
        dueDate = assignment.endDate
        dueDateCell.timeLabel.text = dueDate.format(with: "h:mm a")
        dueDateCell.date = dueDate
        
        alertTimes = []
        for alert in assignment.notificationAlertTimes{
            alertTimes.append(alert)
        }
        
        let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! TextFieldCell
        additionalDetailsCell.textField.text = assignment.additionalDetails
        
    }
}


