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
        titleLabel.attributedText = NSAttributedString(string: "CS325", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)])
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.attributedText = NSAttributedString(string: "11:00 AM - 11:30 AM", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        timeLabel.textColor = .white
        return timeLabel
    }()
    
    let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.attributedText = NSAttributedString(string: "Building A", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        locationLabel.textColor = .white
        return locationLabel
    }()
    
    let textStackView: UIStackView = {
        let textStackView = UIStackView()
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.axis = .vertical
        textStackView.distribution = .fillProportionally
        textStackView.alignment = UIStackView.Alignment.leading
        textStackView.spacing = 5
        return textStackView
    }()
    
    let iconBackground: UIView = {
        let iconBackground = UIView()
        iconBackground.translatesAutoresizingMaskIntoConstraints = false
        iconBackground.layer.cornerRadius = 35
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
        assignmentNumberLabel.attributedText = NSAttributedString(string: "3", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.white])
//        assignmentNumberLabel.textColor = .white
//        assignmentNumberLabel.text = "3"
        assignmentNumberLabel.textAlignment = .center
        assignmentNumberLabel.contentMode = .center
        return assignmentNumberLabel
    }()
    
    let assignmentIcon: UIImageView = {
        let assignmentIcon = UIImageView()
        assignmentIcon.translatesAutoresizingMaskIntoConstraints = false
        assignmentIcon.image = UIImage(systemName: "checkmark.square")
        assignmentIcon.tintColor = .white
//        assignmentIcon.tintColor.setStroke(
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
        addDayLabels()
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
        let mainDistanceFromTop: CGFloat = 10
        NSLayoutConstraint.activate([
            
            background.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            background.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            background.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            background.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            
            iconBackground.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            iconBackground.topAnchor.constraint(equalTo: background.topAnchor, constant: 10),
//            iconBackground.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconBackground.heightAnchor.constraint(equalToConstant: 70),
            iconBackground.widthAnchor.constraint(equalToConstant: 70),
            
            icon.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor),
            icon.heightAnchor.constraint(equalToConstant: 40),
            icon.widthAnchor.constraint(equalToConstant: 40),
            
//            textStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textStackView.topAnchor.constraint(equalTo: background.topAnchor, constant: mainDistanceFromTop),
            textStackView.leftAnchor.constraint(equalTo: iconBackground.rightAnchor, constant: 10),
            textStackView.heightAnchor.constraint(equalToConstant: 70),
            
            assignmentNumberLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: mainDistanceFromTop),
            assignmentNumberLabel.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -20),
            assignmentNumberLabel.heightAnchor.constraint(equalTo: assignmentIcon.heightAnchor),

            assignmentIcon.rightAnchor.constraint(equalTo: assignmentNumberLabel.leftAnchor, constant: -2),
            assignmentIcon.topAnchor.constraint(equalTo: background.topAnchor, constant: mainDistanceFromTop),
            assignmentIcon.widthAnchor.constraint(equalToConstant: 25),
            assignmentIcon.heightAnchor.constraint(equalToConstant: 25),
            
            daysBackground.widthAnchor.constraint(equalTo: background.widthAnchor, constant: -12),
            daysBackground.heightAnchor.constraint(equalToConstant: 40),
            daysBackground.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            daysBackground.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: 20)
        ])
    }
    
    func addDayLabels(){
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.contentMode = .center
        stackView.spacing = 5
        daysBackground.addSubview(stackView)


        stackView.leftAnchor.constraint(equalTo: daysBackground.leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: daysBackground.rightAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: daysBackground.topAnchor, constant: 9).isActive = true
        stackView.bottomAnchor.constraint(equalTo: daysBackground.bottomAnchor, constant: -9).isActive = true


        
        let dayLabels: [String] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
        for day in dayLabels{
            let dayButton = UIButton()
            dayButton.translatesAutoresizingMaskIntoConstraints = false
//            dayButton.setTitle(day, for: .normal)
            dayButton.setAttributedTitle(NSAttributedString(string: day, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: CourseCellNEW.themeColor]), for: .normal)
            
            if day == "TUE"{
                dayButton.setAttributedTitle(NSAttributedString(string: day, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white]), for: .normal)
                dayButton.backgroundColor = CourseCellNEW.themeColor
                dayButton.layer.cornerRadius = 5
            }

            stackView.addArrangedSubview(dayButton)
        }
    }
}
