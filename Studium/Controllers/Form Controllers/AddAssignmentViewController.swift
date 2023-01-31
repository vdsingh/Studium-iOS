import Foundation
import UIKit
import RealmSwift


protocol AssignmentRefreshProtocol {
    func loadAssignments()
}

class AddAssignmentViewController: MasterForm {
    var codeLocationString: String = "Add Assignment Form"
    
    /// Holds the assignment being edited (if an assignment is being edited)
    var assignmentEditing: Assignment?
    
    /// Whether the user came from the TodoEvent form. This is so that we can fill already existing data from that form (can't use edit feature because that requires an existing assignment)
    var fromTodoForm: Bool = false;
    
    /// String field data from todo form. [name, data]
    var todoFormData: [String] = ["", ""]
    //alert times data from todo form.
    //    var todoAlertTimes: [Int] = []
    var todoDueDate: Date = Date()
    
    //variables that hold the total length of the habit.
    
    
    var scheduleWorkTime: Bool = false
    
    
    var workDaysSelected: [Int] = []
    //    var workTimeHours = 1
    //    var workTimeMinutes = 0
    
    
    /// a list of courses so that the user can pick which course the assignment is attached to
    var courses: [Course] = []
    
    /// link to the main list of assignments, so it can refresh when we add a new one
    var delegate: AssignmentRefreshProtocol?
    
    /// Errors string that is displayed if there are any issues (e.g: user didnt enter a name)
    var errors: [FormError] = []
    
    /// The course that the user selected for this assignment
    var selectedCourse: Course? = nil
    
    /// The name of the assignment
    var name: String = ""
    
    /// Additional Details associated with the assignment
    var additionalDetails: String = ""
    
    
    @IBOutlet weak var navButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        self.cells = [
            [
                .textFieldCell(placeholderText: "Name", id: FormCellID.TextFieldCell.nameTextField, textFieldDelegate: self, delegate: self),
                .timeCell(cellText: "Due Date", date: self.endDate, dateFormat: .fullDateWithTime, timePickerMode: .dateAndTime, id: .endTimeCell, onClick: self.timeCellClicked),
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
        
        courses = DatabaseService.shared.getStudiumObjects(expecting: Course.self)
        
        // TODO: Fix force unwrap
        self.endDate = Calendar.current.date(bySetting: .hour, value: 23, of: self.endDate)!
        self.endDate = Calendar.current.date(bySetting: .minute, value: 59, of: self.endDate)!
        
        if let assignment = assignmentEditing {
            
            for day in assignment.days {
                workDaysSelected.append(day)
            }
            
            guard let course = assignment.parentCourse else{
                print("$Error: error accessing parent course")
                return
            }
            
            fillForm (
                assignment: assignment
            )
        } else if fromTodoForm {
            //TODO: THIS IS BROKEN PLEASE FIX. ASSIGNMENT IS NIL, SO THERE IS NO PARENT COURSE. FIX LATER
            //            fillForm (
            //                name: todoFormData[0],
            //                additionalDetails: todoFormData[1],
            //                alertTimes: self.alertTimes,
            //                dueDate: todoDueDate,
            //                selectedCourse: nil,
            //                scheduleWorkTime: false,
            //                workTimeMinutes: 0,
            //                workDays: []
            //            )
        } else {
            //we are creating a new assignment.
            
            //get the user's default notification times if they exist and fill them in!
            //            if UserDefaults.standard.object(forKey: K.defaultNotificationTimesKey) != nil {
            //                print("$ LOG: Loading User's Default Notification Times for Assignment Form.")
            //                alertTimes = UserDefaults.standard.value(forKey: K.defaultNotificationTimesKey) as! [Int]
            //            }
            navButton.image = UIImage(systemName: "plus")
        }
    }
    
    //method that is triggered when the user wants to finalize the form
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        errors = []
        if name.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            errors.append(.nameNotSpecified)
        }
        
