//
//  OtherEventCell.swift
//  Studium
//
//  Created by Vikram Singh on 6/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import SwipeCellKit

class OtherEventCell: DeletableEventCell {
    static let id = "OtherEventCell"
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var latenessIndicator: UIImageView!
    @IBOutlet weak var latenessIndicatorContainer: UIView!
    var otherEvent: OtherEvent!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(from otherEvent: OtherEvent){
        event = otherEvent
        
        let attributeString = NSMutableAttributedString(string: otherEvent.name)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        if otherEvent.complete{
            primaryLabel.attributedText = attributeString
            
            latenessIndicator.tintColor = .gray

        } else {
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            primaryLabel.attributedText = attributeString
            
            //If our otherEvent is past due, make the lateness indicator red. If it is due soon, make the lateness indicator yellow. Otherwise, make it green.
            if Date() > otherEvent.endDate {
                latenessIndicator.tintColor = .red
            }else if Date() + (60*60*24*3) > otherEvent.endDate{
                latenessIndicator.tintColor = .yellow
            }else{
                latenessIndicator.tintColor = .green
            }
        }
        
        self.otherEvent = otherEvent

        subLabel.text = otherEvent.location
        startTimeLabel.text = otherEvent.startDate.format(with: "MMM d, h:mm a")
        endTimeLabel.text = otherEvent.endDate.format(with: "MMM d, h:mm a")
        backgroundColor = .black

    }
    
    func loadDataGeneric(primaryText: String, secondaryText: String, startDate: Date, endDate: Date, cellColor: UIColor){
        var contrastingColor = UIColor(contrastingBlackOrWhiteColorOn: cellColor, isFlat: true)
        //Black as a label color looks too intense. If the contrasting color is supposed to be black, change it to a lighter gray.
        if contrastingColor == UIColor(contrastingBlackOrWhiteColorOn: .white, isFlat: true){
            contrastingColor = UIColor(hexString: "#4a4a4a")!
        }

        primaryLabel.text = primaryText
        primaryLabel.textColor = contrastingColor
        
        subLabel.text = secondaryText
        subLabel.textColor = contrastingColor
        
        startTimeLabel.text = startDate.format(with: "h:mm a")
        startTimeLabel.textColor = contrastingColor

        endTimeLabel.text = endDate.format(with: "h:mm a")
        endTimeLabel.textColor = contrastingColor

        
        backgroundColor = cellColor
        
//        background.backgroundColor = cellColor
//        background.backgroundColor = cellColor
        
//        icon.image = iconImage
//        icon.tintColor = cellColor
        latenessIndicator.isHidden = true
    }
    
    func hideLatenessIndicator(hide: Bool) {
        self.latenessIndicatorContainer.isHidden = hide
    }
}
