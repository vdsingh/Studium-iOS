//
//  ThemeCell.swift
//  Studium
//
//  Created by Vikram Singh on 8/18/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

class ThemeCell: BasicCell {

    @IBOutlet weak var colorPreview: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = defaultBackgroundColor

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setColorPreviewColor(colors: [CGColor]){
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

extension ThemeCell: FormCell {
    static var id: String = "ThemeCell"
}
