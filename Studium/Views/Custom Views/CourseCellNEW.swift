//
//  CourseCellNEW.swift
//  Studium
//
//  Created by Vikram Singh on 5/18/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class CourseCellNEW: UITableViewCell{
    
    
    static let themeColor: UIColor = UIColor(hexString: "FF9AA2") ?? .red
    
    let background: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.layer.cornerRadius = 20
        background.backgroundColor = themeColor
        
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowOpacity = 1
        background.layer.shadowOffset = CGSize(width: 2, height: 2)
        background.layer.shadowRadius = 4
        
        return background
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.attributedText = NSAttributedString(string: "CS325", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.attributedText = NSAttributedString(string: "11:00 AM - 11:30 AM", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        timeLabel.textColor = .white
        return timeLabel
    }()
    
    let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.attributedText = NSAttributedString(string: "Building A", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        locationLabel.textColor = .white
        return locationLabel
    }()
    
    let textStackView: UIStackView = {
        let textStackView = UIStackView()
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.axis = .vertical
        textStackView.distribution = .fillEqually
        textStackView.alignment = UIStackView.Alignment.leading
        textStackView.spacing = 5
        return textStackView
    }()
    
    let iconBackground: UIView = {
        let iconBackground = UIView()
        iconBackground.translatesAutoresizingMaskIntoConstraints = false
        iconBackground.layer.cornerRadius = 30
        iconBackground.backgroundColor = .white
        return iconBackground
    }()
    
    let icon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(systemName: "pencil")
        icon.tintColor = themeColor
        return icon
    }()
    
    let assignmentNumberLabel: UILabel = {
        let assignmentNumberLabel = UILabel()
        assignmentNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        assignmentNumberLabel.textColor = .white
        assignmentNumberLabel.text = "3"
        assignmentNumberLabel.textAlignment = .center
        assignmentNumberLabel.contentMode = .center
        return assignmentNumberLabel
    }()
    
    let assignmentIcon: UIImageView = {
        let assignmentIcon = UIImageView()
        assignmentIcon.translatesAutoresizingMaskIntoConstraints = false
        assignmentIcon.image = UIImage(systemName: "checkmark.square")
        assignmentIcon.tintColor = .white
        return assignmentIcon
    }()
    
    let daysBackground: UIView = {
        let daysBackground = UIView()
        daysBackground.translatesAutoresizingMaskIntoConstraints = false
        daysBackground.layer.cornerRadius = 10
        daysBackground.backgroundColor = .white
        
        daysBackground.layer.shadowColor = UIColor.black.cgColor
        daysBackground.layer.shadowOpacity = 1
        daysBackground.layer.shadowOffset = CGSize(width: 2, height: 2)
        daysBackground.layer.shadowRadius = 2
        
        return daysBackground
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear

        addViews()
        establishConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addViews(){
        addSubview(background)
        addSubview(daysBackground)
                
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(timeLabel)
        textStackView.addArrangedSubview(locationLabel)
        
        background.addSubview(textStackView)
        background.addSubview(iconBackground)
        background.addSubview(assignmentIcon)
        background.addSubview(assignmentNumberLabel)
        iconBackground.addSubview(icon)
        
    }
    
    func establishConstraints(){
        NSLayoutConstraint.activate([
            
            background.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            background.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            background.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            background.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
            
            iconBackground.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            iconBackground.topAnchor.constraint(equalTo: background.topAnchor, constant: 10),
//            iconBackground.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconBackground.heightAnchor.constraint(equalToConstant: 60),
            iconBackground.widthAnchor.constraint(equalToConstant: 60),
            
            icon.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor),
            icon.heightAnchor.constraint(equalToConstant: 40),
            icon.widthAnchor.constraint(equalToConstant: 40),
            
//            textStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textStackView.topAnchor.constraint(equalTo: background.topAnchor, constant: 10),
            textStackView.leftAnchor.constraint(equalTo: iconBackground.rightAnchor, constant: 10),
            textStackView.heightAnchor.constraint(equalToConstant: 60),
            
            assignmentNumberLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 20),
            assignmentNumberLabel.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -20),
            assignmentNumberLabel.heightAnchor.constraint(equalTo: assignmentIcon.heightAnchor),

            assignmentIcon.rightAnchor.constraint(equalTo: assignmentNumberLabel.leftAnchor, constant: -2),
            assignmentIcon.topAnchor.constraint(equalTo: background.topAnchor, constant: 20),
            assignmentIcon.widthAnchor.constraint(equalToConstant: 25),
            assignmentIcon.heightAnchor.constraint(equalToConstant: 25),
            
            daysBackground.widthAnchor.constraint(equalTo: background.widthAnchor, constant: -12),
            daysBackground.heightAnchor.constraint(equalToConstant: 40),
            daysBackground.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            daysBackground.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: 20)
        ])
    }
}
