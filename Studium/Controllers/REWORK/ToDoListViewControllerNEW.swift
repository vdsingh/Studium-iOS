//
//  ToDoListViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/17/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
class ToDoListViewControllerNEW: UIViewController{
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var courseCirclesScrollView: UIScrollView!
    @IBOutlet weak var courseCirclesStackView: UIStackView!
    //    @IBOutlet weak var coursesCollectionView: UICollectionView!
    @IBOutlet weak var eventsTableView: UITableView!
    
    
    let sectionHeaders: [String] = ["Incomplete", "Report Your Grade"]
    
    let placeHolderColor: UIColor = .gray
    
    let iconSize = 30
    let iconName = "magnifyingglass"
    func setupUI(){
        headerView.layer.cornerRadius = 40
        
        
        
        let magnifyIconImageView = UIImageView(frame: CGRect(x: 5, y: 0, width: iconSize, height: iconSize))
        magnifyIconImageView.image = UIImage(systemName: iconName)
        magnifyIconImageView.contentMode = .scaleAspectFit

        let magnifyIconView = UIView(frame: CGRect(x: 0, y: 0, width: iconSize, height: iconSize))
        magnifyIconView.addSubview(magnifyIconImageView)
        searchBar.leftView = magnifyIconView
        searchBar.leftViewMode = UITextField.ViewMode.always
        
        courseCirclesScrollView.layer.cornerRadius = 30
//        courseCirclesScrollView.layer.masksToBounds = true
        
        eventsTableView.backgroundColor = .clear
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.separatorStyle = .none
        eventsTableView.register(EventCellNEW.self, forCellReuseIdentifier: "EventCellNEW")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("NEW todo list view did load")
        setupUI()
    }
    
}

extension ToDoListViewControllerNEW: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let assignmentCell = tableView.dequeueReusableCell(withIdentifier: "EventCellNEW", for: indexPath) as! EventCellNEW
        
        return assignmentCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}
