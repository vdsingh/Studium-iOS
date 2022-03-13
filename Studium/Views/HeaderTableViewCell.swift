//
//  HeaderTableViewCell.swift
//  Studium
//
//  Created by Vikram Singh on 3/13/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTexts(primaryText: String, secondaryText: String){
        primaryLabel.text = primaryText
        secondaryLabel.text = secondaryText
    }
    
}
