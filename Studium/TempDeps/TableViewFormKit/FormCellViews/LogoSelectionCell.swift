//
//  LogoCell.swift
//  Studium
//
//  Created by Vikram Singh on 8/12/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

//TODO: Docstrings
public class LogoSelectionCell: BasicCell {
    
    /// ImageView for the logo
    @IBOutlet weak private var logoImageView: UIImageView!
    
    /// Label
    @IBOutlet weak public var label: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.label.textColor = ColorManager.primaryTextColor
        self.logoImageView.tintColor = ColorManager.primaryAccentColor
        self.accessoryType = .disclosureIndicator
    }
    
    /// Sets the logo image
    /// - Parameter image: The logo image to display
    public func setImage(image: UIImage) {
        self.logoImageView.image = image
    }
}

extension LogoSelectionCell: FormCellProtocol {
    public static var id: String = "LogoSelectionCell"
}
