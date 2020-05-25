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
    var delegate: AssignmentRefreshProtocol? //reference to the course list.
    let realm = try! Realm() //Link to the realm where we are storing information
    
    
}

