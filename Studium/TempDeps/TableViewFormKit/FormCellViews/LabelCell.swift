//
//  LabelCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

//TODO: Docstrings
public class LabelCell: BasicCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
    //TODO: Docstrings
    @IBOutlet weak public var label: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.label.textColor = ColorManager.primaryTextColor
        self.backgroundColor = ColorManager.cellBackgroundColor
        self.iconImageView.isHidden = true
    }
    
    func setIcon(iconImage: UIImage?, color: UIColor = ColorManager.primaryAccentColor) {
        if let icon = iconImage {
            self.iconImageView.image = icon
            self.iconImageView.isHidden = false
            self.iconImageView.tintColor = color
        } else {
            self.iconImageView.isHidden = true
        }
    }
}

extension LabelCell: FormCellProtocol {
    public static var id: String = "LabelCell"
}
