//
//  PickerCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

//TODO: Docstrings
public class PickerCell: BasicCell {

    //TODO: Docstrings
    @IBOutlet weak public var picker: UIPickerView!

    //TODO: Docstrings
    public var formCellID: FormCellID.PickerCellID?
    
    //TODO: Docstrings
    public var indexPath: IndexPath?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.picker.setValue(ColorManager.primaryTextColor, forKeyPath: "textColor")
    }
}

extension PickerCell: FormCellProtocol {
    public static var id: String = "PickerCell"
}
