//
//  ViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import FSCalendar

//TODO: Docstrings
class CalendarViewController: UIViewController, Storyboarded {
    
    weak var coordinator: CalendarCoordinator?
    
    let databaseService: DatabaseServiceProtocol! = DatabaseService.shared
    
    //TODO: Docstrings
    @IBOutlet weak var calendar: FSCalendar!
    
    //TODO: Docstrings
    @IBOutlet weak var tableView: UITableView!
    
    var noEventsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Events"
        label.font = StudiumFont.placeholder.uiFont
        label.textColor = StudiumFont.placeholder.uiColor
        return label
    }()
    
    //TODO: Docstrings
    var allEventsInDay: [StudiumEvent] = []
    
    //TODO: Docstrings
    var selectedDay: Date = Date()
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(self.noEventsLabel)
        
        NSLayoutConstraint.activate([
            self.noEventsLabel.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
            self.noEventsLabel.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor),

        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = StudiumColor.background.uiColor
        
        self.calendar.backgroundColor = StudiumColor.background.uiColor
        self.tableView.backgroundColor = StudiumColor.secondaryBackground.uiColor

        self.calendar.appearance.weekdayTextColor = StudiumColor.primaryLabel.uiColor
        self.calendar.appearance.headerTitleColor = StudiumColor.primaryLabel.uiColor
        
        self.calendar.appearance.titleTodayColor = StudiumColor.primaryAccent.uiColor
        self.calendar.appearance.selectionColor = StudiumColor.primaryAccent.uiColor
        self.calendar.appearance.todayColor = self.calendar.backgroundColor
        
        
        self.navigationController?.navigationBar.tintColor = StudiumColor.primaryAccent.uiColor
        self.navigationController?.navigationBar.backgroundColor = StudiumColor.background.uiColor
        
        
        
        //TableView Related Stuff:
        self.tableView.register(UINib(nibName: OtherEventCell.id, bundle: nil), forCellReuseIdentifier: OtherEventCell.id)
//        self.tableView.register(UINib(nibName: AssignmentCell1.id, bundle: nil), forCellReuseIdentifier: AssignmentCell1.id)

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateInfo()
        calendar.appearance.titleDefaultColor = StudiumColor.primaryLabel.uiColor
        navigationItem.hidesBackButton = true
    }
    
    //TODO: Docstrings
    @IBAction func dayButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func timeControlChanged(_ sender: UISegmentedControl) {
//
//        self.navigationController?.popViewController(animated: false)
//
//    }
    
    //TODO: Docstrings
    func addAssignments(){
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        let allAssignments = self.databaseService.getStudiumObjects(expecting: Assignment.self)
        for assignment in allAssignments {
            
            let assignmentDate = dateFormatter.string(from: assignment.startDate)
            let selected = dateFormatter.string(from: selectedDay)
            if assignmentDate == selected {
                allEventsInDay.append(assignment)
            }
        }
    }
    
    //TODO: Docstrings
    func addCourses(){
        let allCourses = self.databaseService.getStudiumObjects(expecting: Course.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
//        let weekDay = dateFormatter.string(from: selectedDay)
//        let weekDay = selectedDay.weekday
//        let matchingStr = weekDay.substring(toIndex: 3)
        for course in allCourses {
            if(course.days.contains(selectedDay.weekdayValue)){
                allEventsInDay.append(course)
            }
//            for day in course.days{ //day is in form "Mon"
//                if day == matchingStr{
//                    allEventsInDay.append(course)
//                }
//            }
        }
    }
    
    //TODO: Docstrings
    func addHabits(){
        let allHabits = self.databaseService.getStudiumObjects(expecting: Habit.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        for habit in allHabits{
            if(habit.days.contains(selectedDay.weekdayValue)){
                allEventsInDay.append(habit)
            }
        }
    }
    
    //TODO: Docstrings
    func updateInfo(){
        self.allEventsInDay = []
        self.addAssignments()
        self.addCourses()
        self.addHabits()
        self.allEventsInDay = self.allEventsInDay.sorted(by: { $0.startDate < $1.startDate })
        self.tableView.reloadData()
        self.noEventsLabel.isHidden = !allEventsInDay.isEmpty
    }
}

//TODO: Docstrings
extension CalendarViewController: UITableViewDelegate {
    
    //TODO: Docstrings
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event: StudiumEvent = allEventsInDay[indexPath.row]
        if let assignment = event as? Assignment {
            let cell = AssignmentTableViewCell(assignment: assignment, isExpanded: false, assignmentCollapseHandler: self, checkboxWasTapped: {
                // FIXME: check if this is needed
            })

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:  OtherEventCell.id, for: indexPath) as! OtherEventCell
            cell.loadDataGeneric(
                primaryText: event.name,
                secondaryText: event.location,
                startDate: event.startDate,
                endDate: event.endDate,
                cellColor: event.color
            )
            cell.hideLatenessIndicator(hide: true)

            return cell
        }
    }
    
    //TODO: Docstrings
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //TODO: Docstrings
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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

// TODO: Investigate and lint
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

// FIXME: Investigate and lint
extension CalendarViewController: AssignmentCollapseDelegate {
    func collapseButtonClicked(assignment: Assignment) {
        
    }
}
