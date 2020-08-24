//
//  AddHabitViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/27/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

//guarantees that the Habit list has a method that allows it to refresh.
protocol HabitRefreshProtocol{
    func loadHabits()
}

//Class used to manage the form for adding a Habit. The form is a tableView form, similar to adding an event in
class AddHabitViewController: MasterForm, LogoStorer, AlertInfoStorer{
    
    var habit: Habit?
    
    //variable that helps run things once that only need to run at the beginning
    var resetAll: Bool = true
    
    //variables that hold the total length of the habit.
    var totalLengthHours = 1
    var totalLengthMinutes = 0
    
    //reference to the Habits list, so that once complete, it can update and show the new Habit
    var delegate: HabitRefreshProtocol?
    
    //Since this form is dynamic, there are different cells for whether or not the user chooses to schedule this Habit automatically. If the Habit is not automatic, this is how the form cells are laid out.
    var cellTextNoAuto: [[String]] = [["Name", "Location", "Days", "Remind Me"], ["Autoschedule", "Start Time", "Finish Time"], ["Logo", "Color Picker", "Additional Details", ""]]
    var cellTypeNoAuto: [[String]] = [["TextFieldCell", "TextFieldCell", "DaySelectorCell", "LabelCell"],  ["SwitchCell", "TimeCell", "TimeCell"], ["LogoCell", "ColorPickerCell" , "TextFieldCell", "LabelCell"]]
    
    //if the form is automatic, the cells are laid out this way.
    var cellTextAuto: [[String]] = [["Name", "Location", "Days", "Remind Me"], ["Autoschedule", "Between", "And", "Length of Habit", ""],["Logo", "Color Picker", "Additional Details", ""]]
    var cellTypeAuto: [[String]] = [["TextFieldCell", "TextFieldCell", "DaySelectorCell", "LabelCell"],  ["SwitchCell", "TimeCell", "TimeCell", "TimeCell", "SegmentedControlCell"],["LogoCell","ColorPickerCell", "TextFieldCell", "LabelCell"]]
    
    //These are the holders for the cellText and cellType. Basically these hold the above arrays and are used depending on whether the user chooses to use autoschedule or not.
    var cellText: [[String]] = [[]]
    var cellType: [[String]] = [[]]
    
    //startDate and endDate for the habit. if the Habit is autoschedule, this is the time frame it will be scheduled between. Also, this is just a time during the day. Since habits repeat, the days that the time occur on are specified elsewhere.
    var startDate: Date = Date()
    var endDate: Date = Date() + (60*60)
    
    
    var times: [Date] = []
    var timeCounter = 0
    
    //The errors array is populated when the user forgets to fill out a required part of the form or for any other error. if it is populated when the user tries to complete the process, it will prevent the user from moving forward
    var errors:[String] = []
    var errorLabel: LabelCell?
    
    //Basic elements of a habit. These qualities are used whenever the Habit is created.
    var autoschedule = false
    var name: String = ""
    var additionalDetails: String = ""
    var systemImageString: String = "book.fill"
    var colorValue: String = "000000"
    var location: String = ""
    var earlier = true
    var daysSelected: [String] = []
    
    //array that keeps track of when the user should be sent notifications about this habit
    var alertTimes: [Int] = []
    
