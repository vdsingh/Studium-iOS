//
//  OtherEventCell.swift
//  Studium
//
//  Created by Vikram Singh on 6/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import SwipeCellKit

class OtherEventCell: DeletableEventCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    var otherEvent: OtherEvent?
    
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
            nameLabel.attributedText = attributeString
        }else{
            print("removed strikethrough.")
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            nameLabel.attributedText = attributeString
        }
        
        self.otherEvent = otherEvent

        locationLabel.text = otherEvent.location
        startTimeLabel.text = otherEvent.startDate.format(with: "MMM d, h:mm a")
        endTimeLabel.text = otherEvent.endDate.format(with: "MMM d, h:mm a")
    }
    
}