        if errors.isEmpty {
            if assignmentEditing == nil {
                print("$Log: adding assignment for the first time")
                
                let newAssignment = Assignment(
                    name: name,
                    additionalDetails: additionalDetails,
                    complete: false,
                    startDate: self.endDate - (60 * 60),
                    endDate: self.endDate,
                    notificationAlertTimes: self.alertTimes,
                    autoschedule: self.scheduleWorkTime,
                    autoLengthMinutes: self.totalLengthMinutes + (self.totalLengthHours * 60),
                    autoDays: self.workDaysSelected,
                    partitionKey: DatabaseService.shared.user?.id ?? ""
                )
                //TODO: Notifications
                //                NotificationHandler.scheduleNotificationsForAssignment(assignment: newAssignment)
                RealmCRUD.saveAssignment(assignment: newAssignment, parentCourse: selectedCourse!)
            } else {
                // TODO: Implement assignment notification updates here
                
            }
            delegate?.loadAssignments()
            dismiss(animated: true, completion: nil)
        } else {
            let errorsString: String = self.errors
                .compactMap({ $0.rawValue })
                .joined(separator: ". ")
            self.replaceLabelText(text: errorsString, section: 3, row: 1)
            tableView.reloadData()
        }
    }
    
    /// Called when user clicks the cancel button
    /// - Parameter sender: Button that the user clicked to cancel
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    /// set the course picker to whatever course was originally selected, if any
    func setDefaultRow(picker: UIPickerView){
        var row = 0
        guard let selectedCourse = self.selectedCourse else {
            return
        }
        
        for course in courses {
            if course.name == selectedCourse.name {
                picker.selectRow(row, inComponent: 0, animated: true)
                break
            }
            row += 1
        }
    }
    
    /// Fills the form with information from an Assignment
    /// - Parameter assignment: the Assignment whose data we are filling the form with
    func fillForm(
        assignment: Assignment
    ) {
        navButton.image = .none
        navButton.title = "Done"
        
        print("$Log: attempting to fillForm with \(assignment)")
        
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        nameCell.textField.text = assignment.name
        self.name = assignment.name
        
        
        let dueDateCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TimeCell
        self.endDate = assignment.endDate
        dueDateCell.setDate(assignment.endDate)
        
        self.alertTimes = assignment.alertTimes
        
        self.scheduleWorkTime = assignment.autoschedule
        if self.scheduleWorkTime {
            
            let scheduleWorkCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! SwitchCell
            scheduleWorkCell.tableSwitch.isOn = true
            
            let daysCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! DaySelectorCell
            daysCell.selectDays(days: [Int](assignment.days))
            self.workDaysSelected = [Int](assignment.days)
            
            self.totalLengthHours = self.totalLengthMinutes / 60
            self.totalLengthMinutes = self.totalLengthMinutes % 60
            
            let workTimePickerCell = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as! PickerCell
            workTimePickerCell.picker.selectRow(self.totalLengthHours, inComponent: 0, animated: true)
            workTimePickerCell.picker.selectRow(self.totalLengthMinutes, inComponent: 1, animated: true)
        }
        
        if (selectedCourse != nil) {
            self.selectedCourse = assignment.parentCourse
        }
        
        let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! TextFieldCell
        additionalDetailsCell.textField.text = assignment.additionalDetails
        self.additionalDetails = assignment.additionalDetails
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
extension AddAssignmentViewController: UITextFieldDelegateExt {
    
    //TODO: Implement IDs here
    func textEdited(sender: UITextField, textFieldID: FormCellID.TextFieldCell) {
        guard let text = sender.text else {
            print("$Error: sender's text was nil. File: \(#file), Function: \(#function), Line: \(#line)")
            return
        }
        
        switch textFieldID {
        case .nameTextField:
            self.name = text
        case .additionalDetailsTextField:
            self.additionalDetails = text
        default:
            print("$Error: edited text for non-existent field. File: \(#file), Function: \(#function), Line: \(#line)")
            break
        }
    }
}

//MARK: - TimerPicker DataSource Methods
//extension AddAssignmentViewController: UIPickerViewDataSource{
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView.tag == FormCellID.PickerCell.coursePickerCell.rawValue{
//            return courses?.count ?? 1
//        } else if pickerView.tag == FormCellID.PickerCell.lengthPickerCell.rawValue {
//            if component == 0{
//                return 24
//            }
//            return 60
//        }
//        return 0
//    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        if pickerView.tag == FormCellID.PickerCell.coursePickerCell.rawValue {
//            return 1
//        }else if pickerView.tag == FormCellID.PickerCell.lengthPickerCell.rawValue {
//            return 2
//        }
//        return 0
//    }
//}

//MARK: - Picker Delegate Methods
extension AddAssignmentViewController {
    //helps set up information in the UIPickerView
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        if pickerView.tag == FormCellID.PickerCell.coursePickerCell.rawValue {
    //            return courses![row].name
    //        } else if pickerView.tag == FormCellID.PickerCell.lengthPickerCell.rawValue {
    //            if component == 0{
    //                return "\(row) hours"
    //            }
    //            return "\(row) min"
    //        }
    //        return "Unknown Picker"
    //    }
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        switch pickerView.tag {
        case FormCellID.PickerCell.coursePickerCell.rawValue:
            self.selectedCourse = StudiumState.state.getCourses()[pickerView.selectedRow(inComponent: component)]
        default:
            break
        }
        
        //        if pickerView.tag == FormCellID.PickerCell.coursePickerCell.rawValue {
        //            // Course selection
        //            let selectedRow = pickerView.selectedRow(inComponent: 0)
        //            selectedCourse = courses![selectedRow]
        //        } else if pickerView.tag == FormCellID.PickerCell.coursePickerCell.rawValue {
        //            if component == 0 {
        //                workTimeHours = row
        //            } else {
        //                workTimeMinutes = row
        //            }
        //        }
    }
}

extension AddAssignmentViewController: CanHandleSwitch{
    func switchValueChanged(sender: UISwitch) {
        print("$Log: Switch value changed")
        // TODO: Use tableview updates so these actions are animated.
        if sender.isOn {
            scheduleWorkTime = true
            cells[1].append(.daySelectorCell(delegate: self))
            cells[1].append(.pickerCell(cellText: "Length", tag: FormCellID.PickerCell.lengthPickerCell, delegate: self, dataSource: self))
            tableView.reloadData()
        } else {
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
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension AddAssignmentViewController: DaySelectorDelegate {
    func dayButtonPressed(sender: UIButton) {
        let dayTitle = sender.titleLabel!.text!
        if sender.isSelected {
            sender.isSelected = false
            for day in workDaysSelected {
                if day == K.weekdayDict[dayTitle] {
                    workDaysSelected.remove(at: workDaysSelected.firstIndex(of: day)!)
                }
            }
        } else {
            sender.isSelected = true
            workDaysSelected.append(K.weekdayDict[dayTitle]!)
        }
    }
}
