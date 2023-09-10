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

    /// ImageView to display the logo
//    @IBOutlet weak var imageView: UIImageView!
    
    var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func setup() {
        self.addSubviewsAndEstablishConstraints()
    }
    
    /// Sets the image for the logo
    /// - Parameters:
    ///   - image: The image that we want to show
    ///   - tintColor: The color of the image
    func setImage(image: UIImage, tintColor: UIColor) {
        self.imageView.tintColor = tintColor
        self.imageView.image = image
    }
    
    private func addSubviewsAndEstablishConstraints() {
        self.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

extension LogoCollectionViewCell {
    public static var id: String = "LogoCollectionViewCell"
}
