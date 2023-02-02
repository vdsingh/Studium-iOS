//
//  BasicCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import UIKit
protocol FormCellProtocol {
    static var id: String { get }
}

class BasicCell: UITableViewCell {
    var defaultBackgroundColor = UIColor.secondarySystemBackground
}
