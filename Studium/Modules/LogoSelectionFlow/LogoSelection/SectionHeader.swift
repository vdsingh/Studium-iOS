//
//  SectionHeader.swift
//  Studium
//
//  Created by Vikram Singh on 8/9/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class SectionHeader: UICollectionReusableView {
    
    static let id = "SectionHeader"
    
    var label: UILabel = {
        let label = UILabel()
        label.textColor = StudiumColor.primaryLabel.uiColor
        label.font = StudiumFont.subTitle.uiFont
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(label)

        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        self.label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
   }

   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

    func setup(headerText: String) {
        self.label.text = headerText
   }
}
