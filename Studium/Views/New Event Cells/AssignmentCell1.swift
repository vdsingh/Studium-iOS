//
//  AssignmentCell1.swift
//  Studium
//
//  Created by Vikram Singh on 5/14/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import UIKit
import SwipeCellKit
import VikUtilityKit

//TODO: Docstrings
protocol AssignmentCollapseDelegate {
    
    //TODO: Docstrings
    func collapseButtonClicked(assignment: Assignment)
}

//TODO: Docstrings
class AssignmentCell1: DeletableEventCell {
    
    let debug = true
    
    static let id = "AssignmentCell1"
    
    /// the background of the cell (just a solid color)
    @IBOutlet weak var background: UIImageView!
    
    /// s a circle that tells us how late or close to the deadline this assignment is - red=late, yellow=due soon, green=not due soon.
    @IBOutlet weak var latenessIndicator: UIImageView!
    
    // TODO: Docstrings
    @IBOutlet weak var latenessIndicatorBackground: UIImageView!
    
    /// the icon associated with the assignment (it will be the same as the course's icon)
    @IBOutlet weak var icon: UIImageView!
    
    /// the white circle behind the icon
    @IBOutlet weak var iconBackground: UIImageView!
    
    /// the label that shows the assignments name. This is the primary label
    @IBOutlet weak var primaryLabel: UILabel!
    
    /// the label that shows the course's name.
    @IBOutlet weak var subLabel: UILabel!
    
    /// the label that shows the due date of the assignment.
    @IBOutlet weak var dueDateLabel: UILabel!
    
    /// button that allows user to expand list of autoscheduled events (if there are any)
    @IBOutlet weak var expandEventsButton: UIButton!
    
    /// a delegate that allows us to expand assignment cells that have autoscheduled events
    var assignmentCollapseDelegate: AssignmentCollapseDelegate?
    
    /// boolean that allows us to override the chevron button if we don't want it to appear even if applicable
    var hideChevronButton: Bool = false
    
    //TODO: Docstrings
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
    
    var checkboxWasTappedCallback: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        let chevDownImage = SystemIcon.chevronDown.createImage()
        
        self.iconBackground.isUserInteractionEnabled = true
        self.iconBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.checkboxWasTapped)))
        self.setIsExpanded(isExpanded: false)
    }
    
    @objc func checkboxWasTapped() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        if let callback = self.checkboxWasTappedCallback {
            callback()
        }
    }
    
    //TODO: Docstring
    func loadData(
        assignment: Assignment,
        assignmentCollapseDelegate: AssignmentCollapseDelegate?,
        checkboxWasTappedCallback: @escaping () -> Void
    ) {
        
        // store the assignment here - we'll know what to delete if necessary
        self.event = assignment
        
        self.assignmentCollapseDelegate = assignmentCollapseDelegate
        
        self.checkboxWasTappedCallback = checkboxWasTappedCallback
        
        //TODO: Fix force unwrap
        
        // Create an attributed string for the assignment's name (the main label). This is so that when the assignment is marked complete, we can put a slash through the label.
        let primaryTextAttributeString = NSMutableAttributedString(string: self.event!.name)
        primaryTextAttributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, primaryTextAttributeString.length))
        
        // Safely get the associated course for this assignment
        guard let course = assignment.parentCourse else {
            Log.e("parent course was nil when loading assignment data")
            return
        }
        
        // the UIColor of the assignment's associated course.
        let themeColor = course.color
        
        // A contrasting color to the course's color - we don't want white text on yellow background.
        var contrastingColor = UIColor(contrastingBlackOrWhiteColorOn: themeColor, isFlat: true)
        // Black as a label color looks too intense. If the contrasting color is supposed to be black, change it to a lighter gray.
        if contrastingColor == UIColor(contrastingBlackOrWhiteColorOn: .white, isFlat: true){
           contrastingColor = UIColor(hexString: "#4a4a4a")!
        }
                
        // Set all of the labels' colors and chevron color to the contrasting color
        self.primaryLabel.textColor = contrastingColor
        self.subLabel.textColor = contrastingColor
        self.dueDateLabel.textColor = contrastingColor
        self.expandEventsButton.tintColor = contrastingColor
        self.iconBackground.tintColor = contrastingColor
        self.latenessIndicatorBackground.tintColor = contrastingColor
        self.accessoryView?.tintColor = contrastingColor

        // Set all of the labels' texts
        self.subLabel.text = course.name
        self.dueDateLabel.text = assignment.endDate.format(with: "MMM d, h:mm a")

        if assignment.complete {
            // if assignment is complete, make it's background color and icon color gray
//            self.background.backgroundColor = .gray
            self.backgroundColor = .gray
            self.icon.tintColor = .gray
            self.iconBackground.image = SystemIcon.circleCheckmarkFill.createImage()
            
            // make the lateness indicator gray- it's not relevant since the assignment has already been completed
            self.latenessIndicator.tintColor = .gray
        } else {
            self.backgroundColor = themeColor
            primaryTextAttributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, primaryTextAttributeString.length))
            
            self.icon.tintColor = themeColor
            self.iconBackground.image = SystemIcon.circle.createImage()
            
            //If our assignment is past due, make the lateness indicator red. If it is due soon, make the lateness indicator yellow. Otherwise, make it green.
            if Date() > assignment.endDate {
                self.printDebug("assignment end date: \(assignment.endDate)")
                self.latenessIndicator.tintColor = .red
            } else if Date() + (60*60*24*3) > assignment.endDate {
                self.latenessIndicator.tintColor = .yellow
            } else {
                self.latenessIndicator.tintColor = .green
            }
        }
        
        //set the attributed text of the assignment name label.
        self.primaryLabel.attributedText = primaryTextAttributeString

        //this assignment has no autoscheduled events, so there is no need to have a button that drops down the autoscheduled events.
        if assignment.autoscheduledEvents.isEmpty {
            self.expandEventsButton.isHidden = true
        } else {
            self.expandEventsButton.isHidden = false
        }
                
        self.event = assignment
        
        //set the image of the icon to be the same as the associated course's icon.
        self.icon.image = course.icon.uiImage
        
        //override the chevron button.
        if self.hideChevronButton {
            self.expandEventsButton.isHidden = true
        }
    }
    
    // TODO: Docstring
    func setIsExpanded(isExpanded: Bool) {
        
        // configuration settings for chevron button (sizing)
        if isExpanded {
            let chevUpImage = SystemIcon.chevronUp.createImage()
            self.expandEventsButton.setImage(chevUpImage, for: .normal)
            
        } else {
            let chevDownImage = SystemIcon.chevronDown.createImage()
            self.expandEventsButton.setImage(chevDownImage, for: .normal)
        }
    }
    
    //TODO: Docstring
    //Handle collapse button pressed for assignments that have autoscheduled events.
    @IBAction func collapseButtonPressed(_ sender: UIButton) {
        guard let assignmentCollapseDelegate = self.assignmentCollapseDelegate,
              let assignment = self.event as? Assignment else {
            Log.e("assignmentCollapseDelegate was nil: \(String(describing: self.assignmentCollapseDelegate)) or event was nil or not an assignment: \(String(describing: self.event))")
            return
        }
        
        assignmentCollapseDelegate.collapseButtonClicked(assignment: assignment)
    }
    
    //TODO: Docstring
    func hideLatenessIndicator(hide: Bool) {
        self.latenessIndicator.isHidden = hide
    }
}

extension AssignmentCell1: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (AssignmentCell1): \(message)")
        }
    }
}
