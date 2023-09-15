//
//  ColorPickerCell.swift
//  Studium
//
//  Created by Vikram Singh on 6/7/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import FlexColorPicker

//TODO: Docstrings
public protocol ColorDelegate {
    
    //TODO: Docstrings
    func colorPickerValueChanged(sender: RadialPaletteControl)
}

//TODO: Docstrings
public class ColorPickerCell: BasicCell {
    
    //TODO: Docstrings
    @IBOutlet weak var label: UILabel!
    
    //TODO: Docstrings
    @IBOutlet weak public var colorPreview: UIImageView!
    
    //TODO: Docstrings
    @IBOutlet weak var colorPicker: RadialPaletteControl!
    
    //TODO: Docstrings
    public var delegate: ColorDelegate?
    
    //TODO: Docstrings
    var color: UIColor = .black {
        didSet {
            self.colorPreview.backgroundColor = self.color
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        self.color = .white
        self.colorPicker.selectedColor = self.color
        self.colorPicker.backgroundColor = ColorManager.cellBackgroundColor
        self.label.textColor = ColorManager.primaryTextColor
    }
    
    //TODO: Docstrings
    @IBAction func colorValueChanged(_ sender: RadialPaletteControl) {
        self.color = sender.selectedColor
        delegate?.colorPickerValueChanged(sender: sender)
    }
}

extension ColorPickerCell: FormCellProtocol {
    public static var id: String = "ColorPickerCell"
}
