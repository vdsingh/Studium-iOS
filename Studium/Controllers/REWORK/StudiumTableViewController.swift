//
//  StudiumTableViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/19/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit


//this class is used for any view controllers that have a tableview which contains either Courses, Habits, Assignments, or Other Events.
class StudiumTableViewController: StudiumViewController{
    
    var sectionHeaders: [String] = ["Section 1", "Section 2"]
    var numSections: Int = 2
    
    
    var showGradeBreakdown: Bool = false
    var containsAssignmentsOrEvents: Bool = true
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventCellNEW.self, forCellReuseIdentifier: "EventCell")
        tableView.register(CourseCellNEW.self, forCellReuseIdentifier: "CourseCell")
        tableView.register(GradeBreakdownView.self, forCellReuseIdentifier: "GradeBreakdownCell")

    }
    
    func updateSectionHeaders(sectionHeaders: [String]){
        self.sectionHeaders = sectionHeaders
        tableView.reloadData()
    }
}

extension StudiumTableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(showGradeBreakdown && section == 0){
            return 1
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(showGradeBreakdown && indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "GradeBreakdownCell") as! GradeBreakdownView
            cell.selectionStyle = .none
            return cell
        }
        if (containsAssignmentsOrEvents){
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCellNEW
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell") as! CourseCellNEW
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(showGradeBreakdown && indexPath.section == 0){
            return 180
        }
        if(containsAssignmentsOrEvents){
            return 90
        }else{
            return 150
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        if(showGradeBreakdown){
//            return 3
//        }
//        return 2
        
        return numSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if(showGradeBreakdown && section == 0){
//            return ""
//        }
//        if (showGradeBreakdown){
//            return sectionHeaders[section - 1]
//        }
        return sectionHeaders[section]
    }
}
