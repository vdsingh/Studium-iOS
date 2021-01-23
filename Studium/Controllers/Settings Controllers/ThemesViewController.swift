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

class ThemesViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var themeNames: [[String]] = [["Black"],["Red", "Orange", "Yellow", "Green", "Teal", "Blue", "Purple"], ["NEW RED"]]
    var colors: [[String]] = [["black"], ["flatRed","flatOrange","flatYellow","flatGreen","flatTeal", "flatBlue", "flatPurple"], ["redorangeGradient"]]
    
    
//
    
    var sectionHeaders: [String] = ["Boring", "Muted Colors", "Gradients"]
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ThemeCell", bundle: nil), forCellReuseIdentifier: "ThemeCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
}

extension ThemesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let color: UIColor = K.colorsDict[colors[indexPath.section][indexPath.row]] ?? UIColor.black
        
        appDelegate.changeTheme(colorKey: colors[indexPath.section][indexPath.row])
        //hide and unhide the navbar to basically refresh it
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController!.tabBar.barTintColor = color
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension ThemesViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return themeNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeNames[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell", for: indexPath) as! ThemeCell
        cell.label.text = themeNames[indexPath.section][indexPath.row]
//        let color: UIColor = UIColor(hexString: colors[indexPath.section][indexPath.row])!
        cell.colorPreview.tintColor = K.colorsDict[colors[indexPath.section][indexPath.row]]
        
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
