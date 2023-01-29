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
import FlexColorPicker


//guarantees that the Habit list has a method that allows it to refresh.
protocol HabitRefreshProtocol{
    func loadHabits()
}

//Class used to manage the form for adding a Habit. The form is a tableView form, similar to adding an event in
class AddHabitViewController: MasterForm {
    var codeLocationString: String = "Add Habit Form"
    
    var habit: Habit?
    
    //variable that helps run things once that only need to run at the beginning
    var resetAll: Bool = true
    
    //variables that hold the total length of the habit.
//    var totalLengthHours = 1
//    var totalLengthMinutes = 0
//
    //reference to the Habits list, so that once complete, it can update and show the new Habit
    var delegate: HabitRefreshProtocol?
    
    var cellsAuto: [[FormCell]] = [[]]
    var cellsNoAuto: [[FormCell]] = [[]]
    //These are the holders for the cellText and cellType. Basically these hold the above arrays and are used depending on whether the user chooses to use autoschedule or not.
    var cellText: [[String]] = [[]]
    var cellType: [[FormCell]] = [[]]
    
    var times: [Date] = []
    var timeCounter = 0
    
    //The errors array is populated when the user forgets to fill out a required part of the form or for any other error. if it is populated when the user tries to complete the process, it will prevent the user from moving forward
    var errors: String = ""
//    var errorLabel: LabelCell?
    
    //Basic elements of a habit. These qualities are used whenever the Habit is created.
    var autoschedule = false
    var name: String = ""
    var additionalDetails: String = ""
    var colorValue: String = "ffffff"
    var location: String = ""
    var earlier = true
    var daysSelected: [Int] = []
    
    //array that keeps track of when the user should be sent notifications about this habit
//    var alertTimes: [Int] = []
    
    @IBOutlet weak var navButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //used to decipher which TimeCell should have which dates
        times = [self.startDate, self.endDate]
        
        self.cellsNoAuto = [
            [
                .textFieldCell(placeholderText: "Name", id: .nameTextField, textFieldDelegate: self, delegate: self),
                .textFieldCell(placeholderText: "Location", id: .locationTextField, textFieldDelegate: self, delegate: self),
                .daySelectorCell(delegate: self),
                .labelCell(cellText: "Remind Me", cellAccessoryType: .disclosureIndicator, onClick: self.navigateToAlertTimes)
            ],
            [
                .switchCell(cellText: "Autoschedule", switchDelegate: self, infoDelegate: self),
                .timeCell(cellText: "Start", date: Date(), dateFormat: "h:mm a", id: .startTimeCell, onClick: self.timeCellClicked),
                .timeCell(cellText: "Finish", date: Date(), dateFormat: "h:mm a", id: .endTimeCell, onClick: self.timeCellClicked)
            ],
            [
                .logoCell(imageString: "pencil", onClick: self.navigateToLogoSelection),
                .colorPickerCell(delegate: self),
                .textFieldCell(placeholderText: "Additional Details",
                               id: FormCellID.TextFieldCell.additionalDetailsTextField,
                               textFieldDelegate: self,
                               delegate: self),
                .labelCell(cellText: "", textColor: .systemRed, backgroundColor: .systemBackground)
            ]
        ]
        
        self.cellsAuto = [
            [
                .textFieldCell(placeholderText: "Name", id: .nameTextField, textFieldDelegate: self, delegate: self),
                .textFieldCell(placeholderText: "Location", id: .locationTextField, textFieldDelegate: self, delegate: self),
                .daySelectorCell(delegate: self),
                .labelCell(cellText: "Remind Me", cellAccessoryType: .disclosureIndicator, onClick: self.navigateToAlertTimes)
            ],
            [
                .switchCell(cellText: "Autoschedule", switchDelegate: self, infoDelegate: self),
                .timeCell(cellText: "Between", date: Date(), dateFormat: "h:mm a", id: .startTimeCell, onClick: self.timeCellClicked),
                .timeCell(cellText: "And", date: Date(), dateFormat: "h:mm a", id: .endTimeCell, onClick: self.timeCellClicked),
                .timeCell(cellText: "Length of Habit", date: nil, dateFormat: nil, timeLabelText: "\(self.totalLengthHours) hours \(self.totalLengthMinutes) mins", id: .lengthTimeCell, onClick: self.timeCellClicked),
                .segmentedControlCell(firstTitle: "Earlier", secondTitle: "Later", delegate: self)
            ],
            [
                .logoCell(imageString: self.systemImageString, onClick: self.navigateToLogoSelection),
                .colorPickerCell(delegate: self),
                .textFieldCell(placeholderText: "Additional Details", id: .additionalDetailsTextField, textFieldDelegate: self, delegate: self),
                .labelCell(cellText: "", textColor: .systemRed, backgroundColor: .systemBackground)
            ]
        ]
        
