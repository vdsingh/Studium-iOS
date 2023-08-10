//
//  OtherEventCell.swift
//  Studium
//
//  Created by Vikram Singh on 6/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import SwipeCellKit
import VikUtilityKit

//TODO: Docstrings
class OtherEventCell: DeletableEventCell {
    static let id = "OtherEventCell"
    
    //TODO: Docstrings
    @IBOutlet weak var primaryLabel: UILabel!
    
    //TODO: Docstrings
    @IBOutlet weak var subLabel: UILabel!
    
    //TODO: Docstrings
    @IBOutlet weak var startTimeLabel: UILabel!
    
    //TODO: Docstrings
    @IBOutlet weak var endTimeLabel: UILabel!
    
    //TODO: Docstrings
    @IBOutlet weak var latenessIndicator: UIImageView!
    
    //TODO: Docstrings
    @IBOutlet weak var latenessIndicatorContainer: UIView!
    
    //TODO: Docstrings
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var iconBackground: UIImageView!
    
    var checkboxWasTappedCallback: (() -> Void)?

    
    //TODO: Docstrings
    func loadData(from otherEvent: OtherEvent, checkboxWasTappedCallback: @escaping () -> Void) {
        self.iconBackground.isUserInteractionEnabled = true
        self.iconBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.checkboxWasTapped)))
        
        self.event = otherEvent
        self.checkboxWasTappedCallback = checkboxWasTappedCallback
        
        let attributeString = NSMutableAttributedString(string: otherEvent.name)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        
        if otherEvent.complete {
            self.backgroundColor = .gray
            self.iconImageView.tintColor = .gray
            self.primaryLabel.attributedText = attributeString
            self.latenessIndicator.tintColor = .gray
            self.iconBackground.image = SystemIcon.circleCheckmarkFill.createImage()
        } else {
            
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            self.primaryLabel.attributedText = attributeString
            self.iconBackground.image = SystemIcon.circle.createImage()

            //If our otherEvent is past due, make the lateness indicator red. If it is due soon, make the lateness indicator yellow. Otherwise, make it green.
            if Date() > otherEvent.endDate {
                self.latenessIndicator.tintColor = .red
            } else if Date() + (60*60*24*3) > otherEvent.endDate {
                self.latenessIndicator.tintColor = .yellow
            } else {
                self.latenessIndicator.tintColor = .green
            }
        }
        
//        self.iconImageView.image = otherEvent.icon.uiImage
        self.iconImageView.isHidden = true
        self.subLabel.text = otherEvent.location
        self.startTimeLabel.text = otherEvent.startDate.format(with: DateFormat.fullDateWithTime.rawValue)
        self.endTimeLabel.text = otherEvent.endDate.format(with: DateFormat.fullDateWithTime.rawValue)
//        self.backgroundColor = .black
    }
    
    //TODO: Docstrings
    func loadDataGeneric(primaryText: String, secondaryText: String, startDate: Date, endDate: Date, cellColor: UIColor){
        var contrastingColor = UIColor(contrastingBlackOrWhiteColorOn: cellColor, isFlat: true)
        //Black as a label color looks too intense. If the contrasting color is supposed to be black, change it to a lighter gray.
        if contrastingColor == UIColor(contrastingBlackOrWhiteColorOn: .white, isFlat: true){
            contrastingColor = UIColor(hexString: "#4a4a4a")!
        }

        self.primaryLabel.text = primaryText
        self.primaryLabel.textColor = contrastingColor
        
        self.subLabel.text = secondaryText
        self.subLabel.textColor = contrastingColor
        
        self.startTimeLabel.text = startDate.format(with: "h:mm a")
        self.startTimeLabel.textColor = contrastingColor

        self.endTimeLabel.text = endDate.format(with: "h:mm a")
        self.endTimeLabel.textColor = contrastingColor

        
        self.backgroundColor = cellColor
        self.latenessIndicator.isHidden = true
    }
    
    //TODO: Docstrings
    func hideLatenessIndicator(hide: Bool) {
        self.latenessIndicatorContainer.isHidden = hide
    }
    
    @objc func checkboxWasTapped() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        if let callback = self.checkboxWasTappedCallback {
            callback()
        }
    }
}
