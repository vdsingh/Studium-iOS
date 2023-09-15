//
//  ThemeCell.swift
//  Studium
//
//  Created by Vikram Singh on 8/18/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

//TODO: Docstrings
public class ThemeCell: BasicCell {

    //TODO: Docstrings
    @IBOutlet weak public var colorPreview: UIImageView!
    
    //TODO: Docstrings
    @IBOutlet weak public var label: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ColorManager.cellBackgroundColor
    }

    //TODO: Docstrings
    public func setColorPreviewColor(colors: [CGColor]){
        let view = UIView(frame: colorPreview.frame)
        view.layer.cornerRadius = 21
        view.clipsToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = colors
        gradient.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradient, at: 0)
        colorPreview.addSubview(view)
        colorPreview.bringSubviewToFront(view)
        
    }
}

extension ThemeCell: FormCellProtocol {
    public static var id: String = "ThemeCell"
}
