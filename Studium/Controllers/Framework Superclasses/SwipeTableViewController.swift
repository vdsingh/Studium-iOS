//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Vikram Singh on 5/23/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

protocol EditableForm {
    func loadData(from data: StudiumEvent)
}

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate{

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:  "Cell", for: indexPath) as? SwipeTableViewCell{
            cell.delegate = self
            return cell
        }else{
            print("error in SwipeTableViewController in cellForRowAt.")
            let cell = tableView.dequeueReusableCell(withIdentifier:  "Cell", for: indexPath)
            return cell
        }
    }
    
    //MARK: - Swipe Cell Delegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        //guard orientation == .right else{return nil}
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.updateModelDelete(at: indexPath)
        }
        deleteAction.image = UIImage(named: "delete")
        
        let editAction = SwipeAction(style: .default, title: "View"){ (action, indexPath) in
            self.updateModelEdit(at: indexPath)
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
    
    func updateModelDelete(at indexPath: IndexPath){
        
    }
    
    func updateModelEdit(at indexPath: IndexPath){
        print("Triggered edit.")
    }
}
