//
//  StudiumViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/18/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit



class StudiumViewController: UIViewController{
    
    var searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.layer.cornerRadius = 20
        searchBar.clipsToBounds = true
        searchBar.backgroundColor = .white
        let searchBarPlaceHolderString = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        searchBar.attributedPlaceholder = searchBarPlaceHolderString
//        searchBar.setLeftPaddingPoints(50)
        
        let iconSize = 25
        let iconName = "magnifyingglass"
        let magnifyIconImageView = UIImageView(frame: CGRect(x: 15, y: 0, width: iconSize, height: iconSize))
        magnifyIconImageView.image = UIImage(systemName: iconName)
        magnifyIconImageView.tintColor = UIColor(hexString: "B4B4B4") ?? .gray
        

        let magnifyIconView = UIView(frame: CGRect(x: 0, y: 0, width: iconSize + 20, height: iconSize))
        magnifyIconView.addSubview(magnifyIconImageView)
        searchBar.leftView = magnifyIconView
        searchBar.leftViewMode = UITextField.ViewMode.always
        
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOpacity = 1
        searchBar.layer.shadowOffset = CGSize(width: 2, height: 2)
        searchBar.layer.shadowRadius = 4
        
        return searchBar
    }()
    
    var header: UIView = {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.backgroundColor = K.studiumStandardPurple
        header.layer.cornerRadius = 40
        return header
    }()
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.attributedText = NSAttributedString(string: "Title Label",attributes:[NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)])
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    var topRightButton: UIButton = {
        let topRightButton = UIButton()
        topRightButton.translatesAutoresizingMaskIntoConstraints = false
        topRightButton.setImage(UIImage(systemName: "plus"), for: .normal)
        topRightButton.tintColor = .white
        
        topRightButton.contentVerticalAlignment = .fill
        topRightButton.contentHorizontalAlignment = .fill
        topRightButton.contentMode = .scaleAspectFit
        return topRightButton
    }()
    
    var detailTextLabel: UILabel = {
        let detailTextLabel = UILabel()
        detailTextLabel.translatesAutoresizingMaskIntoConstraints = false
        detailTextLabel.attributedText = NSAttributedString(string: "Assignments To Do: 5", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        detailTextLabel.textColor = .white
        return detailTextLabel
    }()
    
//    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = K.studiumLightPurple
                
        view.addSubview(header)
        header.addSubview(searchBar)
        header.addSubview(titleLabel)
        header.addSubview(detailTextLabel)
        header.addSubview(topRightButton)

        NSLayoutConstraint.activate([
            //Header Constraints
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leftAnchor.constraint(equalTo: view.leftAnchor),
            header.rightAnchor.constraint(equalTo: view.rightAnchor),
            header.heightAnchor.constraint(equalToConstant: 200),
            
            //Top Right Button Constraints
            topRightButton.rightAnchor.constraint(equalTo: topRightButton.superview?.rightAnchor ?? view.rightAnchor, constant: -20),
            topRightButton.topAnchor.constraint(equalTo: topRightButton.superview?.topAnchor ?? view.topAnchor, constant: 60),
            topRightButton.heightAnchor.constraint(equalToConstant: 30),
            topRightButton.widthAnchor.constraint(equalToConstant: 35),
            
            //Title Label Constraints
            titleLabel.leftAnchor.constraint(equalTo: titleLabel.superview?.leftAnchor ?? view.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: titleLabel.superview?.rightAnchor ?? view.rightAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleLabel.superview?.topAnchor ?? view.topAnchor, constant: 60),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
          
            //Search Bar Constraints
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            searchBar.leftAnchor.constraint(equalTo: searchBar.superview?.leftAnchor ?? view.leftAnchor, constant: 20),
            searchBar.rightAnchor.constraint(equalTo: searchBar.superview?.rightAnchor ?? view.rightAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            detailTextLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            detailTextLabel.leftAnchor.constraint(equalTo: detailTextLabel.superview?.leftAnchor ?? view.leftAnchor, constant: 20),
            detailTextLabel.rightAnchor.constraint(equalTo: detailTextLabel.superview?.rightAnchor ?? view.rightAnchor, constant: -20),
            detailTextLabel.heightAnchor.constraint(equalToConstant: 30),
            
        ])
    }
}


//Functions to Change UI Element Properties
extension StudiumViewController{
    func setHeaderHeight(headerHeight: CGFloat){
        header.heightConstraint?.constant = headerHeight
    }
    
    func setTitleLabelText(string: String){
        titleLabel.attributedText = NSAttributedString(string: string ,attributes:[NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)])
    }
    
    
    //Search Bar
    func setSearchBarPlaceHolderString(string: String){
        searchBar.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "B4B4B4") ?? UIColor.gray])
    }
    
    func hideSearchBar(hide: Bool){
        searchBar.isHidden = hide
    }
    
    func hideTopRightButton(hide: Bool){
        topRightButton.isHidden = hide
    }
    
    func setTopRightButtonImage(image: UIImage){
        topRightButton.setImage(image, for: .normal)
    }
    
    func setDetailTextLabelText(text: String){
        detailTextLabel.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
    }
    
//    func addTableView(bottomAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, leftAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, rightAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>){
//
//        let tableView = UITableView()
//        tableView.backgroundColor = .clear
//        tableView.separatorStyle = .none
//
//        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//
//
//        view.addSubview(tableView)
//    }
}
