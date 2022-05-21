//
//  BreakdownSectionTableViewCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/21/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
class BreakdownSectionTableViewCell: UITableViewCell{
    static let sectionColor = K.studiumStandardPurple
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.attributedText = NSAttributedString(string: "Homework:", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
//        titleLabel.text = "Homework"
        titleLabel.textColor = BreakdownSectionTableViewCell.sectionColor
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    var percentageLabel: UILabel = {
        let percentageLabel = UILabel()
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
//        percentageLabel.text = "98%"
        percentageLabel.attributedText = NSAttributedString(string: "98%", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        percentageLabel.textColor = .green
        percentageLabel.textAlignment = .right
        return percentageLabel
    }()
    
    var backgroundBar: UIView = {
        let backgroundBar = UIView()
        backgroundBar.translatesAutoresizingMaskIntoConstraints = false
        backgroundBar.backgroundColor = .gray
        backgroundBar.layer.cornerRadius = 5
        return backgroundBar
    }()
    
    var gradeBar: UIView = {
        let gradeBar = UIView()
        gradeBar.translatesAutoresizingMaskIntoConstraints = false
        gradeBar.backgroundColor = BreakdownSectionTableViewCell.sectionColor
        gradeBar.layer.cornerRadius = 5
        return gradeBar
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear

        addViews()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addViews(){
        addSubview(titleLabel)
        addSubview(percentageLabel)
        addSubview(backgroundBar)
        addSubview(gradeBar)
    }
    
    func activateConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            
            percentageLabel.topAnchor.constraint(equalTo: topAnchor),
            percentageLabel.leftAnchor.constraint(equalTo: leftAnchor),
            percentageLabel.rightAnchor.constraint(equalTo: rightAnchor),
        
            backgroundBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            backgroundBar.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundBar.rightAnchor.constraint(equalTo: rightAnchor),
            backgroundBar.heightAnchor.constraint(equalToConstant: 12),
            
            gradeBar.topAnchor.constraint(equalTo: backgroundBar.topAnchor),
            gradeBar.leftAnchor.constraint(equalTo: backgroundBar.leftAnchor),
            gradeBar.rightAnchor.constraint(equalTo: backgroundBar.rightAnchor, constant: -10),
            gradeBar.heightAnchor.constraint(equalToConstant: 12),
        ])
    }
    
    
}
