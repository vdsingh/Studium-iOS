//
//  SegmentedControllCell.swift
//  Studium
//
//  Created by Vikram Singh on 6/1/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

// TODO: Docstrings
public protocol SegmentedControlDelegate {

    // TODO: Docstrings
    func controlValueChanged(sender: UISegmentedControl)
}

// TODO: Docstrings
class SegmentedControlCell: BasicCell {

    // TODO: Docstrings
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    // TODO: Docstrings
    var delegate: SegmentedControlDelegate?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        segmentedControl.isSelected = selected
    }

    // TODO: Docstrings
    @IBAction func controlValueChanged(_ sender: UISegmentedControl) {
        delegate?.controlValueChanged(sender: sender)
    }
}

extension SegmentedControlCell: FormCellProtocol {
    static var id: String = "SegmentedControlCell"
}
