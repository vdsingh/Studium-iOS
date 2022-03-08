//
//  GenericTableViewCell.swift
//  Studium
//
//  Created by Vikram Singh on 3/4/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import UIKit

//This cell is meant to be used to display any StudiumEvent type. It is not meant to be deleted and is solely meant for the display of information.
class GenericTableViewCell: UITableViewCell {

    @IBOutlet weak var subTextLabel: UILabel!
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var date1Label: UILabel!
    @IBOutlet weak var date2Label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        reuseIdentifier = K.genericCellID
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(event: StudiumEvent){
        mainTextLabel.text = event.name
        subTextLabel.text = event.location
        
        
        date1Label.text = event.startDate.format(with: "MMM d, h:mm a")
        date2Label.text = event.endDate.format(with: "MMM d, h:mm a")
    }
    
}