    @IBOutlet weak var navButton: UIBarButtonItem!
    override func viewDidLoad() {
        //register the cells that are to be used in the form.
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
        tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        tableView.register(UINib(nibName: "TimeCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
        tableView.register(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "PickerCell") //a cell that allows user to pick time (e.g. 2 hours, 4 mins)
        
        tableView.register(UINib(nibName: "TimePickerCell", bundle: nil), forCellReuseIdentifier: "TimePickerCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "DaySelectorCell", bundle: nil), forCellReuseIdentifier: "DaySelectorCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "LabelCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "SegmentedControlCell", bundle: nil), forCellReuseIdentifier: "SegmentedControlCell")
        tableView.register(UINib(nibName: "LogoCell", bundle: nil), forCellReuseIdentifier: "LogoCell")
        tableView.register(UINib(nibName: "ColorPickerCell", bundle: nil), forCellReuseIdentifier: "ColorPickerCell")
        
        
        
        //used to decipher which TimeCell should have which dates
        times = [startDate, endDate]
        
        
        //by default, the form type is Habit isn't automatically scheduled
        cellText = cellTextNoAuto
        cellType = cellTypeNoAuto
        
        //makes it so that the form doesn't have a bunch of empty cells at the bottom
        tableView.tableFooterView = UIView()
        
        navButton.image = UIImage(systemName: "plus")
        if habit != nil{
            if habit!.autoSchedule{
                cellText = cellTextAuto
                cellType = cellTypeAuto
                tableView.reloadData()
            }
            fillForm(with: habit!)
        }
    }
    
    func refreshLogoCell() {
        let logoCellRow = cellType[2].firstIndex(of: "LogoCell")!
        let logoCell = tableView.cellForRow(at: IndexPath(row: logoCellRow, section: 2)) as! LogoCell
        logoCell.setImage(systemImageName: systemImageString)
    }
    
    //MARK: - UIElement IBActions
    
    
    
    //final step that occurs when the user finishes the form and adds the habit
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        resetAll = false
        errors = []
        cellText[2][cellText[2].count - 1] = ""
        retrieveData()
        endDate = Calendar.current.date(bySettingHour: endDate.hour, minute: endDate.minute, second: endDate.second, of: startDate)!
        reloadData()
        
        
        if name == ""{
            errors.append("Please specify a name. ")
        }
        
        if daysSelected == []{
            errors.append("Please select at least one day. ")
        }
        if autoschedule && totalLengthHours == 0 && totalLengthMinutes == 0{
            errors.append("Please specify total time. ")
        }else if endDate < startDate{
            errors.append("The first time bound must be before the second time bound")
        }else if autoschedule && (endDate.hour - startDate.hour) * 60 + (endDate.minute - startDate.minute) < totalLengthHours * 60 + totalLengthMinutes{
            errors.append("The total time exceeds the time frame. ")
        }
        
        if errors.count == 0{ //if there are no errors.
            if habit == nil{
                let newHabit = Habit()
                newHabit.initializeData(name: name, location: location, additionalDetails: additionalDetails, startDate: startDate, endDate: endDate, autoSchedule: autoschedule, startEarlier: earlier, totalHourTime: totalLengthHours, totalMinuteTime: totalLengthMinutes, daysSelected: daysSelected, systemImageString: systemImageString, colorHex: colorValue)
                
                for alertTime in alertTimes{
                    for day in daysSelected{
                        
                        let weekday = Date.convertDayToWeekday(day: day)
                        let weekdayAsInt = Date.convertDayToInt(day: day)
                        var alertDate = Date()
                        
                        if startDate.weekday != weekdayAsInt{ //the course doesn't occur today
                            alertDate = Date.today().next(weekday)
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
                        let timeFormat = startDate.format(with: "H:MM a")
                        
                        let identifier = UUID().uuidString
                        newHabit.notificationIdentifiers.append(identifier)
                        scheduleNotification(components: courseComponents, body: "Be there by \(timeFormat). Don't be late!", titles: title, repeatNotif: true, identifier: identifier)
                    }
                }
                save(habit: newHabit)

            }else{
                do{
                    try realm.write{
                        habit!.initializeData(name: name, location: location, additionalDetails: additionalDetails, startDate: startDate, endDate: endDate, autoSchedule: autoschedule, startEarlier: earlier, totalHourTime: totalLengthHours, totalMinuteTime: totalLengthMinutes, daysSelected: daysSelected, systemImageString: systemImageString, colorHex: colorValue)
                    }
                }catch{
                    print(error)
                }
            }
            
            
            delegate?.loadHabits()
            //            print(newHabit.days)
            dismiss(animated: true) {
                if let del = self.delegate{
                    del.loadHabits()
                }else{
                    print("delegate was not defined.")
                }
            }
        }else{ //if there are errors.
            var errorStr = ""
            for error in errors{
                errorStr.append(contentsOf: error)
            }
            cellText[2][cellText[2].count - 1].append(errorStr)
            reloadData()
            errorLabel!.label.textColor = .red
            errorLabel!.label.text = cellText[2].last
            
            var addedFirstError = false
            for error in errors{
                if addedFirstError{
                    errorLabel!.label.text!.append(", \(error)")
                }
                addedFirstError = true
            }
        }
    }
    
    //Handles whenever the user decides to cancel.
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    //MARK: - Retrieving data
    
    func retrieveData(){
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: false)

        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        name = nameCell.textField.text!
        
        let locationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TextFieldCell
        location = locationCell.textField.text!
        
        
        
        let daysCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! DaySelectorCell
        daysSelected = daysCell.daysSelected
        
        tableView.scrollToRow(at: IndexPath(row: 1, section: 2), at: .bottom, animated: true)

        
        //since there may or may not be pickers active, we don't know the exact position of the TimeCells that we want. As a result, we can use the first index of "TimeCell" in section 1, because this will always hold the start date.
        let indexOfStartCell = cellType[1].firstIndex(of: "TimeCell")
        let startDateCell = tableView.cellForRow(at: IndexPath(row: indexOfStartCell!, section: 1)) as! TimeCell
        startDate = startDateCell.date!
        
        //since there are 3 TimeCells if autoscheduling, and the end date is in the middle of them, we create a copy of section 1 and remove the startDateCell. Now the endDateCell is always the first TimeCell in the temporary array.
        var tempArray = cellType[1].map { $0 }
        tempArray.remove(at: indexOfStartCell!)
        let indexOfEndCell = tempArray.firstIndex(of: "TimeCell")! + 1
        let endDateCell = tableView.cellForRow(at: IndexPath(row: indexOfEndCell, section: 1)) as! TimeCell
        endDate = endDateCell.date!
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .middle, animated: false)
        let colorPickerCell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as! ColorPickerCell
        colorValue = colorPickerCell.colorPicker.selectedColor.hexValue()
        
        let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 2, section: 2)) as! TextFieldCell
        additionalDetails = additionalDetailsCell.textField.text!
        
