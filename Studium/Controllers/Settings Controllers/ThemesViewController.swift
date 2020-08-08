//
//  ThemesViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/4/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class ThemesViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var colors: [UIColor] = [.red, .orange, .yellow, .green, .systemTeal, .blue, .brown, .purple, .systemPink]
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false

    }
}

extension ThemesViewController: UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //setting new theme
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        K.themeColor = colors[indexPath.row]
        appDelegate.changeTheme(color: K.themeColor)
        print("theme color clicked.")
        //hide and unhide the navbar to basically refresh it
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isNavigationBarHidden = false
        
        self.tabBarController!.tabBar.barTintColor = K.themeColor



    }
    
}

extension ThemesViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeCell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        return cell

    }
    
    
}
