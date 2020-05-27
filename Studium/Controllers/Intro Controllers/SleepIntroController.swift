//
//  SleepIntroController.swift
//  Studium
//
//  Created by Vikram Singh on 5/27/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class SleepIntroController: UIViewController{
    
    @IBOutlet var days: Array<UIButton>?
    
    @IBOutlet weak var sunLabel: UILabel!
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tueLabel: UILabel!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var thuLabel: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    var selectedDay: UIButton?
    var times: [String: Date] = [:]
    var labels: [String: UILabel] = [:]
    
    var differentTimes: Bool = true
    override func viewDidLoad() {
        selectSunday()
        
        let date = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
        timePicker.setDate(date, animated: true)
        
        times = ["Sun": date, "Mon": date, "Tue": date, "Wed": date, "Thu": date, "Fri": date, "Sat": date]
        
        labels = ["Sun": sunLabel, "Mon": monLabel, "Tue": tueLabel, "Wed": wedLabel, "Thu": thuLabel, "Fri": friLabel, "Sat": satLabel]
        
    }
    @IBAction func habitChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{ //different times
            differentTimes = true
            for day in days!{
                day.isSelected = false
                day.isEnabled = true
            }
            selectSunday()
            
        }else{ //same time everyday
            differentTimes = false
            for day in days!{
                day.isSelected = false
                day.isEnabled = false
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

    @IBAction func dayButtonPressed(_ sender: UIButton) {
        selectedDay = sender
        for day in days!{
            day.isSelected = false
        }
        sender.isSelected = true
    }
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
    
    func selectSunday(){
        for day in days!{ //select sunday at start
            if day.titleLabel?.text == "Sun"{
                day.isSelected = true
                selectedDay = day
                break
            }
        }
    }
    @IBAction func nextPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toMain", sender: self)
    }
}

