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
    
    //TODO: Remove realm and app references
//    var realm: Realm!
//    let app = App(id: Secret.appID)
    


    var idString: String = "Cell"
    
    override func viewDidLoad() {

    }
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:  idString, for: indexPath) as? SwipeTableViewCell {
            cell.delegate = self
            return cell
        }
        
        fatalError("$Error: Couldn't dequeue cell as SwipeTableViewCell")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return K.headerHeight
    }

    
    //MARK: - Swipe Cell Delegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        //guard orientation == .right else{return nil}
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.delete(at: indexPath)
        }
        deleteAction.image = UIImage(named: "delete")
        
        let editAction = SwipeAction(style: .default, title: "View/Edit"){ (action, indexPath) in
            self.edit(at: indexPath)
        }
        editAction.image = UIImage(named: "edit")
        if orientation == .right{
            return [deleteAction]
        }else{
            return [editAction]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        if orientation == .right{
            options.expansionStyle = .destructive
        }else{
            options.expansionStyle = .selection
        }
        options.transitionStyle = .border
        
        
        return options
    }
}
