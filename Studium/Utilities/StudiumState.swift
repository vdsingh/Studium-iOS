//
//  StudiumState.swift
//  Studium
//
//  Created by Vikram Singh on 8/17/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
class StudiumState {
    public static var state = StudiumState()
    
    private let app = App(id: Secret.appID)
    
    private lazy var realm: Realm? = {
        guard let user = user else {
            print("$ ERROR: User is nil.")
            return nil
        }
        return try! Realm(configuration: user.configuration(partitionValue: user.id))
    }()
    
    public lazy var user: RLMUser? = {
        guard let user = K.app.currentUser else {
            print("$ ERROR: Error getting user when saving Assignment")
            return nil
        }
        return user
    }()
    
    private var courses: [Course] = []
    private var habits: [Habit] = []
    private var otherEvents: [OtherEvent] = []
    private var assignments: [Assignment] = []
    
    // MARK: - GETTERS
    public func getCourses() -> [Course] {
        return courses
    }
    
    public func getHabits() -> [Habit] {
        return habits
    }
    
    public func getOtherEvents() -> [OtherEvent] {
        return otherEvents
    }
    
    public func getAssignments() -> [Assignment] {
        return assignments
    }
    
    public func updateCourses() {
        guard let realm = realm else {
            print("$ ERROR: realm is nil.\n File: \(#file)\nFunction: \(#function)\nLine: \(#line)")
            return
        }

        let coursesResult = realm.objects(Course.self)
        for course in coursesResult {
            courses.append(course)
        }
        
        courses.sort(by: {$0.startDate.format(with: "HH:mm") < $1.startDate.format(with: "HH:mm")})
    }
    
    public func updateHabits() {
        
    }
    
    public func updateOtherEvents() {
        
    }
    
    public func updateAssignments() {
        
    }
    
}
