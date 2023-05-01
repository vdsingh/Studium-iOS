//
//  ThemesViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/4/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

// TODO: Docstrings
class ThemesViewController: UIViewController{
    
    // TODO: Docstrings
    @IBOutlet weak var tableView: UITableView!
    var themeNames: [[String]] = [["Studium Purple", "Studium Orange"],["Black", "Red", "Orange", "Yellow", "Green", "Teal", "Blue", "Purple"], ["Red/Orange", "Blue", "Blue/Green", "Pink/Purple"]]
    
    // TODO: Docstrings
    var colors: [[String]] = [["studiumPurple", "studiumOrange"], ["black", "flatRed","flatOrange","flatYellow","flatGreen","flatTeal", "flatBlue", "flatPurple"], ["redorangeGradient", "blueGradient", "bluegreenGradient", "purplepinkGradient"]]

    // TODO: Docstrings
    var sectionHeaders: [String] = ["Studium Colors", "Muted Colors", "Gradients"]
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ThemeCell", bundle: nil), forCellReuseIdentifier: "ThemeCell")
    }
    
    // TODO: Docstrings
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

// TODO: Docstrings
extension ThemesViewController: UITableViewDelegate {
    
    // TODO: Docstrings
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // TODO: Docstrings
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let color: UIColor = K.colorsDict[colors[indexPath.section][indexPath.row]] ?? UIColor.black
        
//        appDelegate.changeTheme(colorKey: colors[indexPath.section][indexPath.row])
        //hide and unhide the navbar to basically refresh it
//        self.navigationController?.isNavigationBarHidden = true
//        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = color
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // TODO: Docstrings
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

// TODO: Docstrings
extension ThemesViewController: UITableViewDataSource {
    
    // TODO: Docstrings
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    // TODO: Docstrings
    func numberOfSections(in tableView: UITableView) -> Int {
        return themeNames.count
    }
    
    // TODO: Docstrings
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeNames[section].count
    }
    
    // TODO: Docstrings
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell", for: indexPath) as! ThemeCell
        cell.label.text = themeNames[indexPath.section][indexPath.row]
//        let color: UIColor = UIColor(hexString: colors[indexPath.section][indexPath.row])!
//        cell.colorPreview.tintColor = K.colorsDict[colors[indexPath.section][indexPath.row]]
        cell.setColorPreviewColor(colors: K.gradientPreviewDict[colors[indexPath.section][indexPath.row]]!)
//        cell.colorPreview.backgroundColor = K.colorsDict[colors[indexPath.section][indexPath.row]]
        
        return cell
    }
    
    
}

//extension ThemesViewController: UICollectionViewDelegate{
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //setting new theme
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.changeTheme(color: colors[indexPath.row])
//        print("theme color clicked.")
//        //hide and unhide the navbar to basically refresh it
//        self.navigationController?.isNavigationBarHidden = true
//        self.navigationController?.isNavigationBarHidden = false
//
//        self.tabBarController!.tabBar.barTintColor = colors[indexPath.row]
//
//
//
//    }
//
//}
//
//extension ThemesViewController: UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return colors.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeCell", for: indexPath)
//        cell.backgroundColor = colors[indexPath.row]
//        return cell
//
//    }
//
//
//}
