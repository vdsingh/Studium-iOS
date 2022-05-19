//
//  CoursesViewControllerNEW.swift
//  Studium
//
//  Created by Vikram Singh on 5/18/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class CoursesViewControllerNEW: StudiumViewController{

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
        allCoursesLabel.textColor = UIColor(hexString: "252A80")
        return allCoursesLabel
    }()
    
    var coursesTableView: UITableView = {
        let coursesTableView = UITableView()
        coursesTableView.translatesAutoresizingMaskIntoConstraints = false
        coursesTableView.separatorStyle = .none
        coursesTableView.backgroundColor = .clear
        return coursesTableView
    }()
    
    let headerHeight: CGFloat = 230
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        coursesTableView.delegate = self
        coursesTableView.dataSource = self
        coursesTableView.register(CourseCellNEW.self, forCellReuseIdentifier: "CourseCellNEW")
        
        setTitleLabelText(string: "Courses")
        setHeaderHeight(headerHeight: headerHeight)
        
        header.addSubview(coursesTodayLabel)
        view.addSubview(allCoursesLabel)
        view.addSubview(coursesTableView)
    
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
            coursesTableView.topAnchor.constraint(equalTo: allCoursesLabel.bottomAnchor),
            coursesTableView.leftAnchor.constraint(equalTo: coursesTableView.superview?.leftAnchor ?? view.leftAnchor, constant: 20),
            coursesTableView.rightAnchor.constraint(equalTo: coursesTableView.superview?.rightAnchor ?? view.rightAnchor, constant: -20),
            coursesTableView.bottomAnchor.constraint(equalTo: coursesTableView.superview?.bottomAnchor ?? view.bottomAnchor)
        ])
    }
}

extension CoursesViewControllerNEW: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let courseCell = tableView.dequeueReusableCell(withIdentifier: "CourseCellNEW", for: indexPath) as! CourseCellNEW
        
        return courseCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
