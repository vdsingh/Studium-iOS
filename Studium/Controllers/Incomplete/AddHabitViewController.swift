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
    var autoschedule = false
    
    var delegate: HabitRefreshProtocol?
    
    var activePicker: String?
    
    //var pickerActive = false
    var cellTextNoAuto: [[String]] = [["Name", "Location"], ["Autoschedule", "Start Time", "Finish Time"], ["Additional Details"]]
    var cellTypeNoAuto: [[String]] = [["TextFieldCell", "TextFieldCell"],  ["SwitchCell", "TimeCell", "TimeCell"], ["TextFieldCell"]]
    var cellTextAuto: [[String]] = [["Name", "Location"], ["Autoschedule", "Between", "And", "Length of Habit"],["Additional Details"]]
    var cellTypeAuto: [[String]] = [["TextFieldCell", "TextFieldCell"],  ["SwitchCell", "TimeCell", "TimeCell", "TimeCell"],["TextFieldCell"]]
    
    var cellText: [[String]] = [[]]
    var cellType: [[String]] = [[]]
    
    
    var startTime: Date = Date()
    var endTime: Date = Date() + (60*60)
    
    var times: [Date] = []
    var timeCounter = 0
        
    
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
        tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        tableView.register(UINib(nibName: "TimeCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
        tableView.register(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "PickerCell") //a cell that allows user to pick time (e.g. 2 hours, 4 mins)
        
        tableView.register(UINib(nibName: "TimePickerCell", bundle: nil), forCellReuseIdentifier: "TimePickerCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        
        times = [startTime, endTime]
        
        cellText = cellTextNoAuto
        cellType = cellTypeNoAuto
        
        tableView.tableFooterView = UIView()
        
    }
    
    
    
    func switchValueChanged(sender: UISwitch) {
        //handle the value of switch changing.
        //pickerActive = false //all pickers are collapsed.
        
        if sender.isOn{//auto schedule
            cellText = cellTextAuto
            cellType = cellTypeAuto
        }else{
            cellText = cellTextNoAuto
            cellType = cellTypeNoAuto
        }
        reloadData()
    }
    
    func reloadData(){
        times = [startTime, endTime]
        timeCounter = 0
        tableView.reloadData()
    }
}

//MARK: - TableView DataSource
extension AddHabitViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        print("num sections: \(cellType.count)")
        return cellType.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("num rows in section \(section): \(cellText[section].count)")
        return cellText[section].count
    }
    
}

//MARK: - TableView Delegate
extension AddHabitViewController{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellType[indexPath.section][indexPath.row] == "TextFieldCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.textField.placeholder = cellText[indexPath.section][indexPath.row]
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
        }else{
            return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
    }
    
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        CGFloat.leastNormalMagnitude
//    }
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
//                cellText.append("")
//                cellType.append("")
                cellText[indexPath.section].insert("", at: newIndex)
                cellType[indexPath.section].insert("TimePickerCell", at: newIndex)
            }
            tableView.endUpdates()
        }
    }
}

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

