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
import ChameleonFramework

class RecurringEventCell: DeletableEventCell {
//    var recurringEvent: RecurringStudiumEvent?

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
        background.layer.cornerRadius = 15
        background.layer.borderWidth = 4
    }

    func loadData(courseName: String, location: String, startTime: Date, endTime: Date, days: List<Int>, colorHex: String, recurringEvent: RecurringStudiumEvent, systemImageString: String){
        self.event = recurringEvent//just edited
        iconImage.image = UIImage(systemName: systemImageString)
        iconImage.tintColor = UIColor(hexString: colorHex)
        iconCircle.tintColor = UIColor(hexString: colorHex)
        
//        background.backgroundColor = UIColor(hexString: colorHex)
        let borderColor = UIColor(hexString: colorHex) ?? .black
        background!.layer.borderColor = borderColor.cgColor
        
        nameLabel.text = courseName
        nameLabel.textColor = UIColor(hexString: colorHex)
        locationLabel.text = recurringEvent.location

        var timeText = startTime.format(with: "h:mm a")
        timeText.append(" - \(endTime.format(with: "h:mm a"))")
        timeLabel.text = timeText
        
        for dayBox in dayBoxes {
            dayBox.layer.borderWidth = 2
            let borderColor = UIColor(hexString: colorHex) ?? .black
            dayBox.layer.borderColor = borderColor.cgColor
            dayBox.layer.cornerRadius = 5
        }
    
        for i in 0...dayLabels.count-1{
            let dayLabel = dayLabels[i]
            let dayBox = dayBoxes[i];
            if days.contains(K.weekdayDict[dayLabel.text!]!){
                dayBox.backgroundColor = UIColor(hexString: colorHex)
                dayLabel.textColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: colorHex)!, isFlat: true)
            } else {
                dayLabel.textColor = .white
                dayBox.backgroundColor = .none
            }
        }
    }
}
