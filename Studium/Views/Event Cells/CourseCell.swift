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

class CourseCell: DeletableEventCell{
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var dayLabels: [UILabel]!
    
    var course: Course?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        iconImage.transform = iconImage.transform.rotated(by: 3.1415/4)
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
//    func deloadData(){
//        for dayLabel in dayLabels{
//            dayLabel.textColor = .white
//
//        }
//    }
    
    func loadData(courseName: String, location: String, startTime: Date, endTime: Date, days: List<String>, colorHex: String, course: Course, systemImageString: String){
        self.course = course
        event = course
        iconImage.image = UIImage(systemName: systemImageString)
        iconImage.tintColor = UIColor(hexString: colorHex)
        nameLabel.text = courseName
        locationLabel.text = location
        var timeText = startTime.format(with: "h:mm a")
        timeText.append(" - \(endTime.format(with: "h:mm a"))")
        timeLabel.text = timeText
        
        for dayLabel in dayLabels{
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