        if autoschedule{
            
            //here we are getting the total length of the habit, which is only needed if the habit is to be autoscheduled
            
            //since there can be pickers active, we use lastIndex because it is always the correct TimeCell.
            let indexOfLengthCell = cellType[1].lastIndex(of: "TimeCell")
            let lengthOfHabitCell = tableView.cellForRow(at: IndexPath(row: indexOfLengthCell!, section: 1)) as! TimeCell
            
            //in order to get the numbers we want from the TimeCell, we split the string from the label in 2. we then pick out the numbers from that string.
            totalLengthHours = lengthOfHabitCell.timeLabel.text!.substring(toIndex: 3).parseToInt()!
            totalLengthMinutes = lengthOfHabitCell.timeLabel.text!.substring(fromIndex: 4).parseToInt()!
            
            //when the user chooses to autoschedule their Habit, they must choose whether to schedule it earlier or later in the time frame. 
            let earlierLaterCell = tableView.cellForRow(at: IndexPath(row: cellType[1].count - 1, section: 1)) as! SegmentedControlCell
            if earlierLaterCell.segmentedControl.selectedSegmentIndex == 0{
                earlier = true
            }else{
                earlier = false
            }
        }
    }
    
    //MARK: - Dealing with Realm stuff
    
    //save the Habit to the realm
    func save(habit: Habit){
        do{
            try realm.write{
                realm.add(habit)
            }
        }catch{
            print(error)
        }
    }
    
    //MARK: - tableView helpers
    
    //reset data and reloads tableView
    func reloadData(){
        times = [startDate, endDate]
        timeCounter = 0
        tableView.reloadData()
    }
}
//MARK: - tableView Data Source
extension AddHabitViewController{
    
