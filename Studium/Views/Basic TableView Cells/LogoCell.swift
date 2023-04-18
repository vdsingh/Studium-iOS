//
//  LogoCell.swift
//  Studium
//
//  Created by Vikram Singh on 8/12/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

class LogoCell: BasicCell {
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = StudiumColor.secondaryBackground.uiColor
        self.label.textColor = StudiumColor.primaryLabel.uiColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImage(systemIcon: SystemIcon) {
//        let image = UIImage(systemName: systemImageName)
//        logoImageView.tintColor = .red
        logoImageView.image = systemIcon.createImage()
    }
    
}

extension LogoCell: FormCellProtocol {
    static var id: String = "LogoCell"
}
