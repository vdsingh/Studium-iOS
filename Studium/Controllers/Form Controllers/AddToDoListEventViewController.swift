//
//  AddToDoListEvent.swift
//  Studium
//
//  Created by Vikram Singh on 6/26/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftUI

protocol ToDoListRefreshProtocol{
    func refreshData()
}



class AddToDoListEventViewController: MasterForm {
    var codeLocationString: String = "Add To Do List Event Form"
    
    //tracks the event being edited, if one is being edited.
    var otherEvent: OtherEvent?
    
    //link to the list of OtherEvents, so that when a new ToDo Event is created, the list refreshes.
    var delegate: ToDoListRefreshProtocol?
    
    //Basic OtherEvent characteristics
    var name: String = ""
    var location: String = ""
    var additionalDetails: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    
//    var alertTimes: [Int] = []
    
    //Error string that tells the user what is wrong
    var errors: String = ""
    
    //Arrays that help construct the form. Describes which types of cells go where and what their contents are.
//    var cellText: [[String]] = [
//        ["This Event is a Course Assignment"],
//        ["Name", "Location", "Remind Me"],
//        ["Starts", "Ends"],
//        ["Additional Details", ""]
//    ]
//    var cells: [[FormCell]] =
    
    

    @IBOutlet weak var navButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        self.cells = [
            [
                .labelCell(cellText: "This Event is a Course Assignment", onClick: nil)
            ],
            [
                .textFieldCell(placeholderText: "Name", id: FormCellID.TextFieldCell.nameTextField, textFieldDelegate: self, delegate: self),
                .textFieldCell(placeholderText: "Location", id: FormCellID.TextFieldCell.locationTextField, textFieldDelegate: self, delegate: self),
                .labelCell(cellText: "Remind Me", cellAccessoryType: .detailDisclosureButton, onClick: nil)
            ],
            [
                .timeCell(cellText: "Starts", date: self.startDate, id: FormCellID.TimeCell.startTimeCell, onClick: nil),
                .timeCell(cellText: "Ends", date: self.endDate, id: FormCellID.TimeCell.endTimeCell, onClick: nil)],
            [
                .textFieldCell(placeholderText: "Additional Details", id: FormCellID.TextFieldCell.additionalDetailsTextField, textFieldDelegate: self, delegate: self),
                .labelCell(cellText: "", textColor: .systemRed, onClick: nil)
            ]
        ]
        super.viewDidLoad()
        
        //makes it so that the form doesn't have a bunch of empty cells at the bottom
        tableView.tableFooterView = UIView()
        
        if otherEvent != nil{
            fillForm(with: otherEvent!)
        }else{
            navButton.image = UIImage(systemName: "plus")
            //we are creating a new ToDoEvent
            if UserDefaults.standard.object(forKey: K.defaultNotificationTimesKey) != nil {
                print("LOG: Loading User's Default Notification Times for ToDoEvent Form.")
                alertTimes = UserDefaults.standard.value(forKey: K.defaultNotificationTimesKey) as! [Int]
            }
        }
    }
    
    //function that is called when the user wants to finish editing in the form and create the new object.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        errors = ""
        
        //updates the characteristic variables
//        retrieveDataFromCells()
        if name == ""{
            errors.append("Please specify a name.")
        }
        
        if endDate < startDate{
            errors.append(" End Date cannot be before Start Date")
        }
        
        //there are no errors
        if errors == ""{
            if otherEvent == nil{
                guard let user = app.currentUser else {
                    print("Error getting user in MasterForm")
                    return
                }
                let newEvent = OtherEvent()
                newEvent.initializeData(startDate: startDate, endDate: endDate, name: name, location: location, additionalDetails: additionalDetails, notificationAlertTimes: alertTimes, partitionKey: user.id)
                for alertTime in alertTimes{
                    let alertDate = startDate - (Double(alertTime) * 60)
                    var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alertDate)
                    components.second = 0
                    
                    let identifier = UUID().uuidString
                    newEvent.notificationIdentifiers.append(identifier)
                    NotificationHandler.scheduleNotification(components: components, body: "Don't be late!", titles: "\(name) at \(startDate.format(with: "h:mm a"))", repeatNotif: false, identifier: identifier)
                }
                RealmCRUD.saveOtherEvent(otherEvent: newEvent)
            }else{
                do{
                    try realm.write{
                        otherEvent!.updateNotifications(with: alertTimes)
                    }
                    for alertTime in alertTimes{
                        if !otherEvent!.notificationAlertTimes.contains(alertTime){
                            let alertDate = startDate - (Double(alertTime) * 60)
                            var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alertDate)
                            components.second = 0
                            print("alertDate: \(alertDate). Start Date: \(startDate)")
                            let identifier = UUID().uuidString
                            try realm.write{
                                print("scheduling new notification for alertTime: \(alertTime)")
                                otherEvent!.notificationIdentifiers.append(identifier)
                                otherEvent!.notificationAlertTimes.append(alertTime)
                            }
                            NotificationHandler.scheduleNotification(components: components, body: "Don't be late!", titles: "\(name) at \(startDate.format(with: "h:mm a"))", repeatNotif: false, identifier: identifier)
                        }

                    }
                    try realm.write{
                        otherEvent!.initializeData(startDate: startDate, endDate: endDate, name: name, location: location, additionalDetails: additionalDetails)
                    }
                }catch{
                    print("there was an error: \(error)")
                }
            }
            delegate!.refreshData()
            dismiss(animated: true, completion: nil)
        }else{
            //update the errors cell to show all of the errors with the form
//            cellText[3][1] = errors
            self.replaceLabelText(text: errors, section: 3, row: 1)
            tableView.reloadData()
        }
    }
    

    
    //cancel the form
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    
    //function that retrieves data from specific cells and updates characteristic variables
//    func retrieveDataFromCells(){
//        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TextFieldCell
//        name = nameCell.textField.text!
//
//        let locationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! TextFieldCell
//        location = locationCell.textField.text!
//
//        let startTimeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! TimeCell
//        startDate = startTimeCell.date!
//
//        //finding the index for the endTimeCell is necessary because there could be other PickerCells in the section, meaning we don't know the exact location without looking.
//        let endTimeCellIndex = cellType[2].lastIndex(of: "TimeCell")
//        let endTimeCell = tableView.cellForRow(at: IndexPath(row: endTimeCellIndex!, section: 2)) as! TimeCell
//        endDate = endTimeCell.date!
//
//        let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! TextFieldCell
//        additionalDetails = additionalDetailsCell.textField.text!
//    }
    
    // MARK: - Table view data source
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return cells.count
//    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return cells[section].count
//    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        let cellType
//        if cellType[indexPath.section][indexPath.row] == .timePickerCell {
//            return 150
//        }
//        return 50
//    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if cellType[indexPath.section][indexPath.row] == .textFieldCell{
//            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.id, for: indexPath) as! TextFieldCell
//            cell.textField.placeholder = cellText[indexPath.section][indexPath.row]
//            cell.textField.delegate = self
//            cell.delegate = self
//            return cell
//        }else if cellType[indexPath.section][indexPath.row] == .timeCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: TimeCell.id, for: indexPath) as! TimeCell
//            if indexPath.row == 0{
//                cell.date = startDate
//                cell.timeLabel.text = startDate.format(with: "MMM d, h:mm a")
//            }else{
//                cell.date = endDate
//                cell.timeLabel.text = endDate.format(with: "MMM d, h:mm a")
//            }
//            cell.label.text = cellText[indexPath.section][indexPath.row]
////            cell.date = Date()
//            return cell
//        }else if cellType[indexPath.section][indexPath.row] == .timePickerCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: TimePickerCell.id, for: indexPath) as! TimePickerCell
//            cell.picker.datePickerMode = .dateAndTime
//            cell.delegate = self
//            cell.indexPath = indexPath
//            return cell
//        }else if cellType[indexPath.section][indexPath.row] == .labelCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: LabelCell.id, for: indexPath) as! LabelCell
//            cell.label.text = cellText[indexPath.section][indexPath.row]
//            if indexPath.section == 0{
//                cell.label.textAlignment = .center
//            }else if indexPath.section == 1{
//                cell.accessoryType = .disclosureIndicator
//            }else if indexPath.section == 3{
//                cell.label.textColor = .red
//                cell.backgroundColor = .systemBackground
//            }
//            return cell
//        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AlertTableViewController{
            destinationVC.delegate = self
        }
    }
    
    
}

extension AddToDoListEventViewController: UITimePickerDelegate{
    func pickerValueChanged(sender: UIDatePicker, indexPath: IndexPath, pickerID: FormCellID.TimePickerCell) {
        //we are getting the timePicker's corresponding timeCell by accessing its indexPath and getting the element in the tableView right before it. This is always the timeCell it needs to update. The indexPath of the timePicker is stored in the cell's class upon creation, so that it can be passed to this function when needed.
        let correspondingTimeCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as! TimeCell
        correspondingTimeCell.date = sender.date
        correspondingTimeCell.timeLabel.text = correspondingTimeCell.date!.format(with: "MMM d, h:mm a")
        
//        if cellText[indexPath.section][indexPath.row - 1] == "Starts"{
//            print("startDate changed")
//            startDate = sender.date
//        }else{
//            print("endDate changed")
//            endDate = sender.date
//        }
        
    }
}

extension AddToDoListEventViewController: UITextFieldDelegateExt{
    func textEdited(sender: UITextField, textFieldID: FormCellID.TextFieldCell) {
        guard let text = sender.text else {
            print("$ ERROR: sender's text was nil. \nFile: \(#file)\nFunction: \(#function)\nLine: \(#line)")
            return
        }
        switch textFieldID {
        case .nameTextField:
            self.name = text
        case .locationTextField:
            self.location = text
        case .additionalDetailsTextField:
            self.additionalDetails = text
        }
    }
}

extension AddToDoListEventViewController{
    func fillForm(with otherEvent: OtherEvent){
        print("fillform called")
        navButton.image = .none
        navButton.title = "Done"
        
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TextFieldCell
        nameCell.textField.text = otherEvent.name
        name = otherEvent.name
        
        let locationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! TextFieldCell
        locationCell.textField.text = otherEvent.location
        location = otherEvent.location
        
        let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! TextFieldCell
        additionalDetailsCell.textField.text = otherEvent.additionalDetails
        additionalDetails = otherEvent.additionalDetails
        
        alertTimes = []
        for alert in otherEvent.notificationAlertTimes{
            alertTimes.append(alert)
        }
        
        let startCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! TimeCell
        startDate = otherEvent.startDate
        startCell.timeLabel.text = startDate.format(with: "MMM d, h:mm a")
        startCell.date = startDate
        
        let endCell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as! TimeCell
        endDate = otherEvent.endDate
        endCell.timeLabel.text = endDate.format(with: "MMM d, h:mm a")
        endCell.date = endDate
    }
}

extension AddToDoListEventViewController {
    
    private func remindMeClicked() {
        performSegue(withIdentifier: "toAlertSelection", sender: self)
    }
    
    private func isAssignmentClicked() {
        let courses = realm.objects(Course.self)
        if courses.count != 0{
            let del = delegate as! ToDoListViewController
            self.dismiss(animated: true) {
                
                //make sure that the data in our variables is updated before we transfer it to the new form.
//                    self.retrieveDataFromCells()
                
                //go to the assignment form instead of todo item form. Also provide the assignment form the information from the current form.
                del.openAssignmentForm(name: self.name, location: self.location, additionalDetails: self.additionalDetails, alertTimes: self.alertTimes, dueDate: self.endDate)
            }
        }else{
            let alert = UIAlertController(title: "No Courses Available", message: "You haven't added any Courses yet. To add an Assignment, please add a Course first.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
//    private func timeCellClicked() {
//        //handles timeCells trigger timePickerCells.
//        let selectedRowText = cellText[indexPath.section][indexPath.row]
//        if cellType[indexPath.section][indexPath.row] == .timeCell {
//            var pickerIndex = cellType[indexPath.section].firstIndex(of: .timePickerCell)
//            if pickerIndex == nil{
//                pickerIndex = cellType[indexPath.section].firstIndex(of: .pickerCell)
//            }
//            tableView.beginUpdates()
//
//            if let index = pickerIndex{
//                cellText[indexPath.section].remove(at: index)
//                cellType[indexPath.section].remove(at: index)
//                tableView.deleteRows(at: [IndexPath(row: index, section: indexPath.section)], with: .right)
//                if index == indexPath.row + 1{
//                    tableView.endUpdates()
//                    return
//                }
//            }
//
//            let newIndex = cellText[indexPath.section].firstIndex(of: selectedRowText)! + 1
//
//            tableView.insertRows(at: [IndexPath(row: newIndex, section: indexPath.section)], with: .left)
//            cellType[indexPath.section].insert(.timePickerCell, at: newIndex)
//            cellText[indexPath.section].insert("", at: newIndex)
//            tableView.endUpdates()
//    }
    
    //handles opening and closing picker cells as well as if the user selected the assignment option
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        view.endEditing(true)
//
//        //user taps "This Event is a Course Assignment"
//        if indexPath.section == 0{
//            let courses = realm.objects(Course.self)
//            if courses.count != 0{
//                let del = delegate as! ToDoListViewController
//                self.dismiss(animated: true) {
//
//                    //make sure that the data in our variables is updated before we transfer it to the new form.
////                    self.retrieveDataFromCells()
//
//                    //go to the assignment form instead of todo item form. Also provide the assignment form the information from the current form.
//                    del.openAssignmentForm(name: self.name, location: self.location, additionalDetails: self.additionalDetails, alertTimes: self.alertTimes, dueDate: self.endDate);
//
//                }
//            }else{
//                let alert = UIAlertController(title: "No Courses Available", message: "You haven't added any Courses yet. To add an Assignment, please add a Course first.", preferredStyle: .alert)
//
//                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//
//                self.present(alert, animated: true)
//            }
//        }else if cellText[indexPath.section][indexPath.row] == "Remind Me"{
//            performSegue(withIdentifier: "toAlertSelection", sender: self)
//        }else{
//
//            //handles timeCells trigger timePickerCells.
//            let selectedRowText = cellText[indexPath.section][indexPath.row]
//            if cellType[indexPath.section][indexPath.row] == .timeCell {
//                var pickerIndex = cellType[indexPath.section].firstIndex(of: .timePickerCell)
//                if pickerIndex == nil{
//                    pickerIndex = cellType[indexPath.section].firstIndex(of: .pickerCell)
//                }
//                tableView.beginUpdates()
//
//                if let index = pickerIndex{
//                    cellText[indexPath.section].remove(at: index)
//                    cellType[indexPath.section].remove(at: index)
//                    tableView.deleteRows(at: [IndexPath(row: index, section: indexPath.section)], with: .right)
//                    if index == indexPath.row + 1{
//                        tableView.endUpdates()
//                        return
//                    }
//                }
//
//                let newIndex = cellText[indexPath.section].firstIndex(of: selectedRowText)! + 1
//
//                tableView.insertRows(at: [IndexPath(row: newIndex, section: indexPath.section)], with: .left)
//                cellType[indexPath.section].insert(.timePickerCell, at: newIndex)
//                cellText[indexPath.section].insert("", at: newIndex)
//                tableView.endUpdates()
//            }
//        }
//    }
}
