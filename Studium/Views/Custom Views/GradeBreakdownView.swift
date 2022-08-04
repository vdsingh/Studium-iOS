//
//  GradeBreakdownView.swift
//  Studium
//
//  Created by Vikram Singh on 5/18/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
class GradeBreakdownView: UITableViewCell{
    var background: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = .white
        background.layer.cornerRadius = 30
        
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowOpacity = 1
        background.layer.shadowOffset = CGSize(width: 2, height: 2)
        background.layer.shadowRadius = 4
        
        return background
    }()
    
    var piChart: UIView = {
        let piChart = UIView()
        piChart.translatesAutoresizingMaskIntoConstraints = false
        piChart.backgroundColor = .green
        piChart.layer.cornerRadius = 50
        return piChart
    }()
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.attributedText = NSAttributedString(string: "Grade Breakdown:", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        titleLabel.textColor = K.studiumDarkPurple
        return titleLabel
    }()
    
    var gradePercent: UILabel = {
        let gradePercent = UILabel()
        gradePercent.translatesAutoresizingMaskIntoConstraints = false
        gradePercent.textColor = UIColor.flatGreen()
        gradePercent.attributedText = NSAttributedString(string: "98%", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)])
        return gradePercent
    }()
    
    var breakdownTableView: UITableView = {
        let breakdownTableView = UITableView()
        breakdownTableView.translatesAutoresizingMaskIntoConstraints = false
        breakdownTableView.register(BreakdownSectionTableViewCell.self, forCellReuseIdentifier: "BreakdownSectionTableViewCell")
        breakdownTableView.separatorStyle = .none
        breakdownTableView.backgroundColor = .clear
        
        return breakdownTableView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear

        addViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addViews()

    }
    
    func addViews(){
        
        addSubview(background)
        background.addSubview(titleLabel)
        background.addSubview(piChart)
        
        background.addSubview(breakdownTableView)
        breakdownTableView.dataSource = self
        breakdownTableView.delegate = self
        
        background.addSubview(gradePercent)
        
        activateConstraints()
        
    }
    
    func activateConstraints(){
        
        NSLayoutConstraint.activate([
            
            //Background Constraints
            background.leftAnchor.constraint(equalTo: leftAnchor),
            background.rightAnchor.constraint(equalTo: rightAnchor),
            background.topAnchor.constraint(equalTo: topAnchor),
            background.heightAnchor.constraint(equalToConstant: 160),

            
            //Title Label Constraints
            titleLabel.leftAnchor.constraint(equalTo: superview?.leftAnchor ?? background.leftAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: superview?.topAnchor ?? background.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            gradePercent.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 20),
            gradePercent.topAnchor.constraint(equalTo: gradePercent.superview?.topAnchor ?? background.topAnchor, constant: 10),
            
            //Pi Chart Constraints
            piChart.leftAnchor.constraint(equalTo: superview?.leftAnchor ?? background.leftAnchor, constant: 20),
            piChart.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            piChart.widthAnchor.constraint(equalToConstant: 100),
            piChart.heightAnchor.constraint(equalToConstant: 100),
            
            //Grade Breakdown TableView Constraints
            breakdownTableView.leftAnchor.constraint(equalTo: piChart.rightAnchor, constant: 20),
            breakdownTableView.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -20),
            breakdownTableView.heightAnchor.constraint(equalToConstant: 100),
            breakdownTableView.centerYAnchor.constraint(equalTo: piChart.centerYAnchor),
        ])
    }
}

extension GradeBreakdownView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let breakdownSectionCell = tableView.dequeueReusableCell(withIdentifier: "BreakdownSectionTableViewCell") as! BreakdownSectionTableViewCell
        
        return breakdownSectionCell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}
