//
//  PickerCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

//TODO: Docstrings
class PickerCell: BasicCell {

    //TODO: Docstrings
    @IBOutlet weak var picker: UIPickerView!

    //TODO: Docstrings
    var formCellID: FormCellID.PickerCell?
    
    //TODO: Docstrings
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.picker.setValue(StudiumColor.primaryLabel.uiColor, forKeyPath: "textColor")
    }
}

extension PickerCell: FormCellProtocol {
    static var id: String = "PickerCell"
}
