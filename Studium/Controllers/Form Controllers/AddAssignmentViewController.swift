import Foundation
import UIKit
import RealmSwift

protocol AssignmentRefreshProtocol{
    func loadAssignments()
}

class AddAssignmentViewController: MasterForm{
    var codeLocationString: String = "Add Assignment Form"
    
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
//    var cellText: [[String]] = [["Name", "Due Date", "Remind Me"], ["Schedule Time to Work"], ["Course"], ["Additional Details", ""]]
//    var cellType: [[FormCell]] =
    
    //errors string that is displayed if there are any issues (e.g: user didnt enter a name)
    var errors: String = ""
    
    //basic assignment variables
    var selectedCourse: Course? = nil
    var name: String = ""
    var additionalDetails: String = ""
    
    
    @IBOutlet weak var navButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        self.cells = [
            [
                .textFieldCell(placeholderText: "Name", id: FormCellID.TextFieldCell.nameTextField, textFieldDelegate: self, delegate: self),
                .timeCell(cellText: "Due Date", date: self.endDate, dateFormat: "MMM d, h:mm a", id: .endTimeCell, onClick: self.timeCellClicked),
                .labelCell(cellText: "Remind Me", cellAccessoryType: .disclosureIndicator, onClick: self.navigateToAlertTimes)
            ],
            [
                .switchCell(cellText: "Schedule Time to Work", switchDelegate: self, infoDelegate: self)
            ],
            [
                .pickerCell(cellText: "Course", tag: FormCellID.PickerCell.coursePickerCell, delegate: self, dataSource: self)
            ],
            [
                .textFieldCell(placeholderText: "Additional Details", id: FormCellID.TextFieldCell.additionalDetailsTextField, textFieldDelegate: self, delegate: self),
                .labelCell(cellText: "", textColor: .systemRed)
            ]
        ]
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        tableView.backgroundColor = .systemBackground
        
        //getting all courses from realm to populate the course picker.
        guard let user = app.currentUser else {
            print("$ ERROR: error getting user in MasterForm")
            return
        }
        realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
        courses = realm.objects(Course.self)
        
        // TODO: Fix force unwrap
        self.endDate = Calendar.current.date(bySetting: .hour, value: 23, of: self.endDate)!
        self.endDate = Calendar.current.date(bySetting: .minute, value: 59, of: self.endDate)!
        
        if assignment != nil {
            alertTimes = [];
            for alert in assignment!.notificationAlertTimes{
                alertTimes.append(alert)
            }
            
            for day in assignment!.days{
                workDaysSelected.append(day)
            }
            guard let course = assignment!.parentCourse else{
                print("$ ERROR: error accessing parent course in AssignmentCell1")
                return
            }
            fillForm(name: assignment!.name, additionalDetails: assignment!.additionalDetails, alertTimes: alertTimes, dueDate: assignment!.endDate, selectedCourse: course, scheduleWorkTime: assignment!.autoschedule, workTimeMinutes: assignment!.autoLengthMinutes, workDays: workDaysSelected)
        } else if fromTodoForm {
            //THIS IS BROKEN PLEASE FIX. ASSIGNMENT IS NIL, SO THERE IS NO PARENT COURSE. FIX LATER
            fillForm(name: todoFormData[0], additionalDetails: todoFormData[1], alertTimes: todoAlertTimes, dueDate: todoDueDate, selectedCourse: nil, scheduleWorkTime: false, workTimeMinutes: 0, workDays: [])
        } else {
            //we are creating a new assignment.
            
            //get the user's default notification times if they exist and fill them in!
            if UserDefaults.standard.object(forKey: K.defaultNotificationTimesKey) != nil {
                print("$ LOG: Loading User's Default Notification Times for Assignment Form.")
                alertTimes = UserDefaults.standard.value(forKey: K.defaultNotificationTimesKey) as! [Int]
            }
            navButton.image = UIImage(systemName: "plus")
        }
    }
    
    //method that is triggered when the user wants to finalize the form
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        errors = ""
        if name == "" {
            errors.append(" Please specify a name.")
        }
        
        if errors == "" {
            if assignment == nil {
                print("$ LOG: adding assignment for the first time")
                guard let user = app.currentUser else {
                    print("$ ERROR: error getting user")
                    return
                }

                let newAssignment = Assignment()
                newAssignment.initializeData(name: name, additionalDetails: additionalDetails, complete: false, startDate: self.endDate - (60*60), endDate: self.endDate, notificationAlertTimes: alertTimes, autoschedule: scheduleWorkTime, autoLengthMinutes: workTimeMinutes + (workTimeHours * 60), autoDays: workDaysSelected, partitionKey: user.id)
                
                NotificationHandler.scheduleNotificationsForAssignment(assignment: newAssignment)
                RealmCRUD.saveAssignment(assignment: newAssignment, parentCourse: selectedCourse!)
            }else{
                // TODO: Implement assignment notification updates here
                
            }
            delegate?.loadAssignments()
            dismiss(animated: true, completion: nil)
        } else {
            self.replaceLabelText(text: errors, section: 3, row: 1)
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
        guard let selectedCourse = self.selectedCourse else {
            return
        }

        if let coursesArr = courses {
            for course in coursesArr {
                if course.name == selectedCourse.name {
                    picker.selectRow(row, inComponent: 0, animated: true)
                    break
                }
                row += 1
            }
        }else{
            print("$ ERROR: courses in AddAssignment is nil. ")
        }
    }
    
    func fillForm(name: String,
                  additionalDetails: String,
                  alertTimes: [Int],
                  dueDate: Date,
                  selectedCourse: Course?,
                  scheduleWorkTime: Bool,
                  workTimeMinutes: Int,
                  workDays: [Int]) {
        navButton.image = .none
        navButton.title = "Done"
        
        print("attempting to fillForm with \(scheduleWorkTime)")
        
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        nameCell.textField.text = name
        self.name = name
        
        print("Name Cell Text: \(name)")
        
        let dueDateCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TimeCell
        self.endDate = endDate
        dueDateCell.date = dueDate
        
        self.alertTimes = alertTimes
        
        self.scheduleWorkTime = scheduleWorkTime
        if scheduleWorkTime == true{
            
            let scheduleWorkCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! SwitchCell
            scheduleWorkCell.tableSwitch.isOn = true
            
            let daysCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! DaySelectorCell
            daysCell.selectDays(days: workDays)
            self.workDaysSelected = workDays
            
            self.workTimeHours = workTimeMinutes / 60
            self.workTimeMinutes = workTimeMinutes % 60
            
            let workTimePickerCell = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as! PickerCell
            workTimePickerCell.picker.selectRow(workTimeHours, inComponent: 0, animated: true)
            workTimePickerCell.picker.selectRow(workTimeMinutes, inComponent: 1, animated: true)
        }
        
        if (selectedCourse != nil){
            self.selectedCourse = selectedCourse
        }
        
        let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! TextFieldCell
        additionalDetailsCell.textField.text = additionalDetails
        self.additionalDetails = additionalDetails
    }
}

