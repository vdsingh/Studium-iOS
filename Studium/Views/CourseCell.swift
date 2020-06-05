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

class CourseCell: SwipeTableViewCell{
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
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
    
    func loadData(courseName: String, location: String, startTime: Date, endTime: Date, days: List<String>, iconHex: String){

        iconImage.tintColor = UIColor(hexString: iconHex)
        locationLabel.text = location
        nameLabel.text = courseName
        
        var timeText = startTime.format(with: "h:mm a")
        timeText.append(" - \(endTime.format(with: "h:mm a"))")
        timeLabel.text = timeText
        
        for dayLabel in dayLabels{
            if days.contains(dayLabel.text!){
                dayLabel.textColor = .white
                dayLabel.backgroundColor = UIColor(hexString: iconHex)
            }else{
                dayLabel.textColor = .white
            }
        }
        
    }
}
