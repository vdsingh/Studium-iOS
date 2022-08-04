//
//  EventCellNEW.swift
//  Studium
//
//  Created by Vikram Singh on 5/18/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class EventCellNEW: UITableViewCell{
    
    static let themeColor: UIColor = .red
    
    let background: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.layer.cornerRadius = 20
        background.backgroundColor = .white
        
        background.layer.shadowColor = EventCellNEW.themeColor.cgColor
        background.layer.shadowOpacity = 1
        background.layer.shadowOffset = CGSize(width: 2, height: 2)
//        background.layer.sp
        background.layer.shadowRadius = 4
        
        return background
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.attributedText = NSAttributedString(string: "Milestone 3", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        titleLabel.textColor = EventCellNEW.themeColor
        return titleLabel
    }()
    
    let detailText: UILabel = {
        let detailText = UILabel()
        detailText.translatesAutoresizingMaskIntoConstraints = false
        detailText.attributedText = NSAttributedString(string: "Due 5/22 at 5:00PM", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        detailText.textColor = EventCellNEW.themeColor
        return detailText
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
    
    let detailStackView: UIStackView = {
        let detailStackView = UIStackView()
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.axis = .horizontal
        detailStackView.distribution = .fillProportionally
        detailStackView.alignment = .center
        detailStackView.spacing = 5
        return detailStackView
    }()
    
    
    let iconBackground: UIView = {
        let iconBackground = UIView()
        iconBackground.translatesAutoresizingMaskIntoConstraints = false
        iconBackground.layer.cornerRadius = 10
        iconBackground.backgroundColor = EventCellNEW.themeColor
        return iconBackground
    }()
    
    let icon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(systemName: "pencil")
        icon.tintColor = .white
        return icon
    }()
    
    let lateIndicator: UIView = {
        let lateIndicator = UIView()
        lateIndicator.translatesAutoresizingMaskIntoConstraints = false
        lateIndicator.backgroundColor = themeColor
        lateIndicator.layer.cornerRadius = 5
        return lateIndicator
    }()
    
    let checkBox: UIButton = {
        let checkBox = UIButton()
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        checkBox.tintColor = EventCellNEW.themeColor
        checkBox.contentMode = .scaleAspectFill
        return checkBox
    }()
    
    let expandCaret: UIButton = {
        let expandCaret = UIButton()
        expandCaret.translatesAutoresizingMaskIntoConstraints = false
        expandCaret.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        expandCaret.tintColor = EventCellNEW.themeColor
        return expandCaret
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
        establishConstraints()
//        print("BACKGROUND HEIGHT \(background.bounds.height)")
//        background.dropShadow(color: UIColor.red, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 3, scale: true)

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addViews(){
        print("ADDING VIEWS")
        
        
        self.backgroundColor = .clear
        
        
        addSubview(background)
        
        detailStackView.addArrangedSubview(lateIndicator)
        detailStackView.addArrangedSubview(detailText)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(detailStackView)
        
        background.addSubview(textStackView)
        background.addSubview(iconBackground)
        iconBackground.addSubview(icon)

        background.addSubview(checkBox)
        background.addSubview(expandCaret)
    }
    
    func establishConstraints(){
        NSLayoutConstraint.activate([
//            self.heightAnchor.constraint(equalToConstant: 70),
            
            background.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            background.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            background.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            background.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            iconBackground.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            iconBackground.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconBackground.heightAnchor.constraint(equalToConstant: 40),
            iconBackground.widthAnchor.constraint(equalToConstant: 40),
            
            icon.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor),
            icon.heightAnchor.constraint(equalToConstant: 25),
            icon.widthAnchor.constraint(equalToConstant: 25),
            
            textStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textStackView.leftAnchor.constraint(equalTo: iconBackground.rightAnchor, constant: 10),
            textStackView.heightAnchor.constraint(equalToConstant: 40),
            
            checkBox.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            checkBox.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkBox.heightAnchor.constraint(equalToConstant: 20),
            checkBox.widthAnchor.constraint(equalToConstant: 20),
            
            expandCaret.rightAnchor.constraint(equalTo: checkBox.leftAnchor, constant: -10),
            expandCaret.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            expandCaret.heightAnchor.constraint(equalToConstant: 25),
            expandCaret.widthAnchor.constraint(equalToConstant: 25),
            
            lateIndicator.heightAnchor.constraint(equalToConstant: 10),
            lateIndicator.widthAnchor.constraint(equalToConstant: 10),

//            titleLabel.heightAnchor.constraint(equalToConstant: 30)
            
        ])
    }
}
