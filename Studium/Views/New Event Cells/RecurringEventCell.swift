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
import VikUtilityKit

//TODO: Docstrings
class RecurringEventCell: DeletableEventCell {
    
    let debug = false
    
    static let id = "RecurringEventCell"

    //TODO: Docstrings
    @IBOutlet weak var background: UIImageView!
    
    //TODO: Docstrings
    @IBOutlet weak var nameLabel: UILabel!
    
    //TODO: Docstrings
    @IBOutlet weak var locationLabel: UILabel!
    
    //TODO: Docstrings
    @IBOutlet weak var timeLabel: UILabel!
    
    //TODO: Docstrings
    @IBOutlet weak var iconImage: UIImageView!
    
    //TODO: Docstrings
    @IBOutlet weak var iconCircle: UIImageView!

    //TODO: Docstrings
    @IBOutlet var dayLabels: [UILabel]!
    
    //TODO: Docstrings
    @IBOutlet var dayBoxes: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.background.layer.cornerRadius = 15
        self.background.backgroundColor = StudiumColor.secondaryBackground.uiColor
    }

    //TODO: Docstrings
    func loadData(
        courseName: String,
        location: String,
        startTime: Date,
        endTime: Date,
        days: Set<Weekday>,
        color: UIColor,
        recurringEvent: RecurringStudiumEvent,
        icon: StudiumIcon
    ) {
        printDebug("Loading data for event: \(recurringEvent)")
        self.event = recurringEvent//just edited
        iconImage.image = icon.image
        iconImage.tintColor = color
        iconCircle.tintColor = color
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

extension RecurringEventCell: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG(RecurringEventCell): \(message)")
        }
    }
}
