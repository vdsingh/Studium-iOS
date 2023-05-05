//
//  LogoSelectorCollectionViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/12/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

// TODO: Docstrings
protocol LogoSelectionHandler {
    
    // TODO: Docstrings
//    var logo: SystemIcon { get set }
    
    // TODO: Docstrings
//    func refreshLogoCell()
    
    func logoWasUpdated(logo: SystemIcon)
}

// TODO: Docstrings
class LogoSelectorViewController: UIViewController {
    
    // TODO: Docstrings
    var delegate: LogoSelectionHandler?
    
    // TODO: Docstrings
    var color: UIColor = StudiumColor.background.uiColor
    
    // TODO: Docstrings
    @IBOutlet weak var collectionView: UICollectionView!
    
    // TODO: Docstrings
    var logos: [SystemIcon] = SystemIcon.allCases
    //logos available if OS is less than 14
//    var systemCourseLogoNames: [String] = ["plus", "minus", "multiply", "divide","function", "pencil", "folder", "book", "film", "lightbulb", "tv"]
//
//    var systemHabitLogoNames: [String] = ["heart","envelope", "sun.max", "moon", "zzz", "sparkles", "cloud","mic", "message", "phone","paperplane","hammer", "map","gamecontroller", "headphones","car", "airplane", "bolt", "creditcard", "cart"]
//
//    var letterAndNumberNames: [String] = [ "a.circle","b.circle","c.circle","d.circle","e.circle","f.circle","g.circle","h.circle","i.circle","j.circle","k.circle","l.circle","m.circle","n.circle","o.circle","p.circle","q.circle","r.circle","s.circle","t.circle","u.circle","v.circle","w.circle","x.circle","y.circle","z.circle", "1.circle","2.circle","3.circle","4.circle","5.circle","6.circle","7.circle","8.circle","9.circle","10.circle"]
//
//    //logos available if OS is 14 or greater.
//    var iOS14SystemLogoNames: [String] = ["atom", "cross", "leaf", "lungs", "comb", "guitars", "laptopcomputer", "cpu","ipad", "ipodtouch", "wrench.and.screwdriver", "gearshape", "graduationcap",
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "LogoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LogoCollectionViewCell")
    }
}

// TODO: Docstrings
extension LogoSelectorViewController: UICollectionViewDelegate {
    
    // TODO: Docstrings
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        var logoNames = systemCourseLogoNames + systemHabitLogoNames;
//        if #available(iOS 14.0, *) {
//            logoNames += iOS14SystemLogoNames + letterAndNumberNames
//        } else {
//            logoNames += letterAndNumberNames
//        }
//        delegate?.systemImageString = logoNames[indexPath.row]
//        delegate?.logo = logos[indexPath.row]
//        delegate?.refreshLogoCell()
        delegate?.logoWasUpdated(logo: logos[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}

// TODO: Docstrings
extension LogoSelectorViewController: UICollectionViewDataSource {
    
    // TODO: Docstrings
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if #available(iOS 14.0, *){
//            return iOS14SystemLogoNames.count + letterAndNumberNames.count + systemCourseLogoNames.count + systemHabitLogoNames.count
//        }else{
//            return letterAndNumberNames.count + systemCourseLogoNames.count + systemHabitLogoNames.count
//        }
        return self.logos.count
    }
    
    // TODO: Docstrings
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        var logoNames = systemCourseLogoNames + systemHabitLogoNames;
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LogoCollectionViewCell.id, for: indexPath) as? LogoCollectionViewCell {
            //        if #available(iOS 14.0, *) {
            //            logoNames += iOS14SystemLogoNames + letterAndNumberNames
            //        } else {
            //            logoNames += letterAndNumberNames
            //        }
            cell.setImage(systemIcon: logos[indexPath.row], tintColor: color)
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
