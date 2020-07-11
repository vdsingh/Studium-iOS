//
//  ColorPickerCell.swift
//  Studium
//
//  Created by Vikram Singh on 6/7/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//
protocol ColorDelegate {
    func colorPickerValueChanged(sender: RadialPaletteControl)
}
import UIKit
import FlexColorPicker
class ColorPickerCell: UITableViewCell {
    @IBOutlet weak var colorPreview: UIImageView!
    @IBOutlet weak var colorPicker: RadialPaletteControl!
    var delegate: ColorDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        colorPreview.backgroundColor = colorPicker.selectedColor

        // Initialization code
        //colorPreview.color
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func colorValueChanged(_ sender: RadialPaletteControl) {
        colorPreview.backgroundColor = sender.selectedColor
    }
    
}
