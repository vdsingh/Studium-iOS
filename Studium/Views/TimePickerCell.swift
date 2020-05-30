//
//  TimePickerCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
protocol UITimePickerDelegate {
    func pickerValueChanged(sender: UIDatePicker)
}
class TimePickerCell: UITableViewCell {
    @IBOutlet weak var picker: UIDatePicker!
    var delegate: UITimePickerDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {
        delegate?.pickerValueChanged(sender: sender)
    }
    
}