extension AddHabitViewController: UITimePickerDelegate{
    func pickerValueChanged(sender: UIDatePicker) {
        print("picker value changed. The active picker is: \(activePicker)")
        if activePicker == "Start Time" || activePicker == "Between"{
            startTime = sender.date
        }
        
        if activePicker == "Finish Time" || activePicker == "And"{
            endTime = sender.date
        }
        reloadData()
//        if let picker = activePicker{
//            let indexOfPicker = cellText.firstIndex(of: picker)
//            let infoCell = tableView.cellForRow(at: indexOfPicker) as! TimeCell
//        }
    }
    
    
}
//
//protocol HabitRefreshProtocol{
//    func loadHabits()
//}
//
//class AddHabitViewController: UIViewController{
//    let realm = try! Realm()
//    var delegate: HabitRefreshProtocol?
//    var selectedDays = ["Sun": false,"Mon": false,"Tue": false,"Wed":false,"Thu": false,"Fri": false,"sat": false]
//    var errors: [String] = []
//    var earlier: Bool = true
//    var autoSchedule: Bool = false
//
//    @IBOutlet weak var habitNameTextField: UITextField!
//    @IBOutlet weak var locationTextField: UITextField!
//    @IBOutlet weak var additionalDetailsTextField: UITextField!
//
//    @IBOutlet weak var fromLabel: UILabel!
//    @IBOutlet weak var toLabel: UILabel!
//
//
//    @IBOutlet weak var timePickerStack: UIStackView!
//    @IBOutlet weak var startFinishButton: UIButton!
//    @IBOutlet weak var startTimePicker: UIDatePicker!
//    @IBOutlet weak var finishTimePicker: UIDatePicker!
//
//    @IBOutlet weak var earlierLaterLabel: UISegmentedControl!
//    @IBOutlet weak var totalTimeForHabitButton: UIButton!
//    @IBOutlet weak var errorLabel: UILabel!
//
//    @IBAction func dateButtonSelected(_ sender: UIButton) {
//        if(!sender.isSelected){ //user selected this day.
//            selectedDays[(sender.titleLabel?.text)!] = true
//            sender.isSelected = true
//        }else{
//            selectedDays[(sender.titleLabel?.text)!] = false
//            sender.isSelected = false
//        }
//    }
//    @IBAction func earlierLaterChanged(_ sender: UISegmentedControl) {
//        if(sender.selectedSegmentIndex == 0){//earlier
//            earlier = true
//        }else{
//            earlier = false
//        }
//    }
//    @IBAction func autoScheduleChanged(_ sender: UISwitch) {
//        if sender.isOn{ //schedule during free time
//            setAutoScheduleUI()
//            autoSchedule = true
//        }else{
//            setManualUI()
//            autoSchedule = false
//        }
//    }
//
//    @IBAction func addButtonPressed(_ sender: UIButton) {
//        errors = []
//        errorLabel.text = " "
//        if habitNameTextField.text == ""{
//            errors.append("Please specify a name")
//        }
//
//        var daySelected = false
//        for (_, dayBool) in selectedDays{
//            if dayBool == true{
//                daySelected = true
//                break
//            }
//        }
//
//        if daySelected == false{
//            errors.append("Please specify at least one day")
//        }
//
//        if errors.count == 0{
//            let newHabit = Habit()
//            newHabit.name = habitNameTextField.text!
//            newHabit.location = locationTextField.text!
//            newHabit.additionalDetails = additionalDetailsTextField.text!
//
//            newHabit.autoSchedule = autoSchedule
//            newHabit.startEarlier = earlier
//
//            newHabit.startTime = startTimePicker.date
//            newHabit.endTime = finishTimePicker.date
//
//            for (day, dayBool) in selectedDays{ //specify course days
//                if dayBool == true {
//                    newHabit.days.append(day)
//                }
//            }
//            save(habit: newHabit)
//            delegate?.loadHabits()
//
//            dismiss(animated: true) {
//                if let del = self.delegate{
//                    del.loadHabits()
//                }else{
//                    print("delegate was not defined.")
//                }
//            }
//        }else{
//            var addedFirstError = false
//            errorLabel.text?.append(errors[0])
//            for error in errors{
//                if addedFirstError{
//                    errorLabel.text?.append(", \(error)")
//                }
//                addedFirstError = true
//            }
//        }
//    }
//
//    @IBAction func setStartAndFinishPressed(_ sender: UIButton) {
//        if timePickerStack.isHidden == true{
//            timePickerStack.isHidden = false
//        }else{
//            timePickerStack.isHidden = true
//        }
//    }
//    func save(habit: Habit){
//        do{
//            try realm.write{
//                realm.add(habit)
//            }
//        }catch{
//            print(error)
//        }
//    }
//
//    func setAutoScheduleUI(){
//        startFinishButton.titleLabel?.text = "Set Bounds for When to Schedule"
//        totalTimeForHabitButton.isHidden = false
//        fromLabel.text = "Try to fit between:"
//        toLabel.text = "and:"
//        earlierLaterLabel.isHidden = false
//    }
//
//    func setManualUI(){
//        startFinishButton.titleLabel?.text = "Set Start and Finish Time"
//        totalTimeForHabitButton.isHidden = true
//        fromLabel.text = "Start:"
//        toLabel.text = "Finish:"
//        earlierLaterLabel.isHidden = true
//    }
//}


//if indexPath.row + 1 < cellType.count{
//    if cellText[indexPath.row] == "Length of Habit"{
//        cellType.insert("PickerCell", at: indexPath.row + 1)
//        cellText.insert("", at: indexPath.row + 1)
//    }else{
//        cellType.insert("TimePickerCell", at: indexPath.row + 1)
//        cellText.insert("", at: indexPath.row + 1)
//    }
//}else{
//    print(indexPath.row)
//    print(cellText)
//    if cellText[indexPath.row - 1] == "Length of Habit"{
//        cellType.append("PickerCell")
//        cellText.append("")
//
//    }else{
//        cellType.append("TimePickerCell")
//        cellText.append("")
//    }
//}
