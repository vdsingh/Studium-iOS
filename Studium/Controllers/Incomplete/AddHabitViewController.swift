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
    
    @IBOutlet weak var habitNameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var additionalDetailsTextField: UITextField!
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var fromTimePicker: UIDatePicker!
    @IBOutlet weak var toTimePicker: UIDatePicker!
    
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
        }else{
            fromLabel.text = "From: "
            toLabel.text = "To: "
        }
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        
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
