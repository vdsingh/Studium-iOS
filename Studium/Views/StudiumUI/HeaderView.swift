//
//  HeaderTableViewCell.swift
//  Studium
//
//  Created by Vikram Singh on 3/13/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import UIKit

//TODO: Docstrings
class HeaderView: UITableViewHeaderFooterView {
    static let id = "HeaderView"
    
    //TODO: Docstrings
    var primaryLabel: UILabel = UILabel()
    
    //TODO: Docstrings
    var secondaryLabel: UILabel = UILabel()
    
    //TODO: Docstrings
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.primaryLabel.textAlignment = NSTextAlignment.left
        self.primaryLabel.text = "Primary Label"
        self.primaryLabel.textColor = .label
        self.primaryLabel.font = UIFont.boldSystemFont(ofSize: 17.0)

        self.secondaryLabel.textAlignment = NSTextAlignment.right
        self.secondaryLabel.text = "Secondary Label"
        self.secondaryLabel.textColor = .label
        self.secondaryLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        self.contentView.addSubview(self.primaryLabel)
        self.contentView.addSubview(self.secondaryLabel)

        self.primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.primaryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.primaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            self.secondaryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.secondaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    //TODO: Docstrings
    func setTexts(primaryText: String, secondaryText: String){
        self.primaryLabel.text = primaryText
        self.secondaryLabel.text = secondaryText
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
