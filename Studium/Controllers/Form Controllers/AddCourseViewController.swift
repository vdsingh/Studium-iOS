

import Foundation
import UIKit
import RealmSwift
import FlexColorPicker

//makes sure that the course list can refresh when a new course is added
protocol CourseRefreshProtocol{
    func loadCourses()
}

class AddCourseViewController: MasterForm{
    
    //link to the list that is to be refreshed when a new course is added.
    var delegate: CourseRefreshProtocol?
    
    //arrays that structure the form (determine each type of cell and what goes in them for the most part)
    var cellText: [[String]] = [["Name", "Location", "Days"], ["Starts", "Ends"], ["Logo", "Color Picker", "Additional Details"], ["Errors"]]
    var cellType: [[String]] = [["TextFieldCell", "TextFieldCell", "DaySelectorCell"],  ["TimeCell", "TimeCell"], ["LogoCell", "ColorPickerCell", "TextFieldCell"], ["LabelCell"]]
    
    //start and end time for the course. The date doesn't actually matter because the days are selected elsewhere
    var startDate: Date = Date()
    var endDate: Date = Date() + (60*60)
    
    //variables that help determine what TimeCells display what times.
    var times: [Date] = []
    var timeCounter = 0
    var pickerCounter = 0
    
    //error string that is displayed when there are errors
    var errors: String = ""
    
    //basic course elements
    var name: String = ""
    var colorValue: String = "ffffff"
    var additionalDetails: String = ""
    var location: String = ""
    var daysSelected: [String] = []
    
    //called when the view loads
    override func viewDidLoad() {
        
        //register custom cells for form
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
        tableView.register(UINib(nibName: "TimeCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
        tableView.register(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "PickerCell") //a cell that allows user to pick time (e.g. 2 hours, 4 mins)
        
        tableView.register(UINib(nibName: "TimePickerCell", bundle: nil), forCellReuseIdentifier: "TimePickerCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "DaySelectorCell", bundle: nil), forCellReuseIdentifier: "DaySelectorCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "LabelCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        tableView.register(UINib(nibName: "SegmentedControlCell", bundle: nil), forCellReuseIdentifier: "SegmentedControlCell")
        tableView.register(UINib(nibName: "ColorPickerCell", bundle: nil), forCellReuseIdentifier: "ColorPickerCell")
        tableView.register(UINib(nibName: "LogoCell", bundle: nil), forCellReuseIdentifier: "LogoCell")
        
        
        //used to decipher which TimeCell should have which dates
        times = [startDate, endDate]
        
        //makes it so that there are no empty cells at the bottom
        tableView.tableFooterView = UIView()
    }
    
    //final step that occurs when the user has filled out the form and wants to add the new course
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        errors = ""
        
        
        retrieveData()
        endDate = Calendar.current.date(bySettingHour: endDate.hour, minute: endDate.minute, second: endDate.second, of: startDate)!
        if name == ""{
            errors.append(" Please specify a course name.")
        }
        
        if daysSelected == []{
            errors.append(" Please specify at least one day.")
        }
        
        if endDate.isEarlier(than: startDate){
            //            print("start date: \(startDate), end date: \(endDate)")
            errors.append(" End time cannot occur before start time.")
        }
        
        if errors.count == 0{
            let newCourse = Course()
            newCourse.initializeData(name: name, colorHex: colorValue, location: location, additionalDetails: additionalDetails, startDate: startDate, endDate: endDate, days: daysSelected)
            scheduleNotification(at: startDate - (60*60), body: "Don't be late!", titles: "\(name) at \(startDate.format(with: "h:mm a"))", repeatNotif: true)
            save(course: newCourse)
            dismiss(animated: true, completion: delegate?.loadCourses)
        }else{
            cellText[3][0] = errors
            reloadData()
        }
    }
    
    //handles when the user wants to cancel their form
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    //resets necessary data and reloads the tableView
    func reloadData(){
        times = [startDate, endDate]
        timeCounter = 0
        pickerCounter = 0
        tableView.reloadData()
    }
    
    //saves the new course to the Realm database.
    func save(course: Course){
        do{
            try realm.write{
                realm.add(course)
            }
        }catch{
            print(error)
        }
    }
    
    //MARK: - Retrieving Data
    
    //method that retrieves data from cells, instead of data updating whenever something is edited (this is more efficient)
    func retrieveData(){
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        name = nameCell.textField.text!
        
        let locationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TextFieldCell
        location = locationCell.textField.text!
        
        let daySelectorCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! DaySelectorCell
        daysSelected = daySelectorCell.daysSelected
        
        let startTimeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TimeCell
        startDate = startTimeCell.date
        
        let endTimeCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! TimeCell
        endDate = endTimeCell.date
        
        let colorPickerCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! ColorPickerCell
        colorValue = colorPickerCell.colorPicker.selectedColor.hexValue()
        
        let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as! TextFieldCell
        additionalDetails = additionalDetailsCell.textField.text!
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
    
    //constructs the form based on information mostly from the main arrays.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellType[indexPath.section][indexPath.row] == "TextFieldCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.textField.placeholder = cellText[indexPath.section][indexPath.row]
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "TimeCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
            cell.timeLabel.text = times[timeCounter].format(with: "h:mm a")
            cell.label.text = cellText[indexPath.section][indexPath.row]
            cell.date = times[timeCounter]
            timeCounter+=1
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "TimePickerCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimePickerCell", for: indexPath) as! TimePickerCell
            cell.delegate = self
            cell.indexPath = indexPath
            
            let dateString = cellText[indexPath.section][indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let date = dateFormatter.date(from: dateString)!
            
            cell.picker.date = date
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "DaySelectorCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DaySelectorCell", for: indexPath) as! DaySelectorCell
            //cell.delegate = self
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "LabelCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
            cell.label.text = cellText[indexPath.section][indexPath.row]
            cell.label.textColor = UIColor.red
            //print("added a label cell")
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "ColorPickerCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorPickerCell", for: indexPath) as! ColorPickerCell
            //cell.delegate = self
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "LogoCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogoCell", for: indexPath) as! LogoCell
            //cell.delegate = self
            return cell
        }else{
            return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
    }
}

