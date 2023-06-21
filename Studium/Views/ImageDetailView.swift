//
//  ImageDetailView.swift
//  Studium
//
//  Created by Vikram Singh on 6/20/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit


class ImageDetailView: UIView {
    
    static let id = "ImageDetailView"
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "No Habits here yet"
        title.font = StudiumFont.title.font
        title.textAlignment = .center
        return title
    }()
    
    let subtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.text = "Tap + to add a Habit"
        subtitle.font = StudiumFont.subTitle.font
        subtitle.textColor = StudiumFont.placeholder.color
        subtitle.textAlignment = .center

        return subtitle
    }()
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviewsAndEstablishConstraints()
        
        self.backgroundColor = StudiumColor.secondaryBackground.uiColor
        self.layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviewsAndEstablishConstraints() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.addArrangedSubview(self.mainImageView)

        stackView.addArrangedSubview(self.title)
        stackView.addArrangedSubview(self.subtitle)

        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            self.mainImageView.heightAnchor.constraint(equalToConstant: 275),
            self.mainImageView.widthAnchor.constraint(equalToConstant: 200),

            self.widthAnchor.constraint(equalToConstant: 400),
            self.heightAnchor.constraint(equalToConstant: 400),

            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
//            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    func setImage(_ image: UIImage) {
        self.mainImageView.image = image
    }
    
    func setTitle(_ text: String) {
        self.title.text = text
    }
    
    func setSubtitle(_ text: String) {
        self.subtitle.text = text
    }
}
