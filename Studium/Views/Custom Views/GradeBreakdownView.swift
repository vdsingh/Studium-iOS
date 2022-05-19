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
        breakdownTableView.backgroundColor = .orange
        return breakdownTableView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear

        addViews()
//        establishConstraints()
//        addDayLabels()
    }
//
//    init(){
//        super.init(frame: .zero)
//        addViews()
//    }
    
//    override init(frame: CGRect){
//        super.init(frame: frame)
//        addViews()
//    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addViews()

    }
    
    func addViews(){
        
        addSubview(background)
        background.addSubview(titleLabel)
        background.addSubview(piChart)
        background.addSubview(breakdownTableView)
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
//            background.bottomAnchor.constraint(equalTo: bottomAnchor),
//            background.heightAnchor.constraint(equalToConstant: 100),

            
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
            
            breakdownTableView.leftAnchor.constraint(equalTo: piChart.rightAnchor, constant: 20),
            breakdownTableView.heightAnchor.constraint(equalToConstant: 100),
            breakdownTableView.centerYAnchor.constraint(equalTo: piChart.centerYAnchor),
        
        ])
    }
    
}
