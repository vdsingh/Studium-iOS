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
    let defaults = UserDefaults.standard
    
    var allAssignments: Results<Assignment>?
    var allCourses: Results<Course>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAssignments()
        loadCourses()
    }

    @IBAction func timeControlChanged(_ sender: UISegmentedControl) {
        performSegue(withIdentifier: "toCalendar", sender: self)
    }
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        var models: [CalendarEvent] = []
        models = models + addCoursesBasedOnDay(onDate: date)
        models = models + addAssignments()
        models = models + addWakeTimes(onDate: date)
        
        models = models + addHabits(onDate: date, withEvents: models)
        
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
    
    func addAssignments() -> [CalendarEvent]{
        var newArr: [CalendarEvent] = []
        if let assignmentsArray = allAssignments{
            for assignment in assignmentsArray{
                let newAssignmentEvent = CalendarEvent(startDate: assignment.startDate, endDate: assignment.endDate, title: assignment.name, location: "")
                newArr.append(newAssignmentEvent)
            }
        }else{
            print("error. allAssignments is nil.")
        }
        return newArr
    }
    
    func separateCoursesHelper(dayStringIdentifier: String) -> [Course]{
        var daysArray:[Course] = []
        if let coursesArr = allCourses{
            for course in coursesArr{

                if course.days.contains(dayStringIdentifier){ //course occurs on this day.
                    daysArray.append(course)
                }
            }
        }
        return daysArray
    }
    
    func addCoursesBasedOnDay(onDate date: Date) -> [CalendarEvent]{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: date) //get weekday name. ex: "Tuesday"
        
        let usableString = weekDay.substring(toIndex: 3)//transform it to a usable string. ex: "Tuesday" to "Tue"
        let allCoursesOnDay = separateCoursesHelper(dayStringIdentifier: usableString) //get all courses that occur on this day.
        var events: [CalendarEvent] = []
        for course in allCoursesOnDay{
            var components = Calendar.current.dateComponents([.hour, .minute], from: course.startTime)
            let startDate = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute ?? 0, second: 0, of: date)!
            
            components = Calendar.current.dateComponents([.hour, .minute], from: course.endTime)
            
            
            let endDate = Calendar.current.date(bySettingHour: components.hour ?? 0, minute: components.minute ?? 0, second: 0, of: date)!
            
            let newEvent = CalendarEvent(startDate: startDate, endDate: endDate, title: "\(course.name) Lecture", location: course.location)
            events.append(newEvent)
        }
        
        return events
    }
    
    func addWakeTimes(onDate date: Date) -> [CalendarEvent]{
        var allEvents: [CalendarEvent] = []
        let wakeTimeDictionary = ["Sun": defaults.array(forKey: "sunWakeUp")![0] as! Date, "Mon": defaults.array(forKey: "monWakeUp")![0] as! Date, "Tue": defaults.array(forKey: "tueWakeUp")![0] as! Date, "Wed": defaults.array(forKey: "wedWakeUp")![0] as! Date, "Thu": defaults.array(forKey: "thuWakeUp")![0] as! Date, "Fri": defaults.array(forKey: "friWakeUp")![0] as! Date, "Sat": defaults.array(forKey: "satWakeUp")![0] as! Date]

        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: date) //get weekday name. ex: "Tuesday"
        let usableString = weekDay.substring(toIndex: 3)
        let timeToWake = wakeTimeDictionary[usableString]!
        
        let hour = calendar.component(.hour, from: timeToWake)
        let minutes = calendar.component(.minute, from: timeToWake)
        let usableDate = Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: date)!

        dateFormatter.dateFormat = "h:mm a"
        let formattedTime = dateFormatter.string(from: timeToWake)
        
        let anHourAgo = usableDate - (60*60)
        let newEvent = CalendarEvent(startDate: anHourAgo, endDate: usableDate, title: "Wake Up: \(formattedTime)", location: "")

        allEvents.append(newEvent)
        return allEvents
    }
    
    func addHabits(onDate: Date, withEvents: [CalendarEvent]) -> [CalendarEvent]{//algorithm to find right time based on pre-existing events.
        var habits: [CalendarEvent] = []
        
        return habits
    }
}

extension String { //string extension for subscript access.
    
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





