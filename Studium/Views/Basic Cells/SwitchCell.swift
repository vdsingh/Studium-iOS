//
//  SwitchCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
protocol CanHandleSwitch{
    func switchValueChanged(sender: UISwitch)
}

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var tableSwitch: UISwitch!
    @IBOutlet weak var label: UILabel!
    
    var on: Bool = false
    
    var delegate: CanHandleSwitch?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        on = sender.isOn
        if let del = delegate{
            del.switchValueChanged(sender: sender)
        }
    }
    
    
}
