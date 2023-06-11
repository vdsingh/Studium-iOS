//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Vikram Singh on 5/23/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift

//TODO: Docstrings
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate, Debuggable {
    
    var debug: Bool { false }
    
    //TODO: Docstrings
    var rightActions = [SwipeAction]()
    
    //TODO: Docstrings
    var leftActions = [SwipeAction]()
    
    //TODO: Docstrings
    var swipeCellId: String = "SwipeCell"

    //MARK: - TableView Data Source Methods
    
    //TODO: Docstrings
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.printDebug("will try to dequeue a SwipeTableViewCell with id: \(self.swipeCellId)")
        if let cell = tableView.dequeueReusableCell(withIdentifier:  self.swipeCellId, for: indexPath) as? SwipeTableViewCell {
            cell.delegate = self
            return cell
        }
        
        fatalError("$ERR: Couldn't dequeue cell as SwipeTableViewCell")
    }
    
    //TODO: Docstrings
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return K.populatedHeaderHeight
    }
    
    //MARK: - Swipe Cell Delegate
    
    //TODO: Docstrings
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right{
            return self.rightActions
        } else {
            return self.leftActions
        }
    }
    
    //TODO: Docstrings
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        if orientation == .right {
            options.expansionStyle = .destructive
        } else {
            options.expansionStyle = .selection
        }
        options.transitionStyle = .border
        
        return options
    }
}
