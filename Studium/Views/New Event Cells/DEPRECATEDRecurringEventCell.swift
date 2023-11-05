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

// TODO: Docstrings
class DEPRECATEDRecurringEventCell: DeletableEventCell {

    static let id = "DEPRECATEDRecurringEventCell"

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
        self.background.layer.cornerRadius = 15
        self.background.backgroundColor = StudiumColor.secondaryBackground.uiColor
    }

    // TODO: Docstrings
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
        Log.d("Loading data for event: \(recurringEvent)")
        self.event = recurringEvent // just edited
        self.iconImage.image = icon.uiImage
        self.iconImage.tintColor = color
        self.iconCircle.tintColor = color
        self.background.layer.borderColor = color.cgColor

        self.nameLabel.text = courseName
        self.nameLabel.textColor = StudiumColor.primaryLabel.uiColor

        self.locationLabel.text = recurringEvent.location
        self.locationLabel.textColor = StudiumColor.placeholderLabel.uiColor

        var timeText = startTime.format(with: DateFormat.standardTime)
        timeText.append(" - \(endTime.format(with: DateFormat.standardTime))")
        self.timeLabel.text = timeText
        self.timeLabel.textColor = StudiumColor.primaryLabel.uiColor

        for dayBox in self.dayBoxes {
            dayBox.layer.borderWidth = 2
            dayBox.layer.borderColor = color.cgColor
            dayBox.layer.cornerRadius = 5
        }

        // Reset all of the day labels and day boxes
        for index in 0..<self.dayLabels.count {
            self.dayLabels[index].textColor = StudiumColor.primaryLabel.uiColor
            self.dayBoxes[index].backgroundColor = .none
        }

        // highlight the day labels and day boxes for the selected days.
        for dayVal in days {
            let index = dayVal.rawValue - 1
            self.dayBoxes[index].backgroundColor = color
            self.dayLabels[index].textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        }
    }
}
