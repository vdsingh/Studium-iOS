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

protocol HabitRefreshProtocol{
    func loadHabits()
}

class AddHabitViewController: UITableViewController, CanHandleSwitch{
    
    
    var totalLengthHours = 1
    var totalLengthMinutes = 0
    
    let realm = try! Realm()
    var delegate: HabitRefreshProtocol?
    
    var activePicker: String?
    var activeTextField: String?
    
    var cellTextNoAuto: [[String]] = [["Name", "Location"], ["Autoschedule", "Start Time", "Finish Time"], ["Additional Details", "Days", ""]]
    var cellTypeNoAuto: [[String]] = [["TextFieldCell", "TextFieldCell"],  ["SwitchCell", "TimeCell", "TimeCell"], ["TextFieldCell", "DaySelectorCell", "LabelCell"]]
    
    var cellTextAuto: [[String]] = [["Name", "Location"], ["Autoschedule", "Between", "And", "Length of Habit", ""],["Additional Details", "Days", ""]]
    var cellTypeAuto: [[String]] = [["TextFieldCell", "TextFieldCell"],  ["SwitchCell", "TimeCell", "TimeCell", "TimeCell", "SegmentedControlCell"],["TextFieldCell", "DaySelectorCell", "LabelCell"]]
    
    var cellText: [[String]] = [[]]
    var cellType: [[String]] = [[]]
    
    
    var startTime: Date = Date()
    var endTime: Date = Date() + (60*60)
    
    var times: [Date] = []
    var timeCounter = 0
    
    var errors:[String] = []
    var errorLabel: LabelCell?
    
    
    var autoschedule = false
    var habitName: String = ""
    var additionalDetails: String = ""
    var location: String = ""
    var earlier = true
    var daysSelected: [String] = []
    
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
        tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        tableView.register(UINib(nibName: "TimeCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
        tableView.register(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "PickerCell") //a cell that allows user to pick time (e.g. 2 hours, 4 mins)
        
        tableView.register(UINib(nibName: "TimePickerCell", bundle: nil), forCellReuseIdentifier: "TimePickerCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "DaySelectorCell", bundle: nil), forCellReuseIdentifier: "DaySelectorCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "LabelCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "SegmentedControlCell", bundle: nil), forCellReuseIdentifier: "SegmentedControlCell") 
        
        
        times = [startTime, endTime]
        
        cellText = cellTextNoAuto
        cellType = cellTypeNoAuto
        
        tableView.tableFooterView = UIView()
    }
    
    func switchValueChanged(sender: UISwitch) {
        
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
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        errors = []
        cellText[2][cellText[2].count - 1] = ""
            //reloadData()
        print("habit name: \(habitName)")
        
        if habitName == ""{
            errors.append("Please specify a name. ")
        }
        
        //var daySelected = false
        if daysSelected == []{
            errors.append("Please select at least one day. ")
        }
        if autoschedule && totalLengthHours == 0 && totalLengthMinutes == 0{
            errors.append("Please specify total time. ")
        }
        if errors.count == 0{
            let newHabit = Habit()
            newHabit.name = habitName
            newHabit.location = location
            newHabit.additionalDetails = additionalDetails
            newHabit.autoSchedule = autoschedule
            newHabit.startEarlier = earlier
            print(startTime)
            newHabit.startTime = startTime
            newHabit.endTime = endTime
            
            if newHabit.autoSchedule{
                newHabit.totalHourTime = totalLengthHours
                newHabit.totalMinuteTime = totalLengthMinutes
            }
            
            for day in daysSelected{
                newHabit.days.append(day)
            }
            
            print("\(newHabit.days) \(newHabit.name)")
            save(habit: newHabit)
            delegate?.loadHabits()
            
            dismiss(animated: true) {
                if let del = self.delegate{
                    del.loadHabits()
                }else{
                    print("delegate was not defined.")
                }
            }
        }else{
            
            var errorStr = ""
            for error in errors{
                errorStr.append(contentsOf: error)
            }
            cellText[2][cellText.count - 1].append(errorStr)
            reloadData()
            print(cellType)
            errorLabel!.label.textColor = .red
            errorLabel!.label.text = cellText[2].last
            
            var addedFirstError = false
            //errorLabel.text?.append(errors[0])
            for error in errors{
                if addedFirstError{
                    errorLabel!.label.text!.append(", \(error)")
                }
                addedFirstError = true
            }
        }
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func reloadData(){
        times = [startTime, endTime]
        timeCounter = 0
        tableView.reloadData()
    }
    
    func save(habit: Habit){
        do{
            try realm.write{
                realm.add(habit)
            }
        }catch{
            print(error)
        }
    }
}

//MARK: - TableView DataSource
extension AddHabitViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellType.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellText[section].count
    }
    
}

//MARK: - TableView Delegate
extension AddHabitViewController{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellType[indexPath.section][indexPath.row] == "TextFieldCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.textField.placeholder = cellText[indexPath.section][indexPath.row]
            cell.delegate = self
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
                cell.label.text = cellText[indexPath.section][indexPath.row]
                timeCounter+=1
            }
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "PickerCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as! PickerCell
            cell.picker.delegate = self
            cell.picker.dataSource = self
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "TimePickerCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimePickerCell", for: indexPath) as! TimePickerCell
            cell.delegate = self
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "DaySelectorCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DaySelectorCell", for: indexPath) as! DaySelectorCell
            cell.delegate = self
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
            activePicker = cellText[indexPath.section][newIndex - 1]
            if selectedRowText == "Length of Habit"{
                cellText[indexPath.section].insert("", at: newIndex)
                cellType[indexPath.section].insert("PickerCell", at: newIndex)
            }else{
                cellText[indexPath.section].insert("", at: newIndex)
                cellType[indexPath.section].insert("TimePickerCell", at: newIndex)
            }
            tableView.endUpdates()
        }
    }
}

