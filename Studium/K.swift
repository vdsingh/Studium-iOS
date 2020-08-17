//
//  K.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

struct K {
    //SEGUES
    static let coursesToAssignmentsSegue = "coursesToAssignments"
    static let coursesToAllSegue = "coursesToAll"
    static let toAddCourseSegue = "toAddCourse"
    static let toCoursesSegue = "toCourses"
    static let toMainSegue = "toMain"
    static let toLoginSegue = "toLogin"
    static let toRegisterSegue = "toRegister"
    static let toCalendarSegue = "toCalendar"
    
    static let sortAssignmentsBy = "name"
    
    static var assignmentNum = 0
    
    static var themeColor: UIColor = .orange
    
    
}

//rules_version = '2';
//service cloud.firestore {
//  match /databases/{database}/documents {
//    match /{document=**} {
//      allow read, write: if
//          request.time < timestamp.date(2020, 7, 1);
//    }
//  }
//}
