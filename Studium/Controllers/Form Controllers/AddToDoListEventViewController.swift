//
//  AddToDoListEvent.swift
//  Studium
//
//  Created by Vikram Singh on 6/26/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift

protocol ToDoListRefreshProtocol{
    func refreshData()
}

class AddToDoListEventViewController: MasterForm, UITimePickerDelegate {
    
    //link to the list of OtherEvents, so that when a new ToDo Event is created, the list refreshes.
    var delegate: ToDoListRefreshProtocol?
    
    //Basic OtherEvent characteristics
    var name: String = ""
    var location: String = ""
    var additionalDetails: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    //Error string that tells the user what is wrong
    var errors: String = ""
    
    //Arrays that help construct the form. Describes which types of cells go where and what their contents are.
    var cellText: [[String]] = [["This Event is a Course Assignment"],["Name", "Location"], ["Start Date", "End Date"], ["Additional Details"], [""]]
    var cellType: [[String]] = [["LabelCell"],["TextFieldCell", "TextFieldCell"], ["TimeCell", "TimeCell"], ["TextFieldCell"], ["LabelCell"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //registering the necessary cells for the form
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
        tableView.register(UINib(nibName: "TimeCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
        tableView.register(UINib(nibName: "TimePickerCell", bundle: nil), forCellReuseIdentifier: "TimePickerCell")
        tableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "LabelCell")
        
        //makes it so that the form doesn't have a bunch of empty cells at the bottom
        tableView.tableFooterView = UIView()
    }
    
    //function that is called when the user wants to finish editing in the form and create the new object.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        errors = ""
        let newEvent = OtherEvent()
        
        //updates the characteristic variables
        retrieveDataFromCells()
        if name == ""{
            errors.append("Please specify a name.")
        }
        
        if endDate < startDate{
            errors.append(" End Date cannot be before Start Date")
        }
        
        //there are no errors
        if errors == ""{
            newEvent.initializeData(startDate: startDate, endDate: endDate, name: name, location: location, additionalDetails: additionalDetails)
            save(otherEvent: newEvent)
            delegate!.refreshData()
            dismiss(animated: true, completion: nil)
        }else{
            //update the errors cell to show all of the errors with the form
            cellText[4][0] = errors
            tableView.reloadData()
        }
    }
    
    //writing to Realm.
    func save(otherEvent: OtherEvent){
        do{
            try realm.write{
                realm.add(otherEvent)
            }
        }catch{
            print(error)
        }
    }
    
    //function that retrieves data from specific cells and updates characteristic variables
    func retrieveDataFromCells(){
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TextFieldCell
        name = nameCell.textField.text!
        
        let locationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! TextFieldCell
        location = locationCell.textField.text!
        
        let startTimeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! TimeCell
        startDate = startTimeCell.date!
        
        //finding the index for the endTimeCell is necessary because there could be other PickerCells in the section, meaning we don't know the exact location without looking.
        let endTimeCellIndex = cellType[2].lastIndex(of: "TimeCell")
        let endTimeCell = tableView.cellForRow(at: IndexPath(row: endTimeCellIndex!, section: 2)) as! TimeCell
        endDate = endTimeCell.date!
        
        let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! TextFieldCell
        additionalDetails = additionalDetailsCell.textField.text!
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return cellType.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellType[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellType[indexPath.section][indexPath.row] == "TimePickerCell"{
            return 150
        }
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellType[indexPath.section][indexPath.row] == "TextFieldCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.textField.placeholder = cellText[indexPath.section][indexPath.row]
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "TimeCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
            cell.timeLabel.text = Date().format(with: "h:mm a")
            cell.label.text = cellText[indexPath.section][indexPath.row]
            //timeCounter+=1
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "TimePickerCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimePickerCell", for: indexPath) as! TimePickerCell
            cell.picker.datePickerMode = .dateAndTime
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
        }else if cellType[indexPath.section][indexPath.row] == "LabelCell"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
            cell.label.text = cellText[indexPath.section][indexPath.row]
            cell.label.textAlignment = .center
            cell.label.textColor = .blue
            if indexPath.section == 4{
                cell.label.textColor = .red
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    //handles opening and closing picker cells as well as if the user selected the assignment option
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let del = delegate as! ToDoListViewController
            self.dismiss(animated: true) {
                del.openAssignmentForm()
            }
        }
        
        //handles timeCells trigger timePickerCells.
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
                    tableView.endUpdates()
                    return
                }
            }
            
            let newIndex = cellText[indexPath.section].firstIndex(of: selectedRowText)! + 1
            
            tableView.insertRows(at: [IndexPath(row: newIndex, section: indexPath.section)], with: .left)
            cellType[indexPath.section].insert("TimePickerCell", at: newIndex)
            cellText[indexPath.section].insert("", at: newIndex)
            tableView.endUpdates()
        }
    }
    
    func pickerValueChanged(sender: UIDatePicker, indexPath: IndexPath) {
        //we are getting the timePicker's corresponding timeCell by accessing its indexPath and getting the element in the tableView right before it. This is always the timeCell it needs to update. The indexPath of the timePicker is stored in the cell's class upon creation, so that it can be passed to this function when needed.
        let correspondingTimeCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as! TimeCell
        correspondingTimeCell.date = sender.date
        correspondingTimeCell.timeLabel.text = correspondingTimeCell.date!.format(with: "MMM d, h:mm a")
        
    }
}
