//
//  DeletableEventCell.swift
//  Studium
//
//  Created by Vikram Singh on 6/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import SwipeCellKit

/// SwipeTableViewCells that contain a StudiumEvent which can be deleted
class DeletableEventCell: SwipeTableViewCell {
    
    /// The StudiumEvent that can be deleted
    var event: StudiumEvent!
}
