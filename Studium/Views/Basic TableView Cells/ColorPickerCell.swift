//
//  ColorPickerCell.swift
//  Studium
//
//  Created by Vikram Singh on 6/7/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

//TODO: Docstrings
public protocol ColorDelegate {
    
    //TODO: Docstrings
    func colorPickerValueChanged(sender: RadialPaletteControl)
}

import UIKit
import FlexColorPicker

//TODO: Docstrings
class ColorPickerCell: BasicCell {
    
    //TODO: Docstrings
    @IBOutlet weak var label: UILabel!
    
    //TODO: Docstrings
    @IBOutlet weak var colorPreview: UIImageView!
    
    //TODO: Docstrings
    @IBOutlet weak var colorPicker: RadialPaletteControl!
    
    //TODO: Docstrings
    var delegate: ColorDelegate?
    
    //TODO: Docstrings
    static var color: UIColor?
    override func awakeFromNib() {
        super.awakeFromNib()
        if ColorPickerCell.color != nil{
            colorPicker.selectedColor = ColorPickerCell.color!
            colorPreview.backgroundColor = ColorPickerCell.color!
        }
        
        self.colorPicker.backgroundColor = StudiumColor.secondaryBackground.uiColor
        self.label.textColor = StudiumColor.primaryLabel.uiColor
    }
    
    //TODO: Docstrings
    @IBAction func colorValueChanged(_ sender: RadialPaletteControl) {
        colorPreview.backgroundColor = sender.selectedColor
        delegate?.colorPickerValueChanged(sender: sender)
    }
}

extension ColorPickerCell: FormCellProtocol {
    static var id: String = "ColorPickerCell"
}
