//
//  CourseCell.swift
//  Studium
//
//  Created by Vikram Singh on 6/3/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import ChameleonFramework

class CourseCell: UITableViewCell {
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseTime: UILabel!
    @IBOutlet weak var courseLocation: UILabel!
    @IBOutlet var dayLabels: [UILabel]!
    var color: UIColor = UIColor.black
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func reloadCell(courseNameText: String, courseStartTime: Date, courseEndTime: Date, courseLocationText: String, courseColor: String){
        courseName.text = courseNameText

        let startString = courseStartTime.format(with: "h:mm a")
        let endString = courseEndTime.format(with: "h:mm a")
        courseTime.text = "\(startString) - \(endString)"
        courseLocation.text = courseLocationText
        print("Course Color: \(courseColor)")
        color = UIColor(hexString: courseColor)!
        
        for day in dayLabels{
            day.backgroundColor = color
        }
        courseLocation.textColor = color
        firstView.backgroundColor = color
        
    }
    
}
