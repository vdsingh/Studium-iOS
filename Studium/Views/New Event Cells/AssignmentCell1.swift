//
//  AssignmentCell1.swift
//  Studium
//
//  Created by Vikram Singh on 5/14/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import UIKit
import SwipeCellKit
class AssignmentCell1: DeletableEventCell {

    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var assignmentNameLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
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
            background.backgroundColor = .gray
            assignmentNameLabel.attributedText = attributeString
            icon.tintColor = .gray


        }else{
            background.backgroundColor = UIColor(hexString: assignment.parentCourse[0].color)
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            assignmentNameLabel.attributedText = attributeString
            icon.tintColor = UIColor(hexString: assignment.parentCourse[0].color)

        }
        self.assignment = assignment
        self.event = assignment
        courseNameLabel.text = assignment.parentCourse[0].name
        
        icon.image = UIImage(systemName: assignment.parentCourse[0].systemImageString)
        
        
        dueDateLabel.text = assignment.endDate.format(with: "MMM d, h:mm a")
    }
}
