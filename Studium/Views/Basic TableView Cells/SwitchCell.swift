//
//  SwitchCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
public protocol CanHandleSwitch{
    func switchValueChanged(sender: UISwitch)
}

public protocol CanHandleInfoDisplay: UIViewController{
    func displayInformation()
}

class SwitchCell: BasicCell {
    
    @IBOutlet weak var tableSwitch: UISwitch!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    var on: Bool = false
    
    var switchDelegate: CanHandleSwitch?
    var infoDelegate: CanHandleInfoDisplay?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = StudiumColor.secondaryBackground.uiColor
        self.label.textColor = StudiumColor.primaryLabel.uiColor
        self.infoButton.backgroundColor = StudiumColor.secondaryBackground.uiColor

        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        on = sender.isOn
        if let del = switchDelegate{
            del.switchValueChanged(sender: sender)
        }
    }

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
