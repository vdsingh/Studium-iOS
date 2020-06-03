//
//  AddCourseViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

//import UIKit
//import RealmSwift
//import Colorful
//
//protocol CourseRefreshProtocol { //Used to refresh the course list after we have added a course.
//    func loadCourses()
//}
//
//class AddCourseViewController: UIViewController{
//
//    var delegate: CourseRefreshProtocol? //reference to the course list.
//    let realm = try! Realm() //Link to the realm where we are storing information
//
//    //MARK: - IBOutlets
//    @IBOutlet weak var addACourseText: UILabel!
//    @IBOutlet weak var courseNameText: UITextField!
//    @IBOutlet weak var locationText: UITextField!
//    @IBOutlet weak var addButton: UIButton!
//    @IBOutlet weak var additionalDetailsText: UITextField!
//    @IBOutlet weak var errorsLabel: UILabel!
//    @IBOutlet weak var startDayPicker: UIDatePicker!
//    @IBOutlet weak var endDayPicker: UIDatePicker!
//
//    @IBOutlet var colors: Array<UIButton>?
//    @IBOutlet var dayLabels: Array<UILabel>?
//    @IBOutlet var days: Array<UIButton>?
//
//
//    var errors: [String] = []
//    var selectedColor: UIColor?
//    var selectedDays = ["Sun": false,"Mon": false,"Tue": false,"Wed":false,"Thu": false,"Fri": false,"Sat": false]
//
//
//    @IBAction func DayButtonPressed(_ sender: UIButton) {
//        if(!sender.isSelected){ //user selected this day.
//            selectedDays[(sender.titleLabel?.text)!] = true
//            sender.isSelected = true
//        }else{
//            selectedDays[(sender.titleLabel?.text)!] = false
//            sender.isSelected = false
//        }
//    }
//
//
//    @IBAction func colorButtonPressed(_ sender: UIButton) {
//        selectedColor = sender.tintColor
//        if let colorArray = colors{
//            for color in colorArray{
//                color.setImage(UIImage(systemName: "square"), for: .normal)
//            }
//        }
//        changeBaseColor(with: sender.tintColor)
//        sender.setImage(UIImage(systemName: "square.fill"), for: .normal)
//    }
//    @IBAction func addButtonPressed(_ sender: UIButton) {
//        errors.removeAll()
//        errorsLabel.text = ""
//        if(courseNameText.text == ""){
//            errors.append("Enter a course name")
//        }
//
//        let courses = realm.objects(Course.self)
//        for course in courses{
//            if course.name == courseNameText.text {
//                errors.append("You already have a course with that name.");
//                break
//            }
//        }
//
//        if(selectedColor == nil){
//            errors.append("Please specify a color")
//        }
//        updateErrorText()
//        if(errors.count == 0){
//            let newCourse = Course()
//            newCourse.name = courseNameText.text! //specify course name
//            newCourse.color = selectedColor!.hexValue() //specify course color
//
//
//            newCourse.startTime = startDayPicker.date
//            newCourse.endTime = endDayPicker.date
//
//            for (day, dayBool) in selectedDays{ //specify course days
//                if dayBool == true {
//                    newCourse.days.append(day)
//                }
//            }
//            save(course: newCourse) //save course and attributes to database.
//            dismiss(animated: true) {
//                if let del = self.delegate{
//                    del.loadCourses()
//                }else{
//                    print("delegate was not defined.")
//                }
//            }
//        }
//    }
//
//    func save(course: Course){
//        do{
//            try realm.write{
//                realm.add(course)
//            }
//        }catch{
//            print(error)
//        }
//    }
//
//    func updateErrorText(){
//        var count = 0
//        for error in errors{
//            if count == 0{
//                errorsLabel.text?.append("\(error)")
//
//            }else{
//                errorsLabel.text?.append(", \(error)")
//            }
//            count += 1
//        }
//    }
//
//    func changeBaseColor(with color: UIColor){
//        let newColor = color.darken(byPercentage: 0.3)
//        if let daysArr = days{
//            for day in daysArr{
//                day.tintColor = newColor
//            }
//        }
//        if let dayLabelArr = dayLabels{
//            for dayLabel in dayLabelArr{
//                dayLabel.tintColor = newColor
//            }
//        }
//        setColorOfPlaceholderText(textField: courseNameText, color: newColor!)
//        setColorOfPlaceholderText(textField: locationText, color: newColor!)
//        setColorOfPlaceholderText(textField: additionalDetailsText, color: newColor!)
//        addACourseText.textColor = newColor
//        addButton.tintColor = newColor
//        startDayPicker.setValue(newColor, forKey: "textColor")
//        endDayPicker.setValue(newColor, forKey: "textColor")
//
//
//    }
//
//    func setColorOfPlaceholderText(textField: UITextField, color: UIColor){
//        let alphaColor = color.withAlphaComponent(0.5)
//        let darkenedColor = color.darken(byPercentage: 0.1)
//        if let placeholderText = textField.placeholder{
//            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: alphaColor])
//        }
//
//        textField.textColor = darkenedColor
//        textField.layer.masksToBounds = true
//        textField.layer.borderColor = alphaColor.cgColor
//        textField.layer.borderWidth = 1.0
//    }
//}

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

