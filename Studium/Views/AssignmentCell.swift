//
//  AssignmentCell.swift
//  Studium
//
//  Created by Vikram Singh on 6/8/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import SwipeCellKit
class AssignmentCell: SwipeTableViewCell {

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
    
    func loadData(assignmentName: String, courseName: String, iconColor: String, dueDate: Date){
        assignmentNameLabel.text = assignmentName
        courseNameLabel.text = courseName
        
        icon.tintColor = UIColor(hexString: iconColor)
        dueDateLabel.text = dueDate.format(with: "MMM d, h:mm a")
    }
    
    func loadCompleteAttributes(){
        
    }
}
