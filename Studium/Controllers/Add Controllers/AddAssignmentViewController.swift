import Foundation
import UIKit
import RealmSwift

protocol AssignmentRefreshProtocol{
    func loadAssignments()
}

class AddAssignmentViewController: UITableViewController{
    var editingAssignment: Bool = false
    var previousAssignment: Assignment?
    
    
    let realm = try! Realm()
    var courses: Results<Course>? = nil
    var delegate: AssignmentRefreshProtocol?
    
    var activePicker: String?
    var activeTextField: String?
    
    var cellText: [[String]] = [["Name", "Due Date"], ["Course"], ["Additional Details"], [""]]
    var cellType: [[String]] = [["TextFieldCell", "TimeCell"], ["PickerCell"], ["TextFieldCell"], ["LabelCell"]]
    
    var dueDate = Date()
    
    var times: [Date] = []
    var timeCounter = 0
    
    var errors: String = ""
    
    var selectedCourse: Course? = nil
    var assignmentName: String = ""
    var additionalDetails: String = ""
    
    override func viewDidLoad() {
        print(selectedCourse!.name)

        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
        tableView.register(UINib(nibName: "TimeCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
        tableView.register(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "PickerCell") //a cell that allows user to pick time (e.g. 2 hours, 4 mins)
        
        tableView.register(UINib(nibName: "TimePickerCell", bundle: nil), forCellReuseIdentifier: "TimePickerCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "DaySelectorCell", bundle: nil), forCellReuseIdentifier: "DaySelectorCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "LabelCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "SegmentedControlCell", bundle: nil), forCellReuseIdentifier: "SegmentedControlCell")
        
        
        tableView.tableFooterView = UIView()
        courses = realm.objects(Course.self)
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        errors = ""
        if assignmentName == ""{
            errors.append(" Please specify a name.")
        }
        
        if errors == "" {
            let newAssignment = Assignment()
            newAssignment.initializeData(name: assignmentName, additionalDetails: additionalDetails, complete: false, startDate: dueDate - (60*60), endDate: dueDate, assignmentID: K.assignmentNum)
            K.assignmentNum += 1
            if editingAssignment{
                newAssignment.complete = previousAssignment!.complete
            }
            save(assignment: newAssignment)
            if editingAssignment{
                do{
                    try realm.write{
                        realm.delete(previousAssignment!)
                    }
                }catch{
                    print("Error deleting previous assignment")
                }
            }
            delegate?.loadAssignments()
            dismiss(animated: true, completion: nil)
        }else{
            cellText[3][0] = errors
            reloadData()
        }
    }
    
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func reloadData(){
        tableView.reloadData()
    }
    
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
    
    func setDefaultRow(picker: UIPickerView){
        var row = 0
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
extension AddAssignmentViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellType.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellText[section].count
    }
    
}

//MARK: - TableView Delegate
extension AddAssignmentViewController{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell for row at was called.")
        if cellType[indexPath.section][indexPath.row] == "TextFieldCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.textField.placeholder = cellText[indexPath.section][indexPath.row]
            cell.delegate = self
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "TimeCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
            cell.timeLabel.text = dueDate.format(with: "MMM d, h:mm a")
            cell.label.text = cellText[indexPath.section][indexPath.row]
            timeCounter+=1
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "PickerCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as! PickerCell
            cell.picker.delegate = self
            cell.picker.dataSource = self
            setDefaultRow(picker: cell.picker)
            print("added a picker cell.")
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "TimePickerCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimePickerCell", for: indexPath) as! TimePickerCell
            cell.picker.datePickerMode = .dateAndTime
            cell.delegate = self
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "LabelCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
            cell.label.text = cellText[indexPath.section][indexPath.row]
            cell.label.textColor = UIColor.red
            //print("added a label cell")
            return cell
        }else{
            return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRowText = cellText[indexPath.section][indexPath.row]
        if cellType[indexPath.section][indexPath.row] == "TimeCell"{
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
                    print("picked the active picker")
                    //print(cellText[indexPath.row - 1])
                    tableView.endUpdates()
                    return
                }
            }
            
            let newIndex = cellText[indexPath.section].firstIndex(of: selectedRowText)! + 1
            
            tableView.insertRows(at: [IndexPath(row: newIndex, section: indexPath.section)], with: .left)
            cellType[indexPath.section].insert("TimePickerCell", at: newIndex)
            cellText[indexPath.section].insert("", at: newIndex)
            activePicker = cellText[indexPath.section][newIndex - 1]
            tableView.endUpdates()
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
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return courses![row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCourse = courses![row]
        reloadData()
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
    func pickerValueChanged(sender: UIDatePicker) {
        dueDate = sender.date
        reloadData()
        
    }
}

//MARK: - TextField Delegate Methods
extension AddAssignmentViewController: UITextFieldDelegate{
    func textEdited(sender: UITextField) {
        if sender.placeholder == "Name"{
            assignmentName = sender.text!
        }else if sender.placeholder == "Additional Details"{
            additionalDetails = sender.text!
        }
    }
}

 //MARK: - EditableForm Methods
extension AddAssignmentViewController: EditableForm{
    func loadData (from data: StudiumEvent){
        let assignment = data as! Assignment
        editingAssignment = true
        previousAssignment = assignment
        
        selectedCourse = assignment.parentCourse[0]
        assignmentName = assignment.name
        additionalDetails = assignment.additionalDetails
        dueDate = assignment.endDate
        selectedCourse = assignment.parentCourse[0]
        
        
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! TextFieldCell
        let dueDateCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TimeCell
        let courseCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! PickerCell
        
        nameCell.textField.text = assignmentName
        additionalDetailsCell.textField.text = additionalDetails
        dueDateCell.timeLabel?.text = dueDate.format(with: "MMM d, h:mm a")
        setDefaultRow(picker: courseCell.picker)
        
        self.navigationController?.title = "View Assignment"
        
    }
}


