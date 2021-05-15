//
//  CourseCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/14/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CourseCell1: DeletableEventCell {
    var course: Course?

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet var dayLabels: [UILabel]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        background.layer.cornerRadius = 15
        for dayLabel in dayLabels!{
            dayLabel.layer.borderWidth = 1
            dayLabel.layer.borderColor = CGColor.init(red: 255, green: 255, blue: 255, alpha: 1)
            dayLabel.layer.cornerRadius = 5
        }
    }

    func loadData(courseName: String, location: String, startTime: Date, endTime: Date, days: List<String>, colorHex: String, course: Course, systemImageString: String){
        self.course = course
        event = course
        iconImage.image = UIImage(systemName: systemImageString)
        iconImage.tintColor = UIColor(hexString: colorHex)
        background.backgroundColor = UIColor(hexString: colorHex)
        nameLabel.text = courseName
//        locationLabel.text = "HELLO"
        locationLabel.text = location
        if location.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            locationLabel.isHidden = true
        }
        print("location: \(location) end")
        var timeText = startTime.format(with: "h:mm a")
        timeText.append(" - \(endTime.format(with: "h:mm a"))")
        timeLabel.text = timeText
        
        for dayLabel in dayLabels{
            if days.contains(dayLabel.text!){
                dayLabel.backgroundColor = .white
                dayLabel.textColor = UIColor(hexString: colorHex)
            }else{
                dayLabel.textColor = .white
                dayLabel.backgroundColor = .none
            }
        }
        
    }
    
}
