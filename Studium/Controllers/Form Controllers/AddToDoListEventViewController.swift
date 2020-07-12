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

class AddToDoListEventViewController: MasterForm, UITextFieldDelegateExt, UITimePickerDelegate {
    
    var delegate: ToDoListRefreshProtocol?
    
    var name: String = ""
    var location: String = ""
    var additionalDetails: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    func pickerValueChanged(sender: UIDatePicker, indexPath: IndexPath) {
        //we are getting the timePicker's corresponding timeCell by accessing its indexPath and getting the element in the tableView right before it. This is always the timeCell it needs to update. The indexPath of the timePicker is stored in the cell's class upon creation, so that it can be passed to this function when needed.
        let correspondingTimeCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as! TimeCell
        correspondingTimeCell.date = sender.date
        correspondingTimeCell.timeLabel.text = correspondingTimeCell.date.format(with: "MMM d, h:mm a")
        
    }
    var activePicker: String?
    
    func textEdited(sender: UITextField) {
        
    }
    
    
    var cellText: [[String]] = [["Name", "Location"], ["Start Date", "End Date"], ["Additional Details"]]
    var cellType: [[String]] = [["TextFieldCell", "TextFieldCell"], ["TimeCell", "TimeCell"], ["TextFieldCell"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
        tableView.register(UINib(nibName: "TimeCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
        tableView.register(UINib(nibName: "TimePickerCell", bundle: nil), forCellReuseIdentifier: "TimePickerCell") //a cell that allows user to pick day time (e.g. 5:30 PM)
        
        
        //makes it so that the form doesn't have a bunch of empty cells at the bottom
        tableView.tableFooterView = UIView()
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let newEvent = OtherEvent()
        retrieveDataFromCells()
        newEvent.initializeData(startDate: startDate, endDate: endDate, name: name, location: location, additionalDetails: additionalDetails)
        save(otherEvent: newEvent)
        delegate!.refreshData()
        dismiss(animated: true, completion: nil)
    }
    
    func save(otherEvent: OtherEvent){
        do{
            try realm.write{
                realm.add(otherEvent)
            }
        }catch{
            print(error)
        }
    }
    
    func retrieveDataFromCells(){
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        name = nameCell.textField.text!
        
        let locationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TextFieldCell
        location = locationCell.textField.text!
        
        let startTimeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TimeCell
        startDate = startTimeCell.date
        
        let endTimeCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! TimeCell
        endDate = endTimeCell.date
        
        let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! TextFieldCell
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
            //cell.textField.delegate = self
            cell.delegate = self
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
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //handles timeCells trigger timePickerCells.
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
