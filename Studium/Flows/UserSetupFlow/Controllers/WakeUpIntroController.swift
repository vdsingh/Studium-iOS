//
//  WakeUpIntroController.swift
//  Studium
//
//  Created by Vikram Singh on 5/27/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

// TODO: Docstrings
//this controls the page that the user sees in the beginning, when they must enter what times they wake up at.
class WakeUpIntroController: UIViewController, ErrorShowing, Storyboarded {
    
    weak var coordinator: UserSetupCoordinator?
    
    //TODO: Docstrings
    let databaseService: DatabaseServiceProtocol! = DatabaseService.shared
    
    let debug = true
    
    //reference to defaults - that is where we will be storing the time data for when the user wakes up
    let defaults = UserDefaults.standard
    
    // TODO: Docstrings
    //reference to certain UIKit elements that we need access to.
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // TODO: Docstrings
    @IBOutlet var dayButtons: Array<UIButton>?
    
    @IBOutlet weak var sunLabel: UILabel!
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tueLabel: UILabel!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var thuLabel: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    
    // TODO: Docstrings
    @IBOutlet var weekdayLabels: Array<UILabel>?
    
    // TODO: Docstrings
    @IBOutlet weak var timePickerContainer: UIView!
    
    // TODO: Docstrings
    @IBOutlet weak var timePicker: UIDatePicker!
    
    // TODO: Docstrings
    @IBOutlet weak var nextButton: UIButton!
    
    // TODO: Docstrings
    var selectedDay: UIButton?
    
    // TODO: Docstrings
    @IBOutlet weak var secondaryBackground: UIView!
    
    //dictionaries that help keep the data organized
    
    // TODO: Docstrings
    //the String is the day (e.g: "Sun") and the Date is the wake up time
    var times: [String: Date] = [:]
    
    // TODO: Docstrings
    //the String is the day (e.g: "Sun") and the UILabel is a reference to the label that it corresponds to
    var labels: [String: UILabel] = [:]
    
    // TODO: Docstrings
    var dayLabels: [String: UILabel] = [:]
    
    // TODO: Docstrings
    //boolean that tells whether the user wakes up at different times depending on the day.
    var differentTimes: Bool = true
    
    // TODO: Docstrings
    let tintColor: UIColor = StudiumColor.primaryAccent.uiColor
    
    // TODO: Docstrings
    let labelColor: UIColor = StudiumColor.primaryLabel.uiColor
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = StudiumColor.background.uiColor
        self.secondaryBackground.backgroundColor = StudiumColor.background.uiColor
        self.segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        self.segmentedControl.backgroundColor = StudiumColor.secondaryBackground.uiColor
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if error != nil{
                print(error!)
            }
        }

        nextButton.titleLabel?.text = "Next"
        nextButton.titleLabel?.textColor = .orange
        nextButton.layer.cornerRadius = 10
        
        secondaryBackground.layer.cornerRadius = 10
        
        self.timePicker.backgroundColor = .clear
        self.timePickerContainer.backgroundColor = StudiumColor.secondaryBackground.uiColor
        self.timePickerContainer.layer.cornerRadius = 15
