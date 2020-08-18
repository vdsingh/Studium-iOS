//
//  ThemeCell.swift
//  Studium
//
//  Created by Vikram Singh on 8/18/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

class ThemeCell: UITableViewCell {

    @IBOutlet weak var colorPreview: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
