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
        icon.transform = icon.transform.rotated(by: 3.1415/4)
        
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
            print("ran else")

            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            print("removed attribute.")
            assignmentNameLabel.attributedText = attributeString
            
        }
        print(assignment.complete)
        self.assignment = assignment
        //assignmentNameLabel.text = assignment.name
        courseNameLabel.text = assignment.parentCourse[0].name
        
        icon.tintColor = UIColor(hexString: assignment.parentCourse[0].color)
        dueDateLabel.text = assignment.endDate.format(with: "MMM d, h:mm a")
        
        
        
        
    }
    
    func loadCompleteAttributes(){
        
    }
}
