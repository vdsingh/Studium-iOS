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
    static var color: UIColor?
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib called")
//        colorPreview.backgroundColor = colorPicker.selectedColor
//        colorPicker.selectedColor = color
//        colorPicker.reloadInputViews()
        if ColorPickerCell.color != nil{
            colorPicker.selectedColor = ColorPickerCell.color!
            colorPreview.backgroundColor = ColorPickerCell.color!
        }
        print(colorPicker.selectedColor.hexValue())
//        colorPicker.reload

    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func colorValueChanged(_ sender: RadialPaletteControl) {
        colorPreview.backgroundColor = sender.selectedColor
    }
    
}