//MARK: - TimerPicker DataSource
extension AddHabitViewController: UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return 24
            
        }
        return 60
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
}

//MARK: - TimerPickerDelegate
extension AddHabitViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return "\(row) hours"
        }
        return "\(row) min"
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            totalLengthHours = row
        }else{
            totalLengthMinutes = row
        }
        reloadData()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellType[indexPath.section][indexPath.row] == "PickerCell" || cellType[indexPath.section][indexPath.row] == "TimePickerCell"{
            return 150
        }
        return 50
    }
}

//MARK: - Date/TimePicker Delegate
extension AddHabitViewController: UITimePickerDelegate{
    func pickerValueChanged(sender: UIDatePicker) {
        if activePicker == "Start Time" || activePicker == "Between"{
            startTime = sender.date
        }
        
        if activePicker == "Finish Time" || activePicker == "And"{
            
            endTime = sender.date
        }
        reloadData()
        
    }
    
}

//MARK: - TextField Delegate
extension AddHabitViewController: UITextFieldDelegate{
    func textEdited(sender: UITextField) {
        print(sender.placeholder)
        if sender.placeholder == "Name"{
            habitName = sender.text!
        }else if sender.placeholder == "Location"{
            location = sender.text!
        }else if sender.placeholder == "Additional Details"{
            additionalDetails = sender.text!
        }
    }
}

extension AddHabitViewController: DaySelectorDelegate{
    func dayButtonPressed(sender: UIButton) {
        let dayTitle = sender.titleLabel!.text
        if sender.isSelected{
            sender.isSelected = false
            for day in daysSelected{
                if day == dayTitle{
                    daysSelected.remove(at: daysSelected.firstIndex(of: day)!)
                }
            }
        }else{
            sender.isSelected = true
            daysSelected.append(dayTitle!)
        }
        
    }
    
    
}

extension AddHabitViewController: SegmentedControlDelegate{
    func controlValueChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{//earlier
            earlier = true
        }else{
            earlier = false
        }
    }
}