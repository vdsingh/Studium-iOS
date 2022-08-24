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
    
//    var alertTimes: [Int] = []
    
    //Error string that tells the user what is wrong
    var errors: String = ""

    @IBOutlet weak var navButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        self.cells = [
            [
                .labelCell(cellText: "This Event is a Course Assignment", onClick: nil)
            ],
            [
                .textFieldCell(placeholderText: "Name", id: FormCellID.TextFieldCell.nameTextField, textFieldDelegate: self, delegate: self),
                .textFieldCell(placeholderText: "Location", id: FormCellID.TextFieldCell.locationTextField, textFieldDelegate: self, delegate: self),
                .labelCell(cellText: "Remind Me", cellAccessoryType: .disclosureIndicator, onClick: self.navigateToAlertTimes)
            ],
            [
                .timeCell(cellText: "Starts", date: self.startDate, id: FormCellID.TimeCell.startTimeCell, onClick: self.timeCellClicked),
                .timeCell(cellText: "Ends", date: self.endDate, id: FormCellID.TimeCell.endTimeCell, onClick: self.timeCellClicked)
            ],
            [
                .textFieldCell(placeholderText: "Additional Details", id: FormCellID.TextFieldCell.additionalDetailsTextField, textFieldDelegate: self, delegate: self),
                .labelCell(cellText: "", textColor: .systemRed, backgroundColor: .systemBackground)
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
        
        if self.endDate < self.startDate{
            errors.append(" End Date cannot be before Start Date")
        }
        
        //there are no errors
        if errors == ""{
            if otherEvent == nil{
                guard let user = app.currentUser else {
                    print("$ ERROR: error getting user in MasterForm")
                    return
                }
                let newEvent = OtherEvent()
                newEvent.initializeData(startDate: self.startDate, endDate: endDate, name: name, location: location, additionalDetails: additionalDetails, notificationAlertTimes: alertTimes, partitionKey: user.id)
                for alertTime in alertTimes{
                    let alertDate = self.startDate - (Double(alertTime) * 60)
                    var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alertDate)
                    components.second = 0
                    
                    let identifier = UUID().uuidString
                    newEvent.notificationIdentifiers.append(identifier)
                    NotificationHandler.scheduleNotification(components: components, body: "Don't be late!", titles: "\(name) at \(self.startDate.format(with: "h:mm a"))", repeatNotif: false, identifier: identifier)
                }
                RealmCRUD.saveOtherEvent(otherEvent: newEvent)
            }else{
                do{
                    try realm.write{
                        otherEvent!.updateNotifications(with: alertTimes)
                    }
                    for alertTime in alertTimes{
                        if !otherEvent!.notificationAlertTimes.contains(alertTime){
                            let alertDate = self.startDate - (Double(alertTime) * 60)
                            var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alertDate)
                            components.second = 0
                            print("alertDate: \(alertDate). Start Date: \(self.startDate)")
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
                        otherEvent!.initializeData(startDate: self.startDate, endDate: self.endDate, name: name, location: location, additionalDetails: additionalDetails)
                    }
                }catch{
                    print("there was an error: \(error)")
                }
            }
            guard let delegate = delegate else {
                print("$ ERROR: delegate is nil in AddToDoListEventViewController.")
                return
            }

            delegate.refreshData()
            dismiss(animated: true, completion: nil)
        }else{
            //update the errors cell to show all of the errors with the form
            self.replaceLabelText(text: errors, section: 3, row: 1)
            tableView.reloadData()
        }
    }
    
    //cancel the form
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AlertTableViewController{
            destinationVC.delegate = self
        }
    }
}

extension AddToDoListEventViewController: UITextFieldDelegateExt{
    func textEdited(sender: UITextField, textFieldID: FormCellID.TextFieldCell) {
        guard let text = sender.text else {
            print("$ ERROR: sender's text was nil. \nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
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
        print("$ LOG: fillform called in AddToDoListEventController")
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
        if courses.count != 0 {
            
            // TODO: Fix force typing
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
}
