//
//  PickerCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
//protocol UIPickerDelegate {
//    func pickerValueChanged(sender: UIPickerView, indexPath: IndexPath)
//}

class PickerCell: UITableViewCell{

    @IBOutlet weak var picker: UIPickerView!
    
    //var delegate: UIPickerDelegate?
    var indexPath: IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
