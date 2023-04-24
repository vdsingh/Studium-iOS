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


class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    var debug: Bool {false}
    
    var rightActions = [SwipeAction]()
    var leftActions = [SwipeAction]()


    var swipeCellId: String = "SwipeCell"
    
    override func viewDidLoad() {

    }
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        printDebug("will try to dequeue a SwipeTableViewCell with id: \(self.swipeCellId)")
        if let cell = tableView.dequeueReusableCell(withIdentifier:  self.swipeCellId, for: indexPath) as? SwipeTableViewCell {
            cell.delegate = self
            return cell
        }
        
        fatalError("$ERR: Couldn't dequeue cell as SwipeTableViewCell")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return K.populatedHeaderHeight
    }

    
    //MARK: - Swipe Cell Delegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right{
            return self.rightActions
        } else {
            return self.leftActions
        }
    }
    
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

extension SwipeTableViewController: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (\(String(describing: self)): \(message)")
        }
    }
}
