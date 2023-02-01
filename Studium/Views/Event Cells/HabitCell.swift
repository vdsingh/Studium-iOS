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
    
    @IBOutlet weak var iconImage: UIImageView!
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
        
        iconImage.image = UIImage(systemName: habit.systemImageString)
        iconImage.tintColor = UIColor(hexString: habit.color)
//        habit.startDate
        
        var timeText = habit.startDate.format(with: "h:mm a")
        timeText.append(" - \(habit.endDate.format(with: "h:mm a"))")
        if habit.autoschedule{
            timeLabel.text = "Auto: \(timeText)"
        } else {
            timeLabel.text = timeText
        }
        
        //TODO: Fix this:
        
//        for label in dayLabels {
//            //print("label in dayLabels")
//            //print(label.text)
//            if habit.days.contains(K.weekdayDict[label.text!]!){
//
////            if habit.days.contains(labelText){
//                //print("habit occurs on \(labelText)")
//                label.backgroundColor = UIColor(hexString: habit.color)
//                label.textColor = .white
//            }else{
//                label.textColor = UIColor(hexString: habit.color)
//                label.backgroundColor = .none
//
//            }
//        }
    }
}
