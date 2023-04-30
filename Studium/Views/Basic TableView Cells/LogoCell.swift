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
    
    //TODO: Docstrings
    @IBOutlet weak var logoImageView: UIImageView!
    
    //TODO: Docstrings
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.backgroundColor = StudiumColor.secondaryBackground.uiColor
        self.label.textColor = StudiumColor.primaryLabel.uiColor
        self.logoImageView.tintColor = StudiumColor.primaryAccent.uiColor
    }
    
    //TODO: Docstrings
    func setImage(systemIcon: SystemIcon) {
//        let image = UIImage(systemName: systemImageName)
//        logoImageView.tintColor = .red
        logoImageView.image = systemIcon.createImage()
    }
    
}

extension LogoCell: FormCellProtocol {
    static var id: String = "LogoCell"
}
