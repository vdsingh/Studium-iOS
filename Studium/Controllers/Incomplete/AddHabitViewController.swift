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

protocol HabitRefreshProtocol{
    func loadHabits()
}

class AddHabitViewController: UIViewController{
    let realm = try! Realm()
    var delegate: HabitRefreshProtocol?
    var selectedDays = ["Sun": false,"Mon": false,"Tue": false,"Wed":false,"Thu": false,"Fri": false,"sat": false]
    var errors: [String] = []
    
    @IBOutlet weak var habitNameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var additionalDetailsTextField: UITextField!
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var fromTimePicker: UIDatePicker!
    @IBOutlet weak var toTimePicker: UIDatePicker!
    
    @IBOutlet weak var earlierLaterLabel: UISegmentedControl!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBAction func dateButtonSelected(_ sender: UIButton) {
        if(!sender.isSelected){ //user selected this day.
            selectedDays[(sender.titleLabel?.text)!] = true
            sender.isSelected = true
        }else{
            selectedDays[(sender.titleLabel?.text)!] = false
            sender.isSelected = false
        }
    }
    @IBAction func autoScheduleChanged(_ sender: UISwitch) {
        if sender.isOn{ //schedule during free time
            fromLabel.text = "Try to fit between: "
            toLabel.text = "and: "
            earlierLaterLabel.isHidden = false
        }else{
            fromLabel.text = "From: "
            toLabel.text = "To: "
            earlierLaterLabel.isHidden = true
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        errors = []
        errorLabel.text = ""
        if habitNameTextField.text == ""{
            errors.append("Please specify a name")
        }
        
        var daySelected = false
        for (_, dayBool) in selectedDays{
            if dayBool == true{
                daySelected = true
                break
            }
        }
        
        if daySelected == false{
            errors.append("Please specify at least one day")
        }
        
        if errors.count == 0{
            let newHabit = Habit()
            newHabit.name = habitNameTextField.text!
            newHabit.location = locationTextField.text!
            newHabit.additionalDetails = additionalDetailsTextField.text!
            for (day, dayBool) in selectedDays{ //specify course days
                if dayBool == true {
                    newHabit.days.append(day)
                }
            }
            save(habit: newHabit)
            delegate?.loadHabits()
            
            dismiss(animated: true) {
                if let del = self.delegate{
                    del.loadHabits()
                }else{
                    print("delegate was not defined.")
                }
            }
        }else{
            var addedFirstError = false
            errorLabel.text?.append(errors[0])
            for error in errors{
                if addedFirstError{
                    errorLabel.text?.append(", \(error)")
                }
                addedFirstError = true
            }
        }
    }
    
    func save(habit: Habit){
        do{
            try realm.write{
                realm.add(habit)
            }
        }catch{
            print(error)
        }
    }
}
