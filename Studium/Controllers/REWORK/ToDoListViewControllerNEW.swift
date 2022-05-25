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
        courseCirclesScrollView.backgroundColor = K.studiumDarkPurple
//        courseCirclesScrollView.
        courseCirclesScrollView.layer.cornerRadius = 30
        return courseCirclesScrollView
    }()
    
    var courseCirclesStackView: UIStackView = {
        let courseCirclesStackView = UIStackView()
//        courseCirclesStackView.backgroundColor = .green
        courseCirclesStackView.translatesAutoresizingMaskIntoConstraints = false
        courseCirclesStackView.spacing = 20
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
        
//        setupUI()
    }
    
    override func loadView() {
        super.loadView()
//        addViews()
//        activateConstraints()
        setSectionHeaders(sectionHeaders: ["Incomplete", "Report Your Grade"])
        setDetailLabelText(text: "HELLO")
    }
    
    
    //1
    override func addViews(){
        print("INWARD ADDVIEWS CALLED ONCE")
        super.addViews()
        courseCirclesScrollView.addSubview(courseCirclesStackView)
        addViewToHeader(view: courseCirclesScrollView)

        addCourseCircleCell()
    }
    
    
    //1
    override func activateConstraints(){
        super.activateConstraints()
        NSLayoutConstraint.activate([
            courseCirclesStackView.topAnchor.constraint(equalTo: courseCirclesStackView.superview?.topAnchor ?? courseCirclesScrollView.topAnchor),
            courseCirclesStackView.bottomAnchor.constraint(equalTo: courseCirclesStackView.superview?.bottomAnchor ?? courseCirclesScrollView.bottomAnchor),
            courseCirclesStackView.leftAnchor.constraint(equalTo: headerStackView.leftAnchor, constant: 20),
            courseCirclesStackView.rightAnchor.constraint(equalTo: courseCirclesStackView.superview?.rightAnchor ?? courseCirclesScrollView.rightAnchor),
            
            courseCirclesScrollView.heightAnchor.constraint(equalToConstant: 100),

        ])
    }
    
    func addCourseCircleCell(){
        let colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple, .magenta]
        for i in 0..<7 {
            print("ADDING CIRCLE")
            let courseCircle = CourseCircleCollectionViewCell()
            courseCircle.widthAnchor.constraint(equalToConstant: 50).isActive = true
            courseCircle.backgroundColor = colors[i]
            courseCircle.courseLogoBackground.backgroundColor = colors[i]
            courseCirclesStackView.addArrangedSubview(courseCircle)
        }
    }
}
