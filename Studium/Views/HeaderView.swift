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
        
        primaryLabel.textAlignment = NSTextAlignment.left
        primaryLabel.text = "Primary Label"
        primaryLabel.textColor = .label
        primaryLabel.font = UIFont.boldSystemFont(ofSize: 17.0)

        secondaryLabel.textAlignment = NSTextAlignment.right
        secondaryLabel.text = "Secondary Label"
        secondaryLabel.textColor = .label
        secondaryLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        contentView.addSubview(primaryLabel)
        contentView.addSubview(secondaryLabel)

        primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            primaryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            primaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            secondaryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            secondaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
    }
    
    //TODO: Docstrings
    func setTexts(primaryText: String, secondaryText: String){
        primaryLabel.text = primaryText
        secondaryLabel.text = secondaryText
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
