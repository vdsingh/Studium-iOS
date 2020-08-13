//
//  LogoCollectionViewCell.swift
//  Studium
//
//  Created by Vikram Singh on 8/12/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

class LogoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setImage(systemImageName: String){
        let image = UIImage(systemName: systemImageName)
        imageView.tintColor = .red
        imageView.image = image
        print("set image for collection view cell.")
    }

}
