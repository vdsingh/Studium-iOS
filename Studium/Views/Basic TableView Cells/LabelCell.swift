//
//  LabelCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

//TODO: Docstrings
class LabelCell: BasicCell {

    //TODO: Docstrings
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.textColor = StudiumColor.primaryLabel.uiColor
        self.backgroundColor = StudiumColor.secondaryBackground.uiColor
    }
}

extension LabelCell: FormCellProtocol {
    static var id: String = "LabelCell"
}
