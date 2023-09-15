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

protocol UITableViewControllerProtocol: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView { get set }
}

//TODO: Docstrings
class SwipeTableViewController: UIViewController, UITableViewControllerProtocol, SwipeTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate {
    
    private var vStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.backgroundColor = .cyan
        return stack
    }()

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    //TODO: Docstrings
    var rightActions = [SwipeAction]()
    
    //TODO: Docstrings
    var leftActions = [SwipeAction]()
    
    //TODO: Docstrings
    var swipeCellId: String = "SwipeCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
                
        self.vStack.addArrangedSubview(self.tableView)
        self.view.addSubview(self.vStack)
        NSLayoutConstraint.activate([
            self.vStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.vStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.vStack.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.vStack.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ])
    }

    //MARK: - TableView Data Source
    
    //TODO: Docstrings
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        Log.d("will try to dequeue a SwipeTableViewCell with id: \(self.swipeCellId)")
        if let cell = tableView.dequeueReusableCell(withIdentifier:  self.swipeCellId, for: indexPath) as? SwipeTableViewCell {
            cell.delegate = self
            return cell
        }
        
        Log.e("Couldn't dequeue cell as SwipeTableViewCell")
        return UITableViewCell()
    }
    
    //TODO: Docstrings
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Increment.five
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    //MARK: - Swipe Cell Delegate
    
    //TODO: Docstrings
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right {
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
    
    func addViewToStack(subView: UIView) {
        self.vStack.addArrangedSubview(subView)
    }
    
    func insertViewIntoStack(subView: UIView, at index: Int) {
        self.vStack.insertArrangedSubview(subView, at: index)
    }
}
