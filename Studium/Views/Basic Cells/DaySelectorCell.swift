//
//  DaySelectorCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

protocol DaySelectorDelegate{
    func dayButtonPressed(sender: UIButton)
}
class DaySelectorCell: UITableViewCell {

    var delegate: DaySelectorDelegate?
    
    @IBOutlet var dayButtons: [UIButton]!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func dayButtonPressed(_ sender: UIButton) {
        delegate!.dayButtonPressed(sender: sender)
    }
    
}
