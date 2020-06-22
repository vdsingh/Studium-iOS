

import Foundation
import UIKit
import RealmSwift
import FlexColorPicker

protocol CourseRefreshProtocol{
    func loadCourses()
}

class AddCourseViewController: UITableViewController{
    
    var previousCourse: Course?
    var editingCourse: Bool = false
    
    let realm = try! Realm()
    var delegate: CourseRefreshProtocol?
    
    var activePicker: String?
    var activeTextField: String?
    
    var cellText: [[String]] = [["Name", "Location", "Days"], ["Starts", "Ends"], ["Color Picker", "Additional Details"], ["Errors"]]
    var cellType: [[String]] = [["TextFieldCell", "TextFieldCell", "DaySelectorCell"],  ["TimeCell", "TimeCell"], ["ColorPickerCell", "TextFieldCell"], ["LabelCell"]]
    
    var startTime: Date = Date()
    var endTime: Date = Date() + (60*60)
    
    var times: [Date] = []
    var timeCounter = 0
    
    var errors: String = ""
    
    var courseName: String = ""
    var colorValue: String = "ffffff"
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
        tableView.register(UINib(nibName: "ColorPickerCell", bundle: nil), forCellReuseIdentifier: "ColorPickerCell")
        
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
            newCourse.color = colorValue
            newCourse.name = courseName
            newCourse.location = location
            newCourse.additionalDetails = additionalDetails
            
            for day in daysSelected{
                newCourse.days.append(day)
            }
            if editingCourse{
                do{
                    try realm.write{
                        realm.delete(previousCourse!)
                    }
                }catch{
                    print(error)
                }
            }
            save(course: newCourse)
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
            cell.textField.delegate = self
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
        }else if cellType[indexPath.section][indexPath.row] == "ColorPickerCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorPickerCell", for: indexPath) as! ColorPickerCell
            cell.delegate = self
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
        if cellType[indexPath.section][indexPath.row] == "PickerCell" || cellType[indexPath.section][indexPath.row] == "TimePickerCell" || cellType[indexPath.section][indexPath.row] == "ColorPickerCell"{
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
extension AddCourseViewController: UITextFieldDelegateExt{
    func textEdited(sender: UITextField) {
        //print(sender.placeholder)
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
            sender.isSelected = true
            daysSelected.append(dayTitle!)
        }
    }
}

extension AddCourseViewController: ColorDelegate{
    func colorPickerValueChanged(sender: RadialPaletteControl) {
        colorValue = sender.selectedColor.hexValue()
    }
}

extension AddCourseViewController: EditableForm{
    func loadData(from data: StudiumEvent) {
        
        editingCourse = true
        let course = data as! Course
        previousCourse = course
        let courseNameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        let courseLocationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TextFieldCell
        let daysCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! DaySelectorCell
        let startCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TimeCell
        let endCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! TimeCell
        let colorPickerCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! ColorPickerCell
        
        courseName = course.name
        location = course.location
        for day in course.days{
            daysSelected.append(day)
        }
        startTime = course.startTime
        endTime = course.endTime
        colorValue = course.color
        additionalDetails = course.additionalDetails
        
        courseNameCell.textField.text = courseName
        courseLocationCell.textField.text = location
        for button in daysCell.dayButtons{
            if daysSelected.contains(button.titleLabel!.text!){
                button.isSelected = true
            }
        }
        
        startCell.timeLabel.text = startTime.format(with: "h:mm a")
        endCell.timeLabel.text = startTime.format(with: "h:mm a")
        colorPickerCell.colorPicker.selectedColor = UIColor(hexString: colorValue)!
        colorPickerCell.colorPreview.backgroundColor = UIColor(hexString: colorValue)

    }
}

extension UIViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
