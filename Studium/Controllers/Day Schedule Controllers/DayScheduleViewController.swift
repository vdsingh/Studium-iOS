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

class DayScheduleViewController: DayViewController {
    let realm = try! Realm()
    var allAssignments: Results<Assignment>?
    var allCourses: Results<Course>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAssignments()
        loadCourses()
    }
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        var models: [CalendarEvent] = []// Get events (models) from the storage / API
        models = models + addBasedOnDay(onDate: date)
        if let assignmentsArray = allAssignments{
            for assignment in assignmentsArray{
                let newAssignmentEvent = CalendarEvent(startDate: assignment.startDate, endDate: assignment.endDate, title: assignment.title, location: "")
                models.append(newAssignmentEvent)
            }
        }else{
           print("error. allAssignments is nil.")
        }
//        if let coursesArray = allCourses{
//            for course in coursesArray{
//                let newCourseEvent = CalendarEvent(startDate: assignment.startDate, endDate: assignment.endDate, title: assignment.title, location: "")
//                models.append(newCourseEvent)
//            }
//        }else{
//           // print("error. allAssignments is nil.")
//        }
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
    }
    
    func loadCourses(){
        allCourses = realm.objects(Course.self)
        reloadData()
    }
    
    
    
    func separateCoursesHelper(dayStringIdentifier: String) -> [Course]{
        var daysArray:[Course] = []
        if let coursesArr = allCourses{
            for course in coursesArr{
                if course.days.firstIndex(of: dayStringIdentifier) != -1{ //course occurs on this day.
                    daysArray.append(course)
                }
            }
        }
        return daysArray
    }
    
    func addBasedOnDay(onDate date: Date) -> [CalendarEvent]{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: date) //get weekday name. ex: "Tuesday"
        
        let usableString = weekDay.substring(toIndex: 3)//transform it to a usable string. ex: "Tuesday" to "Tue"
        

        let allCoursesOnDay = separateCoursesHelper(dayStringIdentifier: usableString) //get all courses that occur on this day.
        
        var events: [CalendarEvent] = []
        for course in allCoursesOnDay{
            
            let startDate = Calendar.current.date(bySettingHour: course.startTimeHour, minute: course.startTimeMinute, second: 0, of: date)!
            let endDate = Calendar.current.date(bySettingHour: course.endTimeHour, minute: course.endTimeMinute, second: 0, of: date)!

            let newEvent = CalendarEvent(startDate: startDate, endDate: endDate, title: "\(course.name) Lecture", location: course.location)
            events.append(newEvent)
        }

        return events
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func separateCourses() -> [[Course]]{
        var sunCourses: [Course] = []
        var monCourses: [Course] = []
        var tueCourses: [Course] = []
        var wedCourses: [Course] = []
        var thuCourses: [Course] = []
        var friCourses: [Course] = []
        var satCourses: [Course] = []
                
        sunCourses = separateCoursesHelper(dayStringIdentifier: "Sun")
        monCourses = separateCoursesHelper(dayStringIdentifier: "Mon")
        tueCourses = separateCoursesHelper(dayStringIdentifier: "Tue")
        wedCourses = separateCoursesHelper(dayStringIdentifier: "Wed")
        thuCourses = separateCoursesHelper(dayStringIdentifier: "Thu")
        friCourses = separateCoursesHelper(dayStringIdentifier: "Fri")
        satCourses = separateCoursesHelper(dayStringIdentifier: "Sat")

        
        print("monday Courses: \(monCourses)")
        print(tueCourses)
        print(wedCourses)
        
        return [sunCourses, monCourses, tueCourses, wedCourses, thuCourses, friCourses, satCourses]
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

    



