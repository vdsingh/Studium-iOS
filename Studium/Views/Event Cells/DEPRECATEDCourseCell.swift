//
//  CourseCell.swift
//  Studium
//
//  Created by Vikram Singh on 6/5/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class DEPRECATEDCourseCell: DeletableEventCell{
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var dayLabels: [UILabel]!
    
    var course: Course?
    
    func loadData(courseName: String, location: String, startTime: Date, endTime: Date, days: List<String>, colorHex: String, course: Course, systemIcon: SystemIcon) {
        self.course = course
        self.event = course
        self.iconImage.image = systemIcon.createImage()
        self.iconImage.tintColor = UIColor(hexString: colorHex)
        self.nameLabel.text = courseName
        self.locationLabel.text = location
        var timeText = startTime.format(with: "h:mm a")
        timeText.append(" - \(endTime.format(with: "h:mm a"))")
        self.timeLabel.text = timeText
        
        for dayLabel in self.dayLabels {
            if days.contains(dayLabel.text!){
                dayLabel.textColor = .white
                dayLabel.backgroundColor = UIColor(hexString: colorHex)
            }else{
                dayLabel.textColor = UIColor(hexString: colorHex)
                dayLabel.backgroundColor = .none
            }
        }
    }
}
