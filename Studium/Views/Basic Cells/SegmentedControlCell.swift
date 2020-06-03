//
//  SegmentedControllCell.swift
//  Studium
//
//  Created by Vikram Singh on 6/1/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

protocol SegmentedControlDelegate{
    func controlValueChanged(sender: UISegmentedControl)
}
class SegmentedControlCell: UITableViewCell {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func controlValueChanged(_ sender: UISegmentedControl) {
    }
    
}
