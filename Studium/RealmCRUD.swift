//
//  RealmSave.swift
//  Studium
//
//  Created by Vikram Singh on 5/22/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCRUD{
    static func saveAssignment(assignment: Assignment, parentCourse: Course){
        print("just about to save")
        guard let user = K.app.currentUser else {
            print("Error getting user when saving Assignment")
            return
        }
        let realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
        do{ //adding the assignment to the courses list of assignments
            try realm.write{
//                print("Parent Course: \(assignment.parentCourse)")
//                print("assignment name: \(assignment.name)")
//                if let course = assignment.parentCourse{
//                if let course = assignment.tempCourse{
//                    course.assignments.append(assignment)
//                    print("appended assignment to course")
//                }else{
//                    print("course is nil when saving Assignment.")
//                }
                parentCourse.assignments.append(assignment)
            }
        }catch{
            print("error appending assignment")
        }
    }
    
    //saves the new course to the Realm database.
    static func saveCourse(course: Course){
        guard let user = K.app.currentUser else {
            print("Error getting user")
            return
        }
        let realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
        do{
            try realm.write{
                realm.add(course)
                print("the user id is: \(user.id)")
                print("saved course with partitionKey: \(course._partitionKey)")
            }
        }catch{
            print("error saving course: \(error)")
        }
    }
    
    static func saveHabit(habit: Habit){
        guard let user = K.app.currentUser else {
            print("Error getting user")
            return
        }
        let realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
        do{
            try realm.write{
                realm.add(habit)
            }
        }catch{
            print("error saving course: \(error)")
        }
    }
    
    static func saveOtherEvent(otherEvent: OtherEvent){
        guard let user = K.app.currentUser else {
            print("Error getting user")
            return
        }
        let realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
        do{
            try realm.write{
                realm.add(otherEvent)
            }
        }catch{
            print("error saving course: \(error)")
        }
    }
}
