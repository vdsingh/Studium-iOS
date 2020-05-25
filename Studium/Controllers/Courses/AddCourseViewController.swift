//
//  AddCourseViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

protocol CourseRefreshProtocol {
    func loadCourses()
}
class AddCourseViewController: UIViewController{
    var delegate: CourseRefreshProtocol?
    
    let realm = try! Realm() //Link to the realm where we are storing information
    
    @IBOutlet weak var courseNameText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var errorsLabel: UILabel!
    
    var errors: [String] = []
    
    var selectedDays = ["Sun": false,"Mon": false,"Tue": false,"Wed":false,"Thu": false,"Fri": false,"sat": false]
    
    @IBAction func DayButtonPressed(_ sender: UIButton) {
        if(!sender.isSelected){ //user selected this day.
            selectedDays[(sender.titleLabel?.text)!] = true
            sender.isSelected = true
        }else{
            selectedDays[(sender.titleLabel?.text)!] = false
            sender.isSelected = false
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let newCourse = Course()
        newCourse.name = courseNameText.text!
        for (day, dayBool) in selectedDays{
            if dayBool == true {
                newCourse.days.append(day)
                print("\(day) is added")
            }
        }
        save(course: newCourse)
        dismiss(animated: true) {
            if let del = self.delegate{
                del.loadCourses()
            }else{
                print("delegate was not defined.")
            }
        }
    }
    
    
    
    func save(course: Course){
        do{
            try realm.write{
                realm.add(course)
            }
        }catch{
            print(error)
        }
    }
}