    //returns the number of sections in the tableView.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellType.count
    }
    
    //returns the number of rows in a given section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellText[section].count
    }
    
    //this method is used to specify what goes into each cell. Uses the main arrays to figure this out.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellType[indexPath.section][indexPath.row] == "TextFieldCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.textField.placeholder = cellText[indexPath.section][indexPath.row]
            cell.textField.delegate = self
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "SwitchCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.delegate = self
            cell.label.text = cellText[indexPath.section][indexPath.row]
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "TimeCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
            if cellText[indexPath.section][indexPath.row] == "Length of Habit"{
                cell.timeLabel.text = "\(totalLengthHours) hours \(totalLengthMinutes) mins"
                cell.label.text = cellText[indexPath.section][indexPath.row]
            }else{
                cell.timeLabel.text = times[timeCounter].format(with: "h:mm a")
                cell.date = times[timeCounter]
                cell.label.text = cellText[indexPath.section][indexPath.row]
                timeCounter+=1
            }
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "PickerCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as! PickerCell
            cell.picker.delegate = self
            cell.picker.dataSource = self
            if resetAll{
                cell.picker.selectRow(1, inComponent: 0, animated: true)
            }
            cell.indexPath = indexPath
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "TimePickerCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimePickerCell", for: indexPath) as! TimePickerCell
            if resetAll{
                let dateString = cellText[indexPath.section][indexPath.row]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                let date = dateFormatter.date(from: dateString)!
                cell.picker.date = date
            }
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "DaySelectorCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DaySelectorCell", for: indexPath) as! DaySelectorCell
            //cell.delegate = self
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "LabelCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
            cell.label.text = cellText[indexPath.section][indexPath.row]
            errorLabel = cell
            //print("added a label cell")
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "SegmentedControlCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentedControlCell", for: indexPath) as! SegmentedControlCell
            cell.segmentedControl.setTitle("Earlier", forSegmentAt: 0)
            cell.segmentedControl.setTitle("Later", forSegmentAt: 1)
            //print("added a label cell")
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "LogoCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogoCell", for: indexPath) as! LogoCell
            //cell.delegate = self
            cell.setImage(systemImageName: systemImageString)
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "ColorPickerCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorPickerCell", for: indexPath) as! ColorPickerCell
            return cell
        }else{
            return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
    }
}

//MARK: - tableView Delegate
extension AddHabitViewController{
    
    //determines the height for the space above a section
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    //determines the height of each row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellType[indexPath.section][indexPath.row] == "PickerCell" || cellType[indexPath.section][indexPath.row] == "TimePickerCell" || cellType[indexPath.section][indexPath.row] == "ColorPickerCell"{
            return 150
        }
        return 50
    }
    
    //handles what happens when the user selects a row. The majority of this function is to handle the event when a user selects a TimeCell. The app must create a TimePickerCell beneath it.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)

        let selectedRowText = cellText[indexPath.section][indexPath.row]
        if cellType[indexPath.section][indexPath.row] == "TimeCell"{
            let timeCell = tableView.cellForRow(at: indexPath) as! TimeCell
            //this section handles the event when a TimePicker or Picker is already active and must be removed before continuing.
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
                    tableView.endUpdates()
                    return
                }
            }
            
            //this section handles creating the new Picker or TimePicker, altering the arrays, and putting the cell in the correct position.
            let newIndex = cellText[indexPath.section].firstIndex(of: selectedRowText)! + 1
            tableView.insertRows(at: [IndexPath(row: newIndex, section: indexPath.section)], with: .left)
            //activePicker = cellText[indexPath.section][newIndex - 1]
            if selectedRowText == "Length of Habit"{
                cellText[indexPath.section].insert("", at: newIndex)
                cellType[indexPath.section].insert("PickerCell", at: newIndex)
            }else{
                cellText[indexPath.section].insert("\(timeCell.date!.format(with: "h:mm a"))", at: newIndex)
                cellType[indexPath.section].insert("TimePickerCell", at: newIndex)
            }
            tableView.endUpdates()
        }else if cellType[indexPath.section][indexPath.row] == "LogoCell"{
            performSegue(withIdentifier: "toLogoSelection", sender: self)
        }else if cellText[indexPath.section][indexPath.row] == "Remind Me"{ //user selected "Remind Me"
            performSegue(withIdentifier: "toAlertSelection", sender: self)
        }
        
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? LogoSelectorViewController {
            destinationVC.delegate = self
            //                let colorCell = tableView.cellForRow(at: IndexPath(row: cellType[2].firstIndex(of: "ColorPickerCell")!, section: 2)) as! ColorPickerCell
            //                destinationVC.color = colorCell.colorPreview.backgroundColor
            let colorCell = tableView.cellForRow(at: IndexPath(row: cellType[2].firstIndex(of: "ColorPickerCell")!, section: 2)) as! ColorPickerCell
            destinationVC.color = colorCell.colorPreview.backgroundColor
        }else if let destinationVC = segue.destination as? AlertTableViewController{
            destinationVC.delegate = self
        }
    }
}

