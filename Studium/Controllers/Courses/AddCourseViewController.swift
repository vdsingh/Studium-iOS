//
//  AddCourseViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift
import Colorful

protocol CourseRefreshProtocol { //Used to refresh the course list after we have added a course.
    func loadCourses()
}

class AddCourseViewController: UIViewController{
    var delegate: CourseRefreshProtocol? //reference to the course list.
    
    let realm = try! Realm() //Link to the realm where we are storing information
    
    @IBOutlet weak var courseNameText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var errorsLabel: UILabel!
    
    var errors: [String] = []
    
    @IBOutlet var colors: Array<UIButton>?
    var selectedColor: UIColor?
    
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
    
    
    @IBAction func colorButtonPressed(_ sender: UIButton) {
        selectedColor = sender.tintColor
        if let colorArray = colors{
            for color in colorArray{
                color.setImage(UIImage(systemName: "square"), for: .normal)
            }
        }
        sender.setImage(UIImage(systemName: "square.fill"), for: .normal)
    }
    @IBAction func addButtonPressed(_ sender: UIButton) {
        errors.removeAll()
        errorsLabel.text = ""
        if(courseNameText.text == ""){
            errors.append("Enter a course name")
        }
        
        if(selectedColor == nil){
            errors.append("Please specify a color")
        }
        updateErrorText()
        if(errors.count == 0){
            let newCourse = Course()
            newCourse.name = courseNameText.text! //specify course name
            newCourse.color = selectedColor!.hexValue() //specify course color
            for (day, dayBool) in selectedDays{ //specify course days
                if dayBool == true {
                    newCourse.days.append(day)
                    print("\(day) is added")
                }
            }
            save(course: newCourse) //save course and attributes to database.
            dismiss(animated: true) {
                if let del = self.delegate{
                    del.loadCourses()
                }else{
                    print("delegate was not defined.")
                }
            }
        }
    }
    //        let colorPicker = ColorPicker(frame: ...)
    //        colorPicker.addTarget(self, action: #selector(...), for: .valueChanged)
    //        colorPicker.set(color: .red, colorSpace: .extendedSRGB)
    //        view.add(subview: colorPicker)
    
    
    func save(course: Course){
        do{
            try realm.write{
                realm.add(course)
            }
        }catch{
            print(error)
        }
    }
    
    func updateErrorText(){
        var count = 0
        for error in errors{
            if count == 0{
                errorsLabel.text?.append("\(error)")

            }else{
             errorsLabel.text?.append(", \(error)")
            }
            count += 1
        }
    }
}
