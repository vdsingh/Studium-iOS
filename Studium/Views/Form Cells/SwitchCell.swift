//
//  SwitchCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

// TODO: Docstrings
public protocol CanHandleSwitch {

    // TODO: Docstrings
    func switchValueChanged(sender: UISwitch)
}

// TODO: Docstrings
public protocol CanHandleInfoDisplay: UIViewController {

    // TODO: Docstrings
    func displayInformation()
}

// TODO: Docstrings
class SwitchCell: BasicCell {

    // TODO: Docstrings
    @IBOutlet weak var tableSwitch: UISwitch!

    // TODO: Docstrings
    @IBOutlet weak var label: UILabel!

    // TODO: Docstrings
    @IBOutlet weak var infoButton: UIButton!

    // TODO: Docstrings
    var on: Bool = false

    // TODO: Docstrings
    var switchDelegate: CanHandleSwitch?

    // TODO: Docstrings
    var infoDelegate: CanHandleInfoDisplay?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = StudiumColor.secondaryBackground.uiColor
        self.label.textColor = StudiumColor.primaryLabel.uiColor
        self.infoButton.backgroundColor = StudiumColor.secondaryBackground.uiColor
    }

    // TODO: Docstrings
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        self.on = sender.isOn
        if let del = switchDelegate {
            del.switchValueChanged(sender: sender)
        }
    }

    // TODO: Docstrings
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        if let del = infoDelegate {
            del.displayInformation()
        } else {
           print("error accessing infoDelegate")
        }
    }

}

extension SwitchCell: FormCellProtocol {
    static var id: String = "SwitchCell"
}
