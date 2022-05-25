//
//  StudiumViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/18/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

/// Superclass for most Studium View Controllers. Main functionality includes building the dynamic Header View and providing functions to alter UI element's characteristics
class StudiumViewController: UIViewController{
    
    ///The Corner Radius of the Header View
    static let headerCornerRadius: CGFloat = 40
    
    ///The Corner Radius of the Subviews within the Header View
    static let headerSubviewsCornerRadius: CGFloat = 20
    
    ///The Spacing of the StackView containing the Header Subviews
    static let headerStackViewSpacing: CGFloat = 20
    
    
    ///The main header that will contain various things like the title and search bar
    var header: UIView = {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.backgroundColor = K.studiumStandardPurple
        header.layer.cornerRadius = StudiumViewController.headerCornerRadius
        return header
    }()
    
    ///stack view containing things in the header like title label and search bar
    var headerStackView: UIStackView = {
        let headerStackView = UIStackView()
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.axis = .vertical
        headerStackView.distribution = .fill
//        headerStackView.contentMode = .fill
        headerStackView.spacing = StudiumViewController.headerStackViewSpacing
        return headerStackView
    }()
    
    ///Search Bar. Will be contained in the Header StackView
    var searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.layer.cornerRadius = StudiumViewController.headerSubviewsCornerRadius
        searchBar.clipsToBounds = true
        searchBar.backgroundColor = .white
        let searchBarPlaceHolderString = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        searchBar.attributedPlaceholder = searchBarPlaceHolderString
        
        //add the magnifying glass icon to the search bar
        let iconSize = 25
        let iconName = "magnifyingglass"
        let magnifyIconImageView = UIImageView(frame: CGRect(x: 15, y: 0, width: iconSize, height: iconSize))
        magnifyIconImageView.image = UIImage(systemName: iconName)
        magnifyIconImageView.tintColor = UIColor(hexString: "B4B4B4") ?? .gray
        let magnifyIconView = UIView(frame: CGRect(x: 0, y: 0, width: iconSize + 20, height: iconSize))
        magnifyIconView.addSubview(magnifyIconImageView)
        searchBar.leftView = magnifyIconView
        searchBar.leftViewMode = UITextField.ViewMode.always
        
        //add shadow to the search bar
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOpacity = 1
        searchBar.layer.shadowOffset = CGSize(width: 2, height: 2)
        searchBar.layer.shadowRadius = 4
        
        return searchBar
    }()
    
    
    ///Title Label. Will be contained in the Header StackView
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.attributedText = NSAttributedString(string: "Title Label",attributes:[NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)])
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    ///Detail Label. Will be contained in the Header StackView. Hidden by default. To unhide, call the setDetailLabelText function.
    var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.attributedText = NSAttributedString(string: "Detail Text (set with setDetailLabelText)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        detailLabel.textColor = .white
        detailLabel.isHidden = true
        return detailLabel
    }()
    
    ///Button in the top right of the Header. Not contained in the Header StackView
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        addViews()
        activateConstraints()
    }
    
    /// Adds the views to the View Controller
    func addViews(){
        view.backgroundColor = K.studiumLightPurple
        view.addSubview(header)
        
        header.addSubview(topRightButton)
        
        header.addSubview(headerStackView)
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(searchBar)
        headerStackView.addArrangedSubview(detailLabel)
    }
    
    
    /// Activates the constraints of the views in the View Controller.
    func activateConstraints(){
        NSLayoutConstraint.activate([
            //Header Constraints
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leftAnchor.constraint(equalTo: view.leftAnchor),
            header.rightAnchor.constraint(equalTo: view.rightAnchor),
            header.bottomAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 20),
            
            headerStackView.topAnchor.constraint(equalTo: headerStackView.superview?.topAnchor ?? header.topAnchor, constant: 60),
//            headerStackView.bottomAnchor.constraint(equalTo: headerStackView.superview?.bottomAnchor ?? header.bottomAnchor),
            headerStackView.leftAnchor.constraint(equalTo: headerStackView.superview?.leftAnchor ?? header.leftAnchor, constant: 20),
            headerStackView.rightAnchor.constraint(equalTo: headerStackView.superview?.rightAnchor ?? header.rightAnchor, constant: -20),

//            header.heightAnchor.constraint(equalToConstant: 200),
            
            //Top Right Button Constraints
            topRightButton.rightAnchor.constraint(equalTo: topRightButton.superview?.rightAnchor ?? view.rightAnchor, constant: -20),
            topRightButton.topAnchor.constraint(equalTo: topRightButton.superview?.topAnchor ?? view.topAnchor, constant: 60),
            topRightButton.heightAnchor.constraint(equalToConstant: 30),
            topRightButton.widthAnchor.constraint(equalToConstant: 35),
            
            //Title Label Constraints
            titleLabel.leftAnchor.constraint(equalTo: titleLabel.superview?.leftAnchor ?? view.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: titleLabel.superview?.rightAnchor ?? view.rightAnchor),
//            titleLabel.topAnchor.constraint(equalTo: titleLabel.superview?.topAnchor ?? view.topAnchor, constant: 60),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
          
            //Search Bar Constraints
//            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
//            searchBar.leftAnchor.constraint(equalTo: searchBar.superview?.leftAnchor ?? view.leftAnchor, constant: 20),
//            searchBar.rightAnchor.constraint(equalTo: searchBar.superview?.rightAnchor ?? view.rightAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
//
//            detailLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
//            detailLabel.leftAnchor.constraint(equalTo: detailLabel.superview?.leftAnchor ?? view.leftAnchor, constant: 20),
//            detailLabel.rightAnchor.constraint(equalTo: detailLabel.superview?.rightAnchor ?? view.rightAnchor, constant: -20),
            detailLabel.heightAnchor.constraint(equalToConstant: 30),
            
        ])
    }
}


//Functions to Change UI Element Properties
extension StudiumViewController{
    
    /// Sets the text of the title label in the header
    /// - Parameter string: The String that we want to set the title label's text to.
    func setTitleLabelText(string: String){
        titleLabel.attributedText = NSAttributedString(string: string ,attributes:[NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)])
    }
    
    /// Sets the placeholder string of the search bar in the header.
    /// - Parameter string: the string that we are setting the placeholder of the search bar to.
    func setSearchBarPlaceHolderString(string: String){
        searchBar.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "B4B4B4") ?? UIColor.gray])
    }
    
    /// Hides/Unhides the search bar
    /// - Parameter hide: Bool specifying whether the search bar in the header should be hidden or not.
    func hideSearchBar(hide: Bool){
        searchBar.isHidden = hide
    }
    
    /// Hides/Unhides the top right button
    /// - Parameter hide: Bool specifying whether the top right button in the header should be hidden or not.
    func hideTopRightButton(hide: Bool){
        topRightButton.isHidden = hide
    }
    
    /// Sets the image of the top right button (in the header)
    /// - Parameter image: UIImage that we are setting the button's image to
    func setTopRightButtonImage(image: UIImage){
        topRightButton.setImage(image, for: .normal)
    }
    
    /// Sets the text of the detail label in the header and unhides it (located underneath the search bar by default).
    /// - Parameter text: String that we are setting the detail label's text to.
    func setDetailLabelText(text: String){
        detailLabel.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        detailLabel.isHidden = false
    }
    
    /// Adds a view to the header.
    /// - Parameter view: UIView to be added to the header.
    func addViewToHeader(view: UIView){
        headerStackView.addArrangedSubview(view)
    }
    
    
}
