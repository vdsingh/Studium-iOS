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
    @IBOutlet weak var iconCircle: UIImageView!
    
    @IBOutlet var dayLabels: [UILabel]!
    @IBOutlet var dayBoxes: [UIImageView]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        background.layer.cornerRadius = 15
        background.layer.borderWidth = 4
        
    }

    func loadData(courseName: String, location: String, startTime: Date, endTime: Date, days: List<Int>, colorHex: String, course: Course, systemImageString: String){
        self.course = course
        event = course
        iconImage.image = UIImage(systemName: systemImageString)
        iconImage.tintColor = UIColor(hexString: colorHex)
        iconCircle.tintColor = UIColor(hexString: colorHex)
        
//        background.backgroundColor = UIColor(hexString: colorHex)
        background.layer.borderColor = UIColor(hexString: colorHex)!.cgColor
        
        nameLabel.text = courseName
        nameLabel.textColor = UIColor(hexString: colorHex)
        locationLabel.text = course.location

        print("location:\(location)end")
        var timeText = startTime.format(with: "h:mm a")
        timeText.append(" - \(endTime.format(with: "h:mm a"))")
        timeLabel.text = timeText
        
        for dayBox in dayBoxes{
            dayBox.layer.borderWidth = 2
            dayBox.layer.borderColor = UIColor(hexString: colorHex)!.cgColor
            dayBox.layer.cornerRadius = 5
        }
    
        for i in 0...dayLabels.count-1{
//        for dayLabel in dayLabels{
            let dayLabel = dayLabels[i]
            let dayBox = dayBoxes[i];
            if days.contains(K.weekdayDict[dayLabel.text!]!){
//            if days.contains(dayLabel.text!){
                dayBox.backgroundColor = UIColor(hexString: colorHex)
//                dayLabel.backgroundColor =
//                dayLabel.layer.cornerRadius = 5
//                dayLabel.textColor = UIColor(hexString: colorHex)
            }else{
                dayLabel.textColor = .white
                dayBox.backgroundColor = .none
            }
        }
    }
}
