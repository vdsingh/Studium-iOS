//
//  HabitCell.swift
//  Studium
//
//  Created by Vikram Singh on 6/21/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import SwipeCellKit

class HabitCell: DeletableEventCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var dayLabels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(from habit: Habit){
        event = habit
        nameLabel.text = habit.name
        locationLabel.text = habit.location
        
        var timeText = habit.startDate.format(with: "h:mm a")
        timeText.append(" - \(habit.endDate.format(with: "h:mm a"))")
        if habit.autoSchedule{
            timeLabel.text = "Auto: \(timeText)"
        }else{
            timeLabel.text = timeText
        }
        
        for label in dayLabels{
            //print("label in dayLabels")
            //print(label.text)
            let labelText = label.text!

            if habit.days.contains(labelText){
                //print("habit occurs on \(labelText)")
                label.backgroundColor = tintColor
                label.textColor = .white
            }
        }
    }
}
