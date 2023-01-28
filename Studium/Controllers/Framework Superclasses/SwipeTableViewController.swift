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
    var realm: Realm!
    let app = App(id: Secret.appID)
    
    var eventsArray: [[StudiumEvent]] = [[],[]]
    
    var sectionHeaders: [String] = ["Section 1", "Section 2"]
    var eventTypeString: String = "Events"
//    var headerViews: [HeaderView?] = [nil, nil]

    var idString: String = "Cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = app.currentUser else {
            print("ERROR: error getting user in SwipeTableViewController")
            return
        }
        realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
        
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: K.headerCellID)
        tableView.register(UINib(nibName: "RecurringEventCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "AssignmentCell1", bundle: nil), forCellReuseIdentifier: K.assignmentCellID)
        tableView.register(UINib(nibName: "AssignmentCell1", bundle: nil), forCellReuseIdentifier: K.assignmentCellID)
        tableView.register(UINib(nibName: "OtherEventCell", bundle: nil), forCellReuseIdentifier: K.otherEventCellID)
    }
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:  idString, for: indexPath) as? SwipeTableViewCell{
            cell.delegate = self
            return cell
        }else{
            print("ERROR: error in SwipeTableViewController in cellForRowAt.")
            let cell = tableView.dequeueReusableCell(withIdentifier:  "Cell", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: K.headerCellID) as? HeaderView
        else {
            return nil
        }
        
        headerView.setTexts(primaryText: sectionHeaders[section], secondaryText: "\(eventsArray[section].count) \(eventTypeString)")

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return K.headerHeight
    }
    
    func updateHeader(section: Int){
        let headerView  = tableView.headerView(forSection: section) as? HeaderView
        headerView?.setTexts(primaryText: sectionHeaders[section], secondaryText: "\(eventsArray[section].count) \(eventTypeString)")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return eventsArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray[section].count
    }
    
    //MARK: - Swipe Cell Delegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        //guard orientation == .right else{return nil}
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.updateModelDelete(at: indexPath)
        }
        deleteAction.image = UIImage(named: "delete")
        
        let editAction = SwipeAction(style: .default, title: "View/Edit"){ (action, indexPath) in
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
//        print("LOG: updateModelDelete called in SwipeTableViewController")
//        let deletableEventCell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
//        if let eventForDeletion = deletableEventCell.event{
//            do{
//                try realm.write{
//                    realm.delete(eventForDeletion)
//                }
//            }catch{
//                print(error)
//            }
//        }else{
//            print("event for deletion is nil")
//        }
    }
    
    func updateModelEdit(at indexPath: IndexPath){
        
    }
}
