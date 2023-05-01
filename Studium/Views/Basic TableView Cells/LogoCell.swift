//
//  LogoCell.swift
//  Studium
//
//  Created by Vikram Singh on 8/12/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

//TODO: Docstrings
class LogoCell: BasicCell {
    
    /// ImageView for the logo
    @IBOutlet weak var logoImageView: UIImageView!
    
    /// Label
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.textColor = StudiumColor.primaryLabel.uiColor
        self.logoImageView.tintColor = StudiumColor.primaryAccent.uiColor
    }
    
    /// Sets the logo image
    /// - Parameter systemIcon: The logo image to display
    func setImage(systemIcon: SystemIcon) {
        logoImageView.image = systemIcon.createImage()
    }
}

extension LogoCell: FormCellProtocol {
    static var id: String = "LogoCell"
}
