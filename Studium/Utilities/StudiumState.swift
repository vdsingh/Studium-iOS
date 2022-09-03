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
    
    var courses: [Course] = []
    var habits: [Habit] = []
    var otherEvents: [OtherEvent] = []
    var assignments: [Assignment] = []
    
    public func getCourses() -> [Course] {
        return courses
    }
    
    public func updateCourses() {
//        realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
//        courses = realm.objects(Course.self)
    }
    
    public func updateHabits() {
        
    }
    
    public func updateOtherEvents() {
        
    }
    
    public func updateAssignments() {
        
    }
    
}
