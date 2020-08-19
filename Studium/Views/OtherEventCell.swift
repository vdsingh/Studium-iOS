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
        self.otherEvent = otherEvent
        nameLabel.text = otherEvent.name
        locationLabel.text = otherEvent.location
        startTimeLabel.text = otherEvent.startDate.format(with: "h:mm a")
        endTimeLabel.text = otherEvent.endDate.format(with: "h:mm a")
    }
    
}
