//
//  LogoCollectionViewCell.swift
//  Studium
//
//  Created by Vikram Singh on 8/12/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

class LogoCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "LogoCollectionViewCell"

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setImage(image: UIImage, tintColor: UIColor){
        imageView.tintColor = tintColor
        imageView.image = image
    }
}
