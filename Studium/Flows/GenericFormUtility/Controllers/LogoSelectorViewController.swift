//
//  LogoSelectorCollectionViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/12/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

class SectionHeader: UICollectionReusableView {
    
    static let id = "SectionHeader"
    
    var label: UILabel = {
        let label = UILabel()
        label.textColor = StudiumColor.primaryLabel.uiColor
        label.font = StudiumFont.subTitle.uiFont
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(label)

        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        self.label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
   }

   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

    func setup(headerText: String) {
        self.label.text = headerText
   }
}

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
//    var logos: [StudiumIcon] = StudiumIcon.allCases
    var iconGroups: [StudiumIconGroup] = StudiumIconGroup.allCases

    override func loadView() {
        super.loadView()
        self.collectionView.register(LogoCollectionViewCell.self, forCellWithReuseIdentifier: LogoCollectionViewCell.id)
        self.collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.id)
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
        let icon = self.iconGroups[indexPath.section].icons[indexPath.row]
        self.delegate?.logoWasUpdated(icon: icon)
        self.navigationController?.popViewController(animated: true)
    }
}

// TODO: Docstrings
extension LogoSelectorViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.iconGroups.count
    }
    
    // TODO: Docstrings
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.iconGroups[section].icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.id, for: indexPath) as? SectionHeader {
//            sectionHeader.sectionHeaderlabel.text = "Section \(indexPath.section)"
            let iconGroupLabel = self.iconGroups[indexPath.section].label
            sectionHeader.setup(headerText: iconGroupLabel)
            return sectionHeader
        }

        return UICollectionReusableView()
    }
    
    // TODO: Docstrings
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LogoCollectionViewCell.id, for: indexPath) as? LogoCollectionViewCell {
            cell.setup()
            let image = self.iconGroups[indexPath.section].icons[indexPath.row].uiImage
            cell.setImage(image: image, tintColor: .white)
            return cell
        }
        
        fatalError("$ERR: couldn't cast cell to LogoCollectionViewCell at \(indexPath)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
}

// TODO: Docstrings
extension LogoSelectorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
}