extension AddAssignmentViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AlertTableViewController {
            destinationVC.delegate = self
        }
    }
}

 //MARK: - Cell DataSource and Delegates
extension AddAssignmentViewController: UITextFieldDelegateExt{

    //TODO: Implement IDs here
    func textEdited(sender: UITextField, textFieldID: FormCellID.TextFieldCell) {
        guard let text = sender.text else {
            print("$ ERROR: sender's text was nil. File: \(#file), Function: \(#function), Line: \(#line)")
            return
        }
        switch textFieldID {
        case .nameTextField:
            self.name = text
        case .additionalDetailsTextField:
            self.additionalDetails = text
        default:
            print("$ ERROR: edited text for non-existent field. File: \(#file), Function: \(#function), Line: \(#line)")
            break
        }
    }
}

//MARK: - TimerPicker DataSource Methods
extension AddAssignmentViewController: UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == FormCellID.PickerCell.coursePickerCell.rawValue{
            return courses?.count ?? 1
        } else if pickerView.tag == FormCellID.PickerCell.lengthPickerCell.rawValue {
            if component == 0{
                return 24
            }
            return 60
        }
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == FormCellID.PickerCell.coursePickerCell.rawValue {
            return 1
        }else if pickerView.tag == FormCellID.PickerCell.lengthPickerCell.rawValue {
            return 2
        }
        return 0
    }
}

//MARK: - Picker Delegate Methods
extension AddAssignmentViewController: UIPickerViewDelegate{
    //helps set up information in the UIPickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == FormCellID.PickerCell.coursePickerCell.rawValue {
            return courses![row].name
        } else if pickerView.tag == FormCellID.PickerCell.lengthPickerCell.rawValue {
            if component == 0{
                return "\(row) hours"
            }
            return "\(row) min"
        }
        return "Unknown Picker"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView.tag == FormCellID.PickerCell.coursePickerCell.rawValue {
            // Course selection
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            selectedCourse = courses![selectedRow]
        } else if pickerView.tag == FormCellID.PickerCell.coursePickerCell.rawValue {
            if component == 0 {
                workTimeHours = row
            } else {
                workTimeMinutes = row
            }
        }
    }
}

extension AddAssignmentViewController: CanHandleSwitch{
    func switchValueChanged(sender: UISwitch) {
        print("$ LOG: Switch value changed")
        // TODO: Use tableview updates so these actions are animated.
        if sender.isOn{
            scheduleWorkTime = true
            cells[1].append(.daySelectorCell(delegate: self))
            cells[1].append(.pickerCell(cellText: "Length", tag: FormCellID.PickerCell.lengthPickerCell, delegate: self, dataSource: self))
            tableView.reloadData()
        }else{
            scheduleWorkTime = false
            cells[1].removeAll()
            cells[1].append(.switchCell(cellText: "Schedule Time to Work", switchDelegate: self, infoDelegate: self))
            tableView.reloadData()
        }
    }
}

extension AddAssignmentViewController: CanHandleInfoDisplay{
    func displayInformation() {
        let alert = UIAlertController(title: "Anti-Procrastination!",
                                      message: "Need to schedule time to work on this? Specify what days are best and how long you want to work per day. We'll find time for you to get it done!",
                                      preferredStyle: UIAlertController.Style.alert)
//        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//            self.deleteAllOtherEvents(isCompleted: isCompleted)
//          }))
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
          }))
        present(alert, animated: true, completion: nil)

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
