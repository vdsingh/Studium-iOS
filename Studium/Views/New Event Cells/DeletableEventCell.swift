//
//  DeletableEventCell.swift
//  Studium
//
//  Created by Vikram Singh on 6/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import SwipeCellKit
class DeletableEventCell: SwipeTableViewCell {    
    //this class applies to any cell that contains an event that can be deleted. it stores value event, so that the event that the cell holds can be deleted from the realm when necessary. This is useful because when we are dealing with tableviews with multiple types of cells (ex: AssignmentCell and OtherEventCell), we can delete without having to decipher arrays. For example, if deleting an assignment from array assignments, passing the indexPath of the cell will not work because the tableView is also populated with other types of cells. the index of the assignment array does not always correspond with indexPath.row.
    var event: StudiumEvent!
}
