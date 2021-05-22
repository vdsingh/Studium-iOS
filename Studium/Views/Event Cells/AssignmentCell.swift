//
//  AssignmentCell.swift
//  Studium
//
//  Created by Vikram Singh on 6/8/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import SwipeCellKit
class AssignmentCell: DeletableEventCell {

    @IBOutlet weak var assignmentNameLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    var assignment: Assignment?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(assignment: Assignment){
        event = assignment //this is what's referenced when needs to be deleted.
        let attributeString = NSMutableAttributedString(string: assignment.name)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))

        if assignment.complete{
            assignmentNameLabel.attributedText = attributeString

        }else{
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            assignmentNameLabel.attributedText = attributeString
        }
        self.assignment = assignment
        self.event = assignment
        guard let course = assignment.parentCourse else{
            return
        }
        courseNameLabel.text = course.name
        
        icon.image = UIImage(systemName: course.systemImageString)
        icon.tintColor = UIColor(hexString: course.color)
        dueDateLabel.text = assignment.endDate.format(with: "MMM d, h:mm a")
    }
}
