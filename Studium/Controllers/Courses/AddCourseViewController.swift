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
    
    //MARK: - IBOutlets
    @IBOutlet weak var addACourseText: UILabel!
    @IBOutlet weak var courseNameText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var additionalDetailsText: UITextField!
    @IBOutlet weak var errorsLabel: UILabel!
    
    @IBOutlet var colors: Array<UIButton>?
    @IBOutlet var days: Array<UIButton>?

    
    var errors: [String] = []
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
        changeBaseColor(with: sender.tintColor)
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
    
    func changeBaseColor(with color: UIColor){
        let newColor = color.darken(byPercentage: 0.3)
        if let daysArr = days{
            for day in daysArr{
                day.tintColor = newColor
            }
        }
        setColorOfPlaceholderText(textField: courseNameText, color: newColor!)
        setColorOfPlaceholderText(textField: locationText, color: newColor!)
        setColorOfPlaceholderText(textField: additionalDetailsText, color: newColor!)
        addACourseText.textColor = newColor
        addButton.tintColor = newColor

    }
    
    func setColorOfPlaceholderText(textField: UITextField, color: UIColor){
        let alphaColor = color.withAlphaComponent(0.5)
        let darkenedColor = color.darken(byPercentage: 0.1)
        if let placeholderText = textField.placeholder{
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: alphaColor])
        }
        
        textField.textColor = darkenedColor
        textField.layer.masksToBounds = true
        textField.layer.borderColor = alphaColor.cgColor
        textField.layer.borderWidth = 1.0
    }
}

