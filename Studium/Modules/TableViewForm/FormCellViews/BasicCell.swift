//
//  BasicCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import UIKit

//TODO: Docstrings
protocol FormCellProtocol {
    static var id: String { get }
}

//TODO: Docstrings
public class BasicCell: UITableViewCell {
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ColorManager.cellBackgroundColor
    }
}
