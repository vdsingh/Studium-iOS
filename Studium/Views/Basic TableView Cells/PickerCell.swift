//
//  PickerCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit


class PickerCell: BasicCell {

    @IBOutlet weak var picker: UIPickerView!

    var formCellID: FormCellID.PickerCell?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.picker.setValue(StudiumColor.primaryLabel.uiColor, forKeyPath: "textColor")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension PickerCell: FormCellProtocol {
    static var id: String = "PickerCell"
}
