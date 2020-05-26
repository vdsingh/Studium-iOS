//
//  AddAssignmentViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/25/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

protocol AssignmentRefreshProtocol { //Used to refresh the course list after we have added a course.
    func loadAssignments()
}

class AddAssignmentViewController: UIViewController{
    
    @IBOutlet weak var coursePicker: UIPickerView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var additionalDetailsTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegates: [AssignmentRefreshProtocol] = [] //reference to the assignment list.
    let realm = try! Realm() //Link to the realm where we are storing information
    
    var courses: Results<Course>? //Auto updating array linked to the realm
    var selectedCourse: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCourses()
        
        
        coursePicker.dataSource = self
        coursePicker.delegate = self
        setDefaultRow()

    }
    
    func loadCourses(){
        courses = realm.objects(Course.self)
    }
    
    func save(assignment: Assignment){
        do{ //adding the assignment to the courses list of assignments
            try realm.write{
                if let course = selectedCourse{
                    course.assignments.append(assignment)
                }else{
                    print("course is nil.")
                }
            }
        }catch{
            print("error appending assignment")
        }
    }
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let newAssignment = Assignment()
        newAssignment.title = titleTextField.text ?? "" //setting assignment properties.
        newAssignment.additionalDetails = additionalDetailsTextField.text ?? ""
        newAssignment.startDate = datePicker.date - (60*60)
        newAssignment.endDate = datePicker.date + (60*60)
        save(assignment: newAssignment)
        
        
        dismiss(animated: true) {
            for delegate in self.delegates{
                delegate.loadAssignments()
                
            }
        }
    }
    
    func setDefaultRow(){
        var row = 0
        if let coursesArr = courses{
            for course in coursesArr{
                print("\(course.name) , \(selectedCourse!.name)")
                if course.name == selectedCourse!.name{
                    print("course picker selected course: \(course.name). row: \(row)")
                    coursePicker.selectRow(row, inComponent: 0, animated: true)
                    break
                }
                row += 1
            }
        }else{
            print("error. courses in AddAssignment is nil")
        }
    }
    
    
}
extension AddAssignmentViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let coursesArr = courses{
            return coursesArr[row].name
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let courseArr = courses{
            selectedCourse = courseArr[row]
        }else{
            print("error in AddAssignment, didSelectRow. courses is nil.")
        }
    }
}

extension AddAssignmentViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let coursesArr = courses{
            return coursesArr.count
        }
        print("error. picker view is returning 0 rows. ")
        return 0
    }
}


