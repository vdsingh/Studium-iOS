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
    let realm = try! Realm()
    
    var allEventsInDay: [StudiumEvent] = []
    var selectedDay: Date = Date()
    override func viewDidLoad() {
        //print("calendar viewdidload was called.")
        super.viewDidLoad()


        tableView.delegate = self
//        calendar.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateInfo()
        calendar.appearance.titleDefaultColor = UIColor.white
        navigationItem.hidesBackButton = true

        
    }
    
    @IBAction func timeControlChanged(_ sender: UISegmentedControl) {
        
        self.navigationController?.popViewController(animated: false)

    }
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
        
        let weekDay = dateFormatter.string(from: selectedDay)
        let matchingStr = weekDay.substring(toIndex: 3)
        for course in allCourses{
            for day in course.days{ //day is in form "Mon"
                if day == matchingStr{
                    allEventsInDay.append(course)
                }
            }
        }
    }
    
    func updateInfo(){
        allEventsInDay = []
        addAssignments()
        addCourses()
        allEventsInDay = allEventsInDay.sorted(by: { $0.startDate < $1.startDate })

        tableView.reloadData()
    }
}

extension CalendarViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  "Cell", for: indexPath)
        let correspondingEvent = allEventsInDay[indexPath.row]
        cell.textLabel?.text = correspondingEvent.name
        return cell
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
