//
//  CourseCircleCollectionViewCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/17/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import UIKit

class CourseCircleCollectionViewCell: UIView {
    let courseLogoBackground: UIView = {
        let courseLogoBackground = UIView()
        courseLogoBackground.translatesAutoresizingMaskIntoConstraints = false
        courseLogoBackground.backgroundColor = UIColor(hexString: "FF9AA2")
        courseLogoBackground.layer.cornerRadius = 30
        return courseLogoBackground
    }()
    
    let courseLogo: UIImageView = {
        let courseLogo = UIImageView()
        courseLogo.translatesAutoresizingMaskIntoConstraints = false

        courseLogo.image = UIImage(systemName: "pencil")
        courseLogo.tintColor = .white
        return courseLogo
    }()
    
    let courseLabel: UILabel = {
        let courseLabel = UILabel()
        courseLabel.translatesAutoresizingMaskIntoConstraints = false
//        courseLabel.text = "CS325"
        courseLabel.attributedText = NSAttributedString(string: "CS325", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
//        courseLabel.contentMode = .center
        courseLabel.textAlignment = .center
        return courseLabel
    }()
    
    init(){
        super.init(frame: .zero)
        addViews()

//        addViews()
        
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addViews()

    }
    
    func addViews(){
        addSubview(courseLogoBackground)
        courseLogoBackground.addSubview(courseLogo)
        addSubview(courseLabel)
        
        self.backgroundColor = UIColor.clear
        
        NSLayoutConstraint.activate([
            
            //Course Logo Background Constraints
            courseLogoBackground.widthAnchor.constraint(equalToConstant: 60),
            courseLogoBackground.heightAnchor.constraint(equalToConstant: 60),
            courseLogoBackground.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            courseLogoBackground.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            
            //Course Logo Constraints
            courseLogo.widthAnchor.constraint(equalToConstant: 30),
            courseLogo.heightAnchor.constraint(equalToConstant: 30),
            courseLogo.centerXAnchor.constraint(equalTo: courseLogoBackground.centerXAnchor),
            courseLogo.centerYAnchor.constraint(equalTo: courseLogoBackground.centerYAnchor),
            
            
            //Course Label Constraints
            courseLabel.widthAnchor.constraint(equalToConstant: self.bounds.width),
            courseLabel.heightAnchor.constraint(equalToConstant: 30),
            courseLabel.topAnchor.constraint(equalTo: courseLogoBackground.bottomAnchor, constant: 0),
            courseLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            
        ])
    }
}
