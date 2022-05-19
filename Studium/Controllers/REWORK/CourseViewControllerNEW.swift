//
//  CourseViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/18/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class CourseViewControllerNEW: StudiumTableViewController{
    
    let headerHeight: CGFloat = 230
    static let themeColor: UIColor = UIColor(hexString: "FF9AA2") ?? .red
    
    let background: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = CourseViewControllerNEW.themeColor.withAlphaComponent(0.15)
        return background
    }()
    
    override func viewDidLoad() {
        view.addSubview(background)
        showGradeBreakdown = true
        numSections = 4
        updateSectionHeaders(sectionHeaders: ["", "Incomplete", "Report", "Complete"])
        super.viewDidLoad()
        
//        themeColor.wi
        view.backgroundColor = .white
//        view.backgroundColor =
        header.backgroundColor = CourseViewControllerNEW.themeColor
        
        setHeaderHeight(headerHeight: headerHeight)
        setTitleLabelText(string: "CS325")
//        view.addSubview(gradeBreakdownView)
//        view.addSubview(background)
        activateConstraints()
        
        
    }
    
    func activateConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 20),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            background.leftAnchor.constraint(equalTo: view.leftAnchor),
            background.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
}
