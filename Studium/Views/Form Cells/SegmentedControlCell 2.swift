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
class SegmentedControlCell: BasicCell {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var delegate: SegmentedControlDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = defaultBackgroundColor

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        segmentedControl.isSelected = selected

        // Configure the view for the selected state
    }
    @IBAction func controlValueChanged(_ sender: UISegmentedControl) {
        delegate?.controlValueChanged(sender: sender)
    }
    
}