//        self.timePicker.back
//        self.timePicker.tintColor = StudiumColor.primaryLabel.uiColor
//        self.timePicker.textInputContextIdentifier
        
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        timePicker.setValue(1, forKeyPath: "alpha")

        //selects sunday by default
        
        //selects the time 7:30AM by default
        let date = Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date())!
        timePicker.setDate(date, animated: true)
        
        //initialize the dictionaries. The only one that will have data that changes (potentially) is the times dictionary
        self.times = ["Sun": date, "Mon": date, "Tue": date, "Wed": date, "Thu": date, "Fri": date, "Sat": date]
        self.labels = ["Sun": sunLabel, "Mon": monLabel, "Tue": tueLabel, "Wed": wedLabel, "Thu": thuLabel, "Fri": friLabel, "Sat": satLabel]
        
        if weekdayLabels != nil{
            dayLabels = ["Sun": weekdayLabels![0], "Mon": weekdayLabels![1], "Tue": weekdayLabels![2], "Wed": weekdayLabels![3], "Thu": weekdayLabels![4], "Fri": weekdayLabels![5], "Sat": weekdayLabels![6]]
        }
        
        selectSunday()
    }
    
    // TODO: Docstrings
    //function that is called when the user switches between whether they wake up at different times or at the same time.
    @IBAction func timeSelectionTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{ //different times
            differentTimes = true
            for day in dayButtons!{
                day.isSelected = false
                day.isEnabled = true
            }
            selectSunday()
            
        } else { //same time everyday
            differentTimes = false
            for day in dayButtons!{
                day.setTitleColor(.lightGray, for: .disabled)
                day.isSelected = false
                day.isEnabled = false
                
                labels[day.titleLabel!.text!]?.textColor = labelColor
                dayLabels[day.titleLabel!.text!]?.textColor = labelColor
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let formattedDate = dateFormatter.string(from: timePicker.date)
            for (day, _) in times{
                times[day] = timePicker.date
            }
            for (_, label) in labels{
                label.text = formattedDate
            }
        }
    }
    
    // TODO: Docstrings
    //function that is called when the user selects a day button
    @IBAction func dayButtonPressed(_ sender: UIButton) {
        selectedDay = sender
        for day in dayButtons!{
            day.isSelected = false
            labels[day.titleLabel!.text!]?.textColor = labelColor
            dayLabels[day.titleLabel!.text!]?.textColor = labelColor
        }
        sender.isSelected = true
        sender.setTitleColor(.label, for: .selected)
        
        labels[sender.titleLabel!.text!]?.textColor = tintColor
        if weekdayLabels != nil{
            dayLabels[sender.titleLabel!.text!]?.textColor = tintColor
        }
    }
    
    // TODO: Docstrings
    //function that is called when the user edits a timePicker
    @IBAction func timePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let formattedDate = dateFormatter.string(from: timePicker.date)
        if differentTimes {
            if let day = selectedDay{
                times[day.titleLabel!.text!] = timePicker.date
            }
            labels[selectedDay!.titleLabel!.text!]!.text = formattedDate
        }else{
            for (_, label) in labels{
                label.text = formattedDate
            }
            
            for (day, _) in times{
                times[day] = timePicker.date
            }
        }
    }
    
    // TODO: Docstrings
    //selects Sunday
    func selectSunday(){
        for day in dayButtons!{ //select sunday at start
//            day.setTitleColor(.label, for: .selected)
            if day.titleLabel?.text == "Sun"{
                labels["Sun"]!.textColor = tintColor
                dayLabels["Sun"]!.textColor = tintColor
                day.setTitleColor(.label, for: .selected)
                day.isSelected = true
                selectedDay = day
                break
            }
        }
    }
    
    // TODO: Docstrings
    //function called when the user is finished and wants to move on
    @IBAction func nextPressed(_ sender: UIButton) {
        storeData()
        defaults.set(true, forKey: "didFinishIntro")
        if let coordinator = self.coordinator {
            coordinator.finish()
        } else {
            self.showError(.nilCoordinator)
        }
    }
    
    // TODO: Docstrings
    //function that stores the data in UserDefaults
    func storeData(){
        printDebug("Storing data for Wake Up Times: \(self.times)")
        guard let sunTime = self.times["Sun"],
              let monTime = self.times["Mon"],
              let tueTime = self.times["Tue"],
              let wedTime = self.times["Wed"],
              let thuTime = self.times["Thu"],
              let friTime = self.times["Fri"],
              let satTime = self.times["Sat"] else {
            print("$ERR (WakeUpIntroController): couldn't retrieve wake up times from map. A value was nil: \(self.times)")
            return
        }

        self.databaseService.setWakeUpTime(for: .sunday, wakeUpTime: sunTime)
        self.databaseService.setWakeUpTime(for: .monday, wakeUpTime: monTime)
        self.databaseService.setWakeUpTime(for: .tuesday, wakeUpTime: tueTime)
        self.databaseService.setWakeUpTime(for: .wednesday, wakeUpTime: wedTime)
        self.databaseService.setWakeUpTime(for: .thursday, wakeUpTime: thuTime)
        self.databaseService.setWakeUpTime(for: .friday, wakeUpTime: friTime)
        self.databaseService.setWakeUpTime(for: .saturday, wakeUpTime: satTime)
    }
}

extension WakeUpIntroController: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (WakeUpIntroController): \(message)")
        }
    }
}