//MARK: - Picker DataSource
extension AddHabitViewController: UIPickerViewDataSource{
    
    //how many rows in the picker view, given the component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{ //hours
            return 24
        }
        //minutes
        return 60
    }
    
    //number of components in the pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
}

//MARK: - Picker Delegate
extension AddHabitViewController: UIPickerViewDelegate{
    
    //determines the text in each row, given the row and component
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return "\(row) hours"
        }
        return "\(row) min"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let lengthIndex = cellText[1].lastIndex(of: "Length of Habit")
        let timeCell = tableView.cellForRow(at: IndexPath(row: lengthIndex!, section: 1)) as! TimeCell
        
        timeCell.timeLabel.text = "\(row) hours \(component) mins"
    }
}

//MARK: - TimePicker Delegate
extension AddHabitViewController: UITimePickerDelegate{
    
    //handles whenever the user changes the value of the TimePicker
    func pickerValueChanged(sender: UIDatePicker, indexPath: IndexPath) {
        //we are getting the timePicker's corresponding timeCell by accessing its indexPath and getting the element in the tableView right before it. This is always the timeCell it needs to update. The indexPath of the timePicker is stored in the cell's class upon creation, so that it can be passed to this function when needed.
        let correspondingTimeCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as! TimeCell
        correspondingTimeCell.date = sender.date
        correspondingTimeCell.timeLabel.text = correspondingTimeCell.date!.format(with: "h:mm a")
    }
}

//MARK: - Switch Delegate
extension AddHabitViewController: CanHandleSwitch{
    //method triggered when the autoschedule switch is triggered
    func switchValueChanged(sender: UISwitch) {
//        retrieveData()
        if sender.isOn{//auto schedule
            cellText = cellTextAuto
            cellType = cellTypeAuto
            autoschedule = true
        }else{
            cellText = cellTextNoAuto
            cellType = cellTypeNoAuto
            autoschedule = false
        }
        reloadData()
    }
}

extension AddHabitViewController{
    func fillForm(with habit: Habit){
        print("fillForm called")
        reloadData()
        
        navButton.image = .none
        navButton.title = "Done"
        
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        nameCell.textField.text = habit.name
        
        let locationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TextFieldCell
        locationCell.textField.text = habit.location
        
        let daysCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! DaySelectorCell
        daysCell.selectDays(days: habit.days)
        
        alertTimes = []
        for alert in habit.notificationAlertTimes{
            alertTimes.append(alert)
        }
        
        let logoCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! LogoCell
        logoCell.logoImageView.image = UIImage(systemName: habit.systemImageString)
        systemImageString = habit.systemImageString
        
        let colorCell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as! ColorPickerCell
        colorCell.colorPreview.backgroundColor = UIColor(hexString: habit.color)!
        
        let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 2, section: 2)) as! TextFieldCell
        additionalDetailsCell.textField.text = habit.additionalDetails
        
        let startCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! TimeCell
        startDate = habit.startDate
        startCell.timeLabel.text = startDate.format(with: "h:mm a")
        startCell.date = startDate
        
        let endCell = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as! TimeCell
        endDate = habit.endDate
        endCell.timeLabel.text = endDate.format(with: "h:mm a")
        endCell.date = endDate
        
        if habit.autoSchedule{
            let autoscheduleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! SwitchCell
            autoscheduleCell.tableSwitch.isOn = true
            
            let lengthCell = tableView.cellForRow(at: IndexPath(row: 3, section: 1)) as! TimeCell
            totalLengthHours = habit.totalHourTime
            totalLengthMinutes = habit.totalMinuteTime
            lengthCell.timeLabel.text = "\(totalLengthHours) hours \(totalLengthMinutes) mins"
            //            startCell.date = startDate
            
            let earlierLaterCell = tableView.cellForRow(at: IndexPath(row: 4, section: 1)) as! SegmentedControlCell
            earlier = habit.startEarlier
            earlierLaterCell.setSelected(earlier, animated: true)
        }
    }
}

//allows us to parse Strings for ints.
extension String{
    func parseToInt() -> Int? {
        return Int(self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}
