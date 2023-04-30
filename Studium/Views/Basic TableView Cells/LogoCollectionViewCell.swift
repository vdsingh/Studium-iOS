//
//  LogoCollectionViewCell.swift
//  Studium
//
//  Created by Vikram Singh on 8/12/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

//TODO: Docstrings
class LogoCollectionViewCell: UICollectionViewCell {

    //TODO: Docstrings
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //TODO: Docstrings
    func setImage(systemIcon: SystemIcon, tintColor: UIColor){
        imageView.tintColor = tintColor
        imageView.image = systemIcon.createImage()
    }
}

extension LogoCollectionViewCell: FormCellProtocol {
    static var id: String = "LogoCollectionViewCell"
}