protocol CourseRefreshProtocol{
    func loadCourses()
}

class AddCourseViewController: UITableViewController{
    
    let realm = try! Realm()
    var delegate: CourseRefreshProtocol?
    
    var activePicker: String?
    var activeTextField: String?
    
    var cellText: [[String]] = [["Name", "Location", "Days"], ["Starts", "Ends"], ["Additional Details"], [""]]
    var cellType: [[String]] = [["TextFieldCell", "TextFieldCell", "DaySelectorCell"],  ["TimeCell", "TimeCell"], ["TextFieldCell"], ["LabelCell"]]
    
    var startTime: Date = Date()
    var endTime: Date = Date() + (60*60)
    
    var times: [Date] = []
    var timeCounter = 0
    
    var errors: String = ""
    
    var courseColor: String = "4287f5"
    var courseName: String = ""
    var additionalDetails: String = ""
    var location: String = ""
    var daysSelected: [String] = []
    
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
        tableView.register(UINib(nibName: "TimeCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
        tableView.register(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "PickerCell") //a cell that allows user to pick time (e.g. 2 hours, 4 mins)
        
        tableView.register(UINib(nibName: "TimePickerCell", bundle: nil), forCellReuseIdentifier: "TimePickerCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "DaySelectorCell", bundle: nil), forCellReuseIdentifier: "DaySelectorCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "LabelCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "SegmentedControlCell", bundle: nil), forCellReuseIdentifier: "SegmentedControlCell")
        
        
        times = [startTime, endTime]
        
        tableView.tableFooterView = UIView()
    }
    
@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        errors = ""
        if courseName == ""{
            errors.append(" Please specify a course name.")
        }
        
        if daysSelected == []{
            errors.append(" Please specify at least one day.")
        }
        
        if endTime < startTime{
            errors.append(" End time cannot occur before start time.")
        }
        
        if errors.count == 0{
            let newCourse = Course()
            newCourse.startTime = startTime
            newCourse.endTime = endTime
            newCourse.color = courseColor
            newCourse.name = courseName
            newCourse.location = location
            newCourse.additionalDetails = additionalDetails
            
            for day in daysSelected{
                newCourse.days.append(day)
            }
            
            save(course: newCourse)
            print(newCourse)
            dismiss(animated: true, completion: delegate?.loadCourses)
        }else{
            cellText[3][0] = errors
            reloadData()
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
    
    func save(course: Course){
        do{
            try realm.write{
                realm.add(course)
            }
        }catch{
            print(error)
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
    
}

//MARK: - TableView Delegate
extension AddCourseViewController{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellType[indexPath.section][indexPath.row] == "TextFieldCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.textField.placeholder = cellText[indexPath.section][indexPath.row]
            cell.delegate = self
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "TimeCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
                cell.timeLabel.text = times[timeCounter].format(with: "h:mm a")
                cell.label.text = cellText[indexPath.section][indexPath.row]
                timeCounter+=1
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

//MARK: - TimerPicker DataSource
extension AddCourseViewController: UIPickerViewDataSource{
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
extension AddCourseViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return "\(row) hours"
        }
        return "\(row) min"
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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
extension AddCourseViewController: UITimePickerDelegate{
    func pickerValueChanged(sender: UIDatePicker) {
        if activePicker == "Starts"{
            startTime = sender.date
        }else if activePicker == "Ends"{
            endTime = sender.date
        }
        reloadData()
        
    }
    
}

//MARK: - TextField Delegate
extension AddCourseViewController: UITextFieldDelegate{
    func textEdited(sender: UITextField) {
        print(sender.placeholder)
        if sender.placeholder == "Name"{
            courseName = sender.text!
        }else if sender.placeholder == "Location"{
            location = sender.text!
        }else if sender.placeholder == "Additional Details"{
            additionalDetails = sender.text!
        }
    }
}

extension AddCourseViewController: DaySelectorDelegate{
    func dayButtonPressed(sender: UIButton) {
        print("day button pressed.")
        let dayTitle = sender.titleLabel!.text
        if sender.isSelected{
            sender.isSelected = false
            for day in daysSelected{
                if day == dayTitle{
                    daysSelected.remove(at: daysSelected.firstIndex(of: day)!)
                }
            }
        }else{
            print("added day!")
            sender.isSelected = true
            daysSelected.append(dayTitle!)
            print(daysSelected)

        }
        
    }
}