        self.cells = self.cellsNoAuto
        
        //makes it so that the form doesn't have a bunch of empty cells at the bottom
        tableView.tableFooterView = UIView()
        
        navButton.image = UIImage(systemName: "plus")
        if let habit = habit {
            if habit.autoschedule {
                tableView.reloadData()
            }
            fillForm(with: habit)
        } else {
            //We are creating a new habit
//            if UserDefaults.standard.object(forKey: K.defaultNotificationTimesKey) != nil {
//                print("$ LOG: Loading User's Default Notification Times for Habit Form.")
//                alertTimes = UserDefaults.standard.value(forKey: K.defaultNotificationTimesKey) as! [Int]
//            }
        }
    }
    
    //MARK: - UIElement IBActions
    
    //final step that occurs when the user finishes the form and adds the habit
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        resetAll = false
        errors = ""
//        cellText[2][cellText[2].count - 1] = ""
//        retrieveData()
        // TODO: FIX FORCE UNWRAP
        endDate = Calendar.current.date(bySettingHour: self.endDate.hour, minute: self.endDate.minute, second: self.endDate.second, of: self.startDate)!
//        reloadData()
        
        
        if name == "" {
            errors.append("Please specify a name. ")
        }
        
        if daysSelected == [] {
            errors.append("Please select at least one day. ")
        }
        if autoschedule && totalLengthHours == 0 && totalLengthMinutes == 0 {
            errors.append("Please specify total time. ")
        } else if self.endDate < self.startDate {
            errors.append("The first time bound must be before the second time bound")
        } else if autoschedule && (self.endDate.hour - self.startDate.hour) * 60 + (self.endDate.minute - self.startDate.minute) < totalLengthHours * 60 + totalLengthMinutes {
            errors.append("The total time exceeds the time frame. ")
        }
        
        if errors.count == 0 { //if there are no errors.
            if habit == nil {
//                guard let user = app.currentUser else {
//                    print("ERROR: error getting user in MasterForm")
//                    return
//                }
                let newHabit = Habit(
                    name: name,
                    location: location,
                    additionalDetails: additionalDetails,
                    startDate: startDate,
                    endDate: endDate,
                    autoschedule: autoschedule,
                    startEarlier: earlier,
                    autoLengthMinutes: totalLengthHours * 60 + totalLengthMinutes,
                    days: daysSelected,
                    systemImageString: systemImageString,
                    colorHex: colorValue,
                    partitionKey: DatabaseService.shared.user?.id ?? ""
                )
                
                if !autoschedule {
                    for alertTime in alertTimes {
                        for day in daysSelected {
                            
//                            let weekday = Date.convertDayToWeekday(day: day)
//                            let weekdayAsInt = Date.convertDayToInt(day: day)
                            var alertDate = Date()
                            
                            if self.startDate.weekday != day{ //the course doesn't occur today
                                alertDate = Date.today().next(Date.convertDayToWeekday(day: day))
                            }
                            
                            alertDate = Calendar.current.date(bySettingHour: startDate.hour, minute: startDate.minute, second: 0, of: alertDate)!
                            
                            alertDate -= (60 * Double(alertTime.rawValue))
                            //                    alertDate = startDate - (60 * Double(alertTime))
                            //consider how subtracting time from alertDate will affect the weekday component.
                            let courseComponents = DateComponents(hour: alertDate.hour, minute: alertDate.minute, second: 0, weekday: alertDate.weekday)
                            //                    print(courseComponents)
                            
                            //adjust title as appropriate
                            var title = ""
                            if alertTime.rawValue < 60 {
                                title = "\(name) starts in \(alertTime) minutes."
                            } else if alertTime.rawValue == 60 {
                                title = "\(name) starts in 1 hour"
                            } else {
                                title = "\(name) starts in \(alertTime.rawValue / 60) hours"
                            }
                            let timeFormat = self.startDate.format(with: "h:mm a")
                            
                            let identifier = UUID().uuidString
//                            newHabit.notificationIdentifiers.append(identifier)
                            newHabit.alertTimes.append(alertTime)
//                            NotificationHandler.scheduleNotification(components: courseComponents, body: "Be there by \(timeFormat). Don't be late!", titles: title, repeatNotif: true, identifier: identifier)
                        }
                    }
                } else {
                    for alertTime in alertTimes {
                        newHabit.alertTimes.append(alertTime)
                    }
                }
                RealmCRUD.saveHabit(habit: newHabit)
                newHabit.addToAppleCalendar()
                
            } else {
                do {
                    
                    try DatabaseService.shared.realm.write {
                        if !autoschedule {
                            // TODO: FIX FORCE UNWRAP
//                            habit!.deleteNotifications()
                            for alertTime in alertTimes {
                                for day in daysSelected {
                                    
//                                    let weekday = Date.convertDayToWeekday(day: day)
//                                    let weekdayAsInt = Date.convertDayToInt(day: day)
                                    var alertDate = Date()
                                    
                                    if startDate.weekday != day { //the course doesn't occur today
                                        alertDate = Date.today().next(Date.convertDayToWeekday(day: day))
                                    }
                                    
                                    alertDate = Calendar.current.date(bySettingHour: startDate.hour, minute: startDate.minute, second: 0, of: alertDate)!
                                    
                                    alertDate -= (60 * Double(alertTime.rawValue))
                                    //consider how subtracting time from alertDate will affect the weekday component.
                                    let courseComponents = DateComponents(hour: alertDate.hour, minute: alertDate.minute, second: 0, weekday: alertDate.weekday)
                                    //                    print(courseComponents)
                                    
                                    //adjust title as appropriate
                                    var title = ""
                                    if alertTime.rawValue < 60 {
                                        title = "\(name) starts in \(alertTime) minutes."
                                    } else if alertTime.rawValue == 60 {
                                        title = "\(name) starts in 1 hour"
                                    } else {
                                        title = "\(name) starts in \(alertTime.rawValue / 60) hours"
                                    }
                                    let timeFormat = startDate.format(with: "h:mm a")
                                    
                                    let identifier = UUID().uuidString
//                                    habit!.notificationIdentifiers.append(identifier)
                                    habit!.alertTimes.append(alertTime)
//                                    NotificationHandler.scheduleNotification(components: courseComponents, body: "Be there by \(timeFormat). Don't be late!", titles: title, repeatNotif: true, identifier: identifier)
                                }
                            }
                        } else {
//                            habit!.deleteNotifications()
                            for alertTime in alertTimes{
                                habit!.alertTimes.append(alertTime)
                            }
                        }
//                        guard let user = app.currentUser else {
//                            print("$ ERROR: error getting user in MasterForm")
//                            return
//                        }
                        
                        
//                        habit!.initializeData(name: name, location: location, additionalDetails: additionalDetails, startDate: startDate, endDate: endDate, autoschedule: autoschedule, startEarlier: earlier, autoLengthMinutes: totalLengthMinutes, days: daysSelected, systemImageString: systemImageString, colorHex: colorValue, partitionKey: DatabaseService.shared.user?.id ?? "")
                        print("editing habit with length hour \(totalLengthHours) segmented control: \(earlier)")
                    }
                } catch {
                    print(error)
                }
            }

            dismiss(animated: true) {
                if let del = self.delegate {
                    del.loadHabits()
                } else {
                    print("$ ERROR: delegate was not defined.")
                }
            }
        } else {
            //if there are errors.
            self.replaceLabelText(text: errors, section: 2, row: 3)
            tableView.reloadData()
        }
    }
    
    //Handles whenever the user decides to cancel.
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    //MARK: - tableView helpers
    
    //reset data and reloads tableView
    func reloadData(){
        times = [startDate, endDate]
        timeCounter = 0
        tableView.reloadData()
    }
}

