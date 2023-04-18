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
    
    static let id = "RecurringEventCell"

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconCircle: UIImageView!

    @IBOutlet var dayLabels: [UILabel]!
    @IBOutlet var dayBoxes: [UIImageView]!
    
    override func awakeFromNib() {
        self.debug = true
        super.awakeFromNib()
        self.background.layer.cornerRadius = 15
//        self.background.layer.borderWidth = 4
        self.background.backgroundColor = StudiumColor.secondaryBackground.uiColor
//        self.backgroundColor =
    }

    func loadData(
        courseName: String,
        location: String,
        startTime: Date,
        endTime: Date,
        days: Set<Weekday>,
        color: UIColor,
        recurringEvent: RecurringStudiumEvent,
        systemIcon: SystemIcon
    ) {
        printDebug("Loading data for event: \(recurringEvent)")
//        recurringEvent.day
        self.event = recurringEvent//just edited
        iconImage.image = systemIcon.createImage()
        iconImage.tintColor = color
        iconCircle.tintColor = color
        
//        background.backgroundColor = UIColor(hexString: colorHex)
        background.layer.borderColor = color.cgColor
        
        nameLabel.text = courseName
        nameLabel.textColor = color
        locationLabel.text = recurringEvent.location

        var timeText = startTime.format(with: DateFormat.standardTime.rawValue)
        timeText.append(" - \(endTime.format(with: DateFormat.standardTime.rawValue))")
        timeLabel.text = timeText
        
        for dayBox in dayBoxes {
            dayBox.layer.borderWidth = 2
            dayBox.layer.borderColor = color.cgColor
            dayBox.layer.cornerRadius = 5
        }
        
        // Reset all of the day labels and day boxes
        for i in 0..<dayLabels.count {
            dayLabels[i].textColor = StudiumColor.primaryLabel.uiColor
            dayBoxes[i].backgroundColor = .none
        }
        
        // highlight the day labels and day boxes for the selected days.
        for dayVal in days {
            let index = dayVal.rawValue - 1
            dayBoxes[index].backgroundColor = color
            dayLabels[index].textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        }
    }
}
