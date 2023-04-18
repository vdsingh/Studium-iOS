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
//    var delegate: PickerDelegate?
    var formCellID: FormCellID.PickerCell?
    var indexPath: IndexPath?
    override func awakeFromNib() {
//        picker.delegate = self
        super.awakeFromNib()
        self.backgroundColor = StudiumColor.secondaryBackground.uiColor
        

    
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    

        // Configure the view for the selected state
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("$ LOG: PICKER VIEW CHANGED")
    }
    
}

extension PickerCell: FormCellProtocol {
    static var id: String = "PickerCell"
}