//MARK: - TableView Delegate
extension AddCourseViewController{
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellType[indexPath.section][indexPath.row] == "PickerCell" || cellType[indexPath.section][indexPath.row] == "TimePickerCell" || cellType[indexPath.section][indexPath.row] == "ColorPickerCell"{
            return 150
        }
        if(cellType[indexPath.section][indexPath.row] == "LogoCell"){
            return 60
        }
        return 50
    }
    
    //mostly handles what occurs when the user selects a TimeCell, and pickers must be removed/added
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
                    tableView.endUpdates()
                    return
                }
            }
            
            let newIndex = cellText[indexPath.section].firstIndex(of: selectedRowText)! + 1
            tableView.insertRows(at: [IndexPath(row: newIndex, section: indexPath.section)], with: .left)
            
            cellType[indexPath.section].insert("TimePickerCell", at: newIndex)
            cellText[indexPath.section].insert("\(timeCell.date.format(with: "h:mm a"))", at: newIndex)
            
            tableView.endUpdates()
        }else if cellType[indexPath.section][indexPath.row] == "LogoCell"{
            performSegue(withIdentifier: "toLogoSelection", sender: self)
        }
    }
}

//MARK: - TimePicker Delegate
extension AddCourseViewController: UITimePickerDelegate{
    func pickerValueChanged(sender: UIDatePicker, indexPath: IndexPath) {
        //we are getting the timePicker's corresponding timeCell by accessing its indexPath and getting the element in the tableView right before it. This is always the timeCell it needs to update. The indexPath of the timePicker is stored in the cell's class upon creation, so that it can be passed to this function when needed.
        let correspondingTimeCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as! TimeCell
        correspondingTimeCell.date = sender.date
        correspondingTimeCell.timeLabel.text = correspondingTimeCell.date.format(with: "h:mm a")
    }
}


//makes the keyboard dismiss when user clicks done
extension UIViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
