//
//  LabelCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

class LabelCell: BasicCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.textColor = StudiumColor.primaryLabel.uiColor
        self.backgroundColor = StudiumColor.secondaryBackground.uiColor

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension LabelCell: FormCellProtocol {
    static var id: String = "LabelCell"
}
