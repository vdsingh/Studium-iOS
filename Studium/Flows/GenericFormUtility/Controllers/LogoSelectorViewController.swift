//
//  LogoSelectorCollectionViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/12/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import VikUtilityKit
import TableViewFormKit

// TODO: Docstrings
protocol LogoSelectionHandler {

    func logoWasUpdated(icon: StudiumIcon)
}

// TODO: Docstrings
class LogoSelectorViewController: UIViewController, Storyboarded {
    
    // TODO: Docstrings
    var delegate: LogoSelectionHandler?
    
    // TODO: Docstrings
    var color: UIColor = StudiumColor.background.uiColor
    
    // TODO: Docstrings
    @IBOutlet weak var collectionView: UICollectionView!
    
    // TODO: Docstrings
    var logos: [StudiumIcon] = StudiumIcon.allCases

    override func loadView() {
        super.loadView()
        self.collectionView.register(LogoCollectionViewCell.self, forCellWithReuseIdentifier: LogoCollectionViewCell.id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = StudiumColor.background.uiColor
        self.collectionView.backgroundColor = StudiumColor.background.uiColor
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
}

// TODO: Docstrings
extension LogoSelectorViewController: UICollectionViewDelegate {
    
    // TODO: Docstrings
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.logoWasUpdated(icon: logos[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}

// TODO: Docstrings
extension LogoSelectorViewController: UICollectionViewDataSource {
    
    // TODO: Docstrings
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.logos.count
    }
    
    // TODO: Docstrings
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LogoCollectionViewCell.id, for: indexPath) as? LogoCollectionViewCell {
            cell.setup()
            cell.setImage(image: logos[indexPath.row].uiImage, tintColor: .white)
            return cell
        }
        
        fatalError("$ERR: couldn't cast cell to LogoCollectionViewCell at \(indexPath)")
    }
}

// TODO: Docstrings
extension LogoSelectorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}