//MARK: - Picker DataSource
//extension AddHabitViewController: UIPickerViewDataSource {
//
//    //how many rows in the picker view, given the component
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if component == 0 { //hours
//            return 24
//        }
//        //minutes
//        return 60
//    }
//
//    //number of components in the pickerView
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
//}

//MARK: - Picker Delegate
//extension AddHabitViewController: UIPickerViewDelegate{
//    
//    //determines the text in each row, given the row and component
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if component == 0{
//            return "\(row) hours"
//        }
//        return "\(row) min"
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let lengthIndex = cellText[1].lastIndex(of: "Length of Habit")
//        let timeCell = tableView.cellForRow(at: IndexPath(row: lengthIndex!, section: 1)) as! TimeCell
//        totalLengthHours = pickerView.selectedRow(inComponent: 0)
//        totalLengthMinutes = pickerView.selectedRow(inComponent: 1)
//        timeCell.timeLabel.text = "\(totalLengthHours) hours \(totalLengthMinutes) mins"
//    }
//}

extension AddHabitViewController: DaySelectorDelegate {
    func dayButtonPressed(sender: UIButton) {
        print("dayButton pressed")
        let dayTitle = sender.titleLabel!.text
        if sender.isSelected {
            sender.isSelected = false
            for day in daysSelected{
                if day == K.weekdayDict[dayTitle!] {//if day is already selected, and we select it again
                    daysSelected.remove(at: daysSelected.firstIndex(of: day)!)
                }
            }
        } else {//day was not selected, and we are now selecting it.
            sender.isSelected = true
            daysSelected.append(K.weekdayDict[dayTitle!]!)
        }
    }
}


extension AddHabitViewController: UITextFieldDelegateExt {
    func textEdited(sender: UITextField, textFieldID: FormCellID.TextFieldCell) {
        guard let text = sender.text else {
            print("$ ERROR: sender's text is nil when editing text.")
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

extension AddHabitViewController: ColorDelegate{
    func colorPickerValueChanged(sender: RadialPaletteControl) {
        colorValue = sender.selectedColor.hexValue()
        print("Changed color")
    }
}

extension AddHabitViewController: SegmentedControlDelegate {
    func controlValueChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("Earlier is true")
            earlier = true
        } else {
            print("Earlier is false")
            earlier = false
        }
    }
}

//MARK: - Switch Delegate
extension AddHabitViewController: CanHandleSwitch {
    //method triggered when the autoschedule switch is triggered
    func switchValueChanged(sender: UISwitch) {
        if sender.isOn {//auto schedule
            self.cells = self.cellsAuto
            autoschedule = true
        } else {
            self.cells = self.cellsNoAuto
            autoschedule = false
        }
        reloadData()
    }
}

extension AddHabitViewController: CanHandleInfoDisplay{
    func displayInformation() {
        let alert = UIAlertController(title: "Autoschedule",
                                      message: "This feature autoschedules time for you! \n\nJust specify what days the habit occurs on and how long the habit lasts. We'll find time for you to get it done! \n\nSome common uses for autoscheduling are finding time for the gym, reading, and studying.",
                                      preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
          }))
        present(alert, animated: true, completion: nil)
    }
}

extension AddHabitViewController{
    func fillForm(with habit: Habit) {
        reloadData()
        
        navButton.image = .none
        navButton.title = "Done"
        
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        nameCell.textField.text = habit.name
        name = habit.name
        
        let locationCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TextFieldCell
        locationCell.textField.text = habit.location
        location = habit.location
        
        let daysCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! DaySelectorCell
        daysCell.selectDays(days: habit.days)
        daysSelected = []
        for day in habit.days {
            daysSelected.append(day)
        }
        
        alertTimes = habit.alertTimes
//        for alert in habit.notificationAlertTimes{
//            alertTimes.append(alert)
//        }
        
        let logoCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! LogoCell
        logoCell.logoImageView.image = UIImage(systemName: habit.systemImageString)
        systemImageString = habit.systemImageString
        
        let colorCell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as! ColorPickerCell
        colorCell.colorPreview.backgroundColor = UIColor(hexString: habit.color)!
        colorValue = habit.color
        
        let additionalDetailsCell = tableView.cellForRow(at: IndexPath(row: 2, section: 2)) as! TextFieldCell
        additionalDetailsCell.textField.text = habit.additionalDetails
        additionalDetails = habit.additionalDetails
        
        let startCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! TimeCell
        startDate = habit.startDate
        startCell.timeLabel.text = startDate.format(with: "h:mm a")
        startCell.date = startDate
        
        let endCell = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as! TimeCell
        endDate = habit.endDate
        endCell.timeLabel.text = endDate.format(with: "h:mm a")
        endCell.date = endDate
        
        if habit.autoschedule {
            let autoscheduleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! SwitchCell
            autoscheduleCell.tableSwitch.isOn = true
            autoschedule = true
            
            let lengthCell = tableView.cellForRow(at: IndexPath(row: 3, section: 1)) as! TimeCell
            lengthCell.timeLabel.text = "\(totalLengthHours) hours \(totalLengthMinutes) mins"
            
            let earlierLaterCell = tableView.cellForRow(at: IndexPath(row: 4, section: 1)) as! SegmentedControlCell
            earlier = habit.startEarlier
            if earlier{
                earlierLaterCell.segmentedControl.selectedSegmentIndex = 0
            }else{
                earlierLaterCell.segmentedControl.selectedSegmentIndex = 1
            }
        }
    }
}
