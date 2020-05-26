//
//  DayScheduleViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import CalendarKit
import RealmSwift

class DayScheduleViewController: DayViewController, AssignmentRefreshProtocol {
    let realm = try! Realm()
    var allAssignments: Results<Assignment>?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("day schedule view will appear was called.")
        loadAssignments()
    }
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        var models: [CalendarEvent] = []// Get events (models) from the storage / API
        if let assignmentsArray = allAssignments{
            print(assignmentsArray)
            for assignment in assignmentsArray{
                print("assignment \(assignment)")
                let newAssignmentEvent = CalendarEvent(startDate: assignment.startDate, endDate: assignment.endDate, title: assignment.title, location: assignment.location)
                models.append(newAssignmentEvent)
            }
        }else{
            print("error. allAssignments is nil.")
        }
        print(models)
        var events = [Event]()
        
        for model in models {
            let event = Event()
            event.startDate = model.startDate
            event.endDate = model.endDate
            var info = [model.title, model.location]
            info.append("\(event.startDate.format(with: "HH:mm")) - \(event.endDate.format(with: "HH:mm"))")
            event.text = info.reduce("", {$0 + $1 + "\n"})
            events.append(event)
        }
        return events
    }
    
    func loadAssignments(){
        allAssignments = realm.objects(Assignment.self)
        reloadData()
//        let now = Date()
//        let tomorrow = now + 24*60*60
//        dayView.state?.move(to: tomorrow)
//        dayView.state?.move(to: now)
    }
    
}


