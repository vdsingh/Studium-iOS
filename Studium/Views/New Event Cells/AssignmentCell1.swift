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
    static let id = "AssignmentCell1"
    
    //the background of the cell (just a solid color)
    @IBOutlet weak var background: UIImageView!
    
    //this is a circle that tells us how late or close to the deadline this assignment is - red=late, yellow=due soon, green=not due soon.
    @IBOutlet weak var latenessIndicator: UIImageView!
    
    //the icon associated with the assignment (it will be the same as the course's icon)
    @IBOutlet weak var icon: UIImageView!
    
    //the white circle behind the icon
    @IBOutlet weak var iconBackground: UIImageView!
    
    //the label that shows the assignments name. This is the primary label
    @IBOutlet weak var primaryLabel: UILabel!
    
    //the label that shows the course's name.
    @IBOutlet weak var subLabel: UILabel!
    
    //the label that shows the due date of the assignment.
    @IBOutlet weak var dueDateLabel: UILabel!
    
    //button that allows user to expand list of autoscheduled events (if there are any)
    @IBOutlet weak var chevronButton: UIButton!
    
    //a delegate that allows us to expand assignment cells that have autoscheduled events
    var assignmentCollapseDelegate: AssignmentCollapseDelegate?
    
    //boolean that tells us whether the autoscheduled events list for this cell has been expanded.
    var autoEventsOpen: Bool = false
    
    //boolean that allows us to override the chevron button if we don't want it to appear even if applicable
    var hideChevronButton: Bool = false
    
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
        let primaryTextAttributeString = NSMutableAttributedString(string: event!.name)
        primaryTextAttributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, primaryTextAttributeString.length))
        
        //Safely get the associated course for this assignment
        guard let course = assignment.parentCourse else{
            print("ERROR: error accessing parent course in AssignmentCell1")
            return
        }
        
        //the UIColor of the assignment's associated course.
        let themeColor = course.color
        
        //A contrasting color to the course's color - we don't want white text on yellow background.
        var contrastingColor = UIColor(contrastingBlackOrWhiteColorOn: themeColor, isFlat: true)
        //Black as a label color looks too intense. If the contrasting color is supposed to be black, change it to a lighter gray.
        if contrastingColor == UIColor(contrastingBlackOrWhiteColorOn: .white, isFlat: true){
            contrastingColor = UIColor(hexString: "#4a4a4a")!
        }
        
        //Set all of the labels' colors and chevron color to the contrasting color
        primaryLabel.textColor = contrastingColor
        subLabel.textColor = contrastingColor
        dueDateLabel.textColor = contrastingColor
        chevronButton.tintColor = contrastingColor

        //Set all of the labels' texts
        subLabel.text = course.name
        dueDateLabel.text = assignment.endDate.format(with: "MMM d, h:mm a")

        if assignment.complete {
            //if assignment is complete, make it's background color and icon color gray
            background.backgroundColor = .gray
            icon.tintColor = .gray
            
            //make the lateness indicator gray- it's not relevant since the assignment has already been completed
            latenessIndicator.tintColor = .gray
        } else {
            background.backgroundColor = themeColor
            primaryTextAttributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, primaryTextAttributeString.length))
            icon.tintColor = themeColor
            
            
            //If our assignment is past due, make the lateness indicator red. If it is due soon, make the lateness indicator yellow. Otherwise, make it green.
            if Date() > assignment.endDate {
                print("$$ LOG: assignment end date: \(assignment.endDate)")
                latenessIndicator.tintColor = .red
            } else if Date() + (60*60*24*3) > assignment.endDate {
                latenessIndicator.tintColor = .yellow
            } else {
                latenessIndicator.tintColor = .green
            }
        }
        
        //set the attributed text of the assignment name label.
        primaryLabel.attributedText = primaryTextAttributeString

        //this assignment has no autoscheduled events, so there is no need to have a button that drops down the autoscheduled events.
        if assignment.scheduledEvents.count == 0 {
            chevronButton.isHidden = true
        } else {
            chevronButton.isHidden = false
        }
        
        self.event = assignment
        
        //set the image of the icon to be the same as the associated course's icon.
        icon.image = UIImage(systemName: course.systemImageString)
        
        //override the chevron button.
        if hideChevronButton {
            chevronButton.isHidden = true
        }
    }
    
    
    //Handle collapse button pressed for assignments that have autoscheduled events.
    @IBAction func collapseButtonPressed(_ sender: UIButton) {
        if assignmentCollapseDelegate != nil && event != nil{
            if let assignment = event as? Assignment{
                //configuration settings for chevron button (sizing)
                if autoEventsOpen {
                    //handle closing the window
                    assignmentCollapseDelegate?.handleCloseAutoEvents(assignment: assignment)
                    autoEventsOpen = false
                    let chevDownImage = UIImage(systemName: "chevron.down", withConfiguration: largeConfig)
                    chevronButton.setImage(chevDownImage, for: .normal)

                } else {
                    //handle opening the window
                    assignmentCollapseDelegate?.handleOpenAutoEvents(assignment: assignment)
                    autoEventsOpen = true
                    let chevUpImage = UIImage(systemName: "chevron.up", withConfiguration: largeConfig)
                    chevronButton.setImage(chevUpImage, for: .normal)

                }
            } else {
                print("ERROR: problem getting the event as an assignment when trying to expand assignment's autoscheduled events using the chevron button..")
            }
        } else {
            print("ERROR: delegate was nil or assignment was nil.")
        }
    }
}
