//
//  ViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift
import FSCalendar

class CalendarViewController: UIViewController{
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    var realm: Realm!
    let app = App(id: Secret.appID)

    
    var allEventsInDay: [StudiumEvent] = []
    var selectedDay: Date = Date()
    override func viewDidLoad() {
        //print("calendar viewdidload was called.")
        super.viewDidLoad()
        guard let user = app.currentUser else {
            print("Error getting user in MasterForm")
            return
        }
        realm = try! Realm(configuration: user.configuration(partitionValue: user.id))

        calendar.appearance.weekdayTextColor = .label
//        calendar.appearance.headerTitleFont = headert
        
        calendar.appearance.headerTitleColor = .label
        
        
        //TableView Related Stuff:
//        tableView.register(UINib(nibName: K.assignmentCellID, bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: K.genericCellID, bundle: nil), forCellReuseIdentifier: K.genericCellID)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateInfo()
        calendar.appearance.titleDefaultColor = UIColor.white
//        navigationItem.hidesBackButton = true

        
    }
    @IBAction func dayButtonPressed(_ sender: Any) {
        print("dayButtonPRessed.")
        self.navigationController?.popViewController(animated: false)
    }
    
//    @IBAction func timeControlChanged(_ sender: UISegmentedControl) {
//
//        self.navigationController?.popViewController(animated: false)
//
//    }
    func addAssignments(){
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        let allAssignments = realm.objects(Assignment.self)
        for assignment in allAssignments{
            
            let assignmentDate = dateFormatter.string(from: assignment.startDate)
            let selected = dateFormatter.string(from: selectedDay)
            if assignmentDate == selected{
                allEventsInDay.append(assignment)
            }
        }
    }
    
    func addCourses(){
        let allCourses = realm.objects(Course.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
//        let weekDay = dateFormatter.string(from: selectedDay)
//        let weekDay = selectedDay.weekday
//        let matchingStr = weekDay.substring(toIndex: 3)
        for course in allCourses{
            if(course.days.contains(selectedDay.weekday)){
                allEventsInDay.append(course)
            }
//            for day in course.days{ //day is in form "Mon"
//                if day == matchingStr{
//                    allEventsInDay.append(course)
//                }
//            }
        }
    }
    
    //This will do courses and habits at the same time.
    func addHabits(){
        let allHabits = realm.objects(Habit.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        for habit in allHabits{
            if(habit.days.contains(selectedDay.weekday)){
                allEventsInDay.append(habit)
            }
        }
    }
    
    func updateInfo(){
        allEventsInDay = []
        addAssignments()
        addCourses()
        addHabits()
        allEventsInDay = allEventsInDay.sorted(by: { $0.startDate < $1.startDate })

        tableView.reloadData()
    }
}

extension CalendarViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  K.genericCellID, for: indexPath) as! GenericTableViewCell
        let correspondingEvent: StudiumEvent = allEventsInDay[indexPath.row]
//        cell.loadData(assignment: correspondingEvent)
        cell.loadData(event: correspondingEvent)
//        cell.textLabel?.text = correspondingEvent.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension CalendarViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEventsInDay.count
    }
}

extension CalendarViewController: FSCalendarDataSource{
//        func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//            let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
//            return cell
//        }
    
//        func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
//            self.configure(cell: cell, for: date, at: position)
//        }
}

extension CalendarViewController: FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDay = date
        updateInfo()
        
        
    }
}
