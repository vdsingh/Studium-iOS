//
//  ToDoListViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/17/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
class ToDoListViewControllerNEW: StudiumTableViewController{
//    @IBOutlet weak var headerView: UIView!
//    @IBOutlet weak var searchBar: UITextField!
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var courseCirclesScrollView: UIScrollView!
//    @IBOutlet weak var courseCirclesStackView: UIStackView!
    //    @IBOutlet weak var coursesCollectionView: UICollectionView!
//    @IBOutlet weak var eventsTableView: UITableView!
    
//    var headerView: UIView = {
//
//    }
//
//    var searchBar: UITextField = {
//
//    }
    
//    var titleLabel: UILabel = {
//
//    }
//
    var courseCirclesScrollView: UIScrollView = {
        let courseCirclesScrollView = UIScrollView()
        courseCirclesScrollView.translatesAutoresizingMaskIntoConstraints = false
        return courseCirclesScrollView
    }()
    
    var courseCirclesStackView: UIStackView = {
        let courseCirclesStackView = UIStackView()
        courseCirclesStackView.translatesAutoresizingMaskIntoConstraints = false
        return courseCirclesStackView
    }()
    
    var eventsTableView: UITableView = {
        let eventsTableView = UITableView()
        eventsTableView.translatesAutoresizingMaskIntoConstraints = false
        return eventsTableView
    }()
    
    
//    let sectionHeaders: [String] = ["Incomplete", "Report Your Grade"]
    
    let placeHolderColor: UIColor = .gray
    
    let iconSize = 30
    let iconName = "magnifyingglass"
    func setupUI(){
//        headerView.layer.cornerRadius = 40
        
        
        
//        let magnifyIconImageView = UIImageView(frame: CGRect(x: 5, y: 0, width: iconSize, height: iconSize))
//        magnifyIconImageView.image = UIImage(systemName: iconName)
//        magnifyIconImageView.contentMode = .scaleAspectFit
//
//        let magnifyIconView = UIView(frame: CGRect(x: 0, y: 0, width: iconSize, height: iconSize))
//        magnifyIconView.addSubview(magnifyIconImageView)
//        searchBar.leftView = magnifyIconView
//        searchBar.leftViewMode = UITextField.ViewMode.always
        
        courseCirclesScrollView.layer.cornerRadius = 30
//        courseCirclesScrollView.layer.masksToBounds = true
        
//        eventsTableView.backgroundColor = .clear
//        eventsTableView.delegate = self
//        eventsTableView.dataSource = self
//        eventsTableView.separatorStyle = .none
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSectionHeaders(sectionHeaders: ["Incomplete", "Report Your Grade"])
        setDetailLabelText(text: "HELLO")
        setupUI()
    }
    
}
