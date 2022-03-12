//
//  AssignmentCell1.swift
//  Studium
//
//  Created by Vikram Singh on 5/14/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import UIKit
import SwipeCellKit

protocol AssignmentCollapseDelegate{
    func handleOpenAutoEvents(assignment: Assignment)
    func handleCloseAutoEvents(assignment: Assignment)
}

class AssignmentCell1: DeletableEventCell {
    //the background of the cell (just a solid color)
    @IBOutlet weak var background: UIImageView!
    
    //the icon associated with the assignment (it will be the same as the course's icon)
    @IBOutlet weak var icon: UIImageView!
    
    //the white circle behind the icon
    @IBOutlet weak var iconBackground: UIImageView!
    
    //the label that shows the assignments name. This is the primary label
    @IBOutlet weak var assignmentNameLabel: UILabel!
    
    //the label that shows the course's name.
    @IBOutlet weak var courseNameLabel: UILabel!
    
    //the label that shows the due date of the assignment.
    @IBOutlet weak var dueDateLabel: UILabel!
    
    //button that allows user to expand list of autoscheduled events (if there are any)
    @IBOutlet weak var chevronButton: UIButton!
    
    //a delegate that allows us to expand assignment cells that have autoscheduled events
    var assignmentCollapseDelegate: AssignmentCollapseDelegate?
    
    //boolean that tells us whether the autoscheduled events list for this cell has been expanded.
    var autoEventsOpen: Bool = false
    
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)

    
    override func awakeFromNib() {
        super.awakeFromNib()
        let chevDownImage = UIImage(systemName: "chevron.down", withConfiguration: largeConfig)
        chevronButton.setImage(chevDownImage, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadData(assignment: Assignment){
        //store the assignment here - we'll know what to delete if necessary
        event = assignment
        
        //Create an attributed string for the assignment's name (the main label). This is so that when the assignment is marked complete, we can put a slash through the label.
        let assignmentNameAttributeString = NSMutableAttributedString(string: assignment.name)
        assignmentNameAttributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, assignmentNameAttributeString.length))
        
        //Safely get the associated course for this assignment
        guard let course = assignment.parentCourse else{
            print("Error accessing parent course in AssignmentCell1")
            return
        }
        
        //the UIColor of the assignment's associated course.
        let courseColor = UIColor(hexString: course.color) ?? .white
        
        //A contrasting color to the course's color - we don't want white text on yellow background.
        var contrastingColor = UIColor(contrastingBlackOrWhiteColorOn: courseColor, isFlat: true)
        //Black as a label color looks too intense. If the contrasting color is supposed to be black, change it to a lighter gray.
        if contrastingColor == UIColor(contrastingBlackOrWhiteColorOn: .white, isFlat: true){
            contrastingColor = UIColor(hexString: "#4a4a4a")!
        }
        
        //Set all of the labels' colors to the contrasting color
        assignmentNameLabel.textColor = contrastingColor
        courseNameLabel.textColor = contrastingColor
        dueDateLabel.textColor = contrastingColor

        //Set all of the labels' texts
        courseNameLabel.text = course.name
        dueDateLabel.text = assignment.endDate.format(with: "MMM d, h:mm a")

        if assignment.complete{
            background.backgroundColor = .gray
            icon.tintColor = .gray
        }else{
            background.backgroundColor = courseColor
            assignmentNameAttributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, assignmentNameAttributeString.length))
            icon.tintColor = courseColor
            
            
            //If our assignment is past due, make the due date text red. If it is due soon, make the due date text yellow.
            if Date() > assignment.endDate {
                dueDateLabel.textColor = .red
            }else if Date() + (60*60*24*3) > assignment.endDate{
                dueDateLabel.textColor = .yellow
            }
        }
        
        //set the attributed text of the assignment name label.
        assignmentNameLabel.attributedText = assignmentNameAttributeString

        //this assignment has no autoscheduled events, so there is no need to have a button that drops down the autoscheduled events.
        if assignment.scheduledEvents.count == 0{
            chevronButton.isHidden = true
        }else{
            chevronButton.isHidden = false
//            if autoEventsOpen{
//                let chevUpImage = UIImage(systemName: "chevron.up", withConfiguration: largeConfig)
//                chevronButton.setImage(chevUpImage, for: .normal)
//                print("Events are open!")
//            }else{
//                let chevDownImage = UIImage(systemName: "chevron.down", withConfiguration: largeConfig)
//                chevronButton.setImage(chevDownImage, for: .normal)
//                print("Events are closed!")
//            }
        }
//        self.assignment = assignment
        self.event = assignment
        
        //set the image of the icon to be the same as the associated course's icon.
        icon.image = UIImage(systemName: course.systemImageString)
    }
    
    //Handle collapse button pressed for assignments that have autoscheduled events.
    @IBAction func collapseButtonPressed(_ sender: UIButton) {
        if assignmentCollapseDelegate != nil && event != nil{
            if let assignment = event as? Assignment{
                //configuration settings for chevron button (sizing)
                if autoEventsOpen{
                    //handle closing the window
                    assignmentCollapseDelegate?.handleCloseAutoEvents(assignment: assignment)
                    autoEventsOpen = false
                    let chevDownImage = UIImage(systemName: "chevron.down", withConfiguration: largeConfig)
                    chevronButton.setImage(chevDownImage, for: .normal)

                }else{
                    //handle opening the window
                    assignmentCollapseDelegate?.handleOpenAutoEvents(assignment: assignment)
                    autoEventsOpen = true
                    let chevUpImage = UIImage(systemName: "chevron.up", withConfiguration: largeConfig)
                    chevronButton.setImage(chevUpImage, for: .normal)

                }
            }else{
                print("ERROR: problem getting the event as an assignment when trying to expand assignment's autoscheduled events using the chevron button..")
            }
        }else{
            print("ERROR: delegate was nil or assignment was nil.")
        }
    }
}
