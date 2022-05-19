//
//  CoursesViewControllerNEW.swift
//  Studium
//
//  Created by Vikram Singh on 5/18/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class CoursesListViewControllerNEW: StudiumTableViewController{

    var coursesTodayLabel: UILabel = {
        let coursesTodayLabel = UILabel()
        coursesTodayLabel.translatesAutoresizingMaskIntoConstraints = false
        coursesTodayLabel.attributedText = NSAttributedString(string: "Courses Today:", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        coursesTodayLabel.textColor = .white
        return coursesTodayLabel
    }()
    
    var allCoursesLabel: UILabel = {
        let allCoursesLabel = UILabel()
        allCoursesLabel.translatesAutoresizingMaskIntoConstraints = false
        allCoursesLabel.attributedText = NSAttributedString(string: "All Courses:", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)])
        allCoursesLabel.textColor = K.studiumDarkPurple
        return allCoursesLabel
    }()
    
//    var coursesTableView: UITableView = {
//        let coursesTableView = UITableView()
//        coursesTableView.translatesAutoresizingMaskIntoConstraints = false
//        coursesTableView.separatorStyle = .none
//        coursesTableView.backgroundColor = .clear
//        return coursesTableView
//    }()
    
    let headerHeight: CGFloat = 230
//    let sectionHeaders: [String] = ["Today", "Not Today"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSectionHeaders(sectionHeaders: ["Today", "Not Today"])
    }
    
    override func loadView() {
        super.loadView()
        
        //lets our tableview manager class to use Course specific tableview cells
        containsAssignmentsOrEvents = false
//        tableView.delegate = self
//        coursesTableView.dataSource = self
//        coursesTableView.register(CourseCellNEW.self, forCellReuseIdentifier: "CourseCellNEW")
        
        setTitleLabelText(string: "Courses")
        setHeaderHeight(headerHeight: headerHeight)
        
        header.addSubview(coursesTodayLabel)
        view.addSubview(allCoursesLabel)
        view.addSubview(tableView)
    
        //Activate Constraints
        NSLayoutConstraint.activate([
            
            //Courses Today Label Constraints
            coursesTodayLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            coursesTodayLabel.leftAnchor.constraint(equalTo: coursesTodayLabel.superview?.leftAnchor ?? view.leftAnchor, constant: 20),
            coursesTodayLabel.rightAnchor.constraint(equalTo: coursesTodayLabel.superview?.rightAnchor ?? view.rightAnchor, constant: -20),
            coursesTodayLabel.heightAnchor.constraint(equalToConstant: 30),
            
            //All Courses Label Constraints
            allCoursesLabel.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 20),
            allCoursesLabel.leftAnchor.constraint(equalTo: allCoursesLabel.superview?.leftAnchor ?? view.leftAnchor, constant: 20),
            allCoursesLabel.rightAnchor.constraint(equalTo: allCoursesLabel.superview?.rightAnchor ?? view.rightAnchor, constant: -20),
            allCoursesLabel.heightAnchor.constraint(equalToConstant: 30),
            
            //Courses Table View Constraints
            tableView.topAnchor.constraint(equalTo: allCoursesLabel.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: tableView.superview?.leftAnchor ?? view.leftAnchor, constant: 20),
            tableView.rightAnchor.constraint(equalTo: tableView.superview?.rightAnchor ?? view.rightAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: tableView.superview?.bottomAnchor ?? view.bottomAnchor)
        ])
    }
}

//extension CoursesListViewControllerNEW: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let courseCell = tableView.dequeueReusableCell(withIdentifier: "CourseCellNEW", for: indexPath) as! CourseCellNEW
//
//        return courseCell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionHeaders[section]
//    }
//
//}
