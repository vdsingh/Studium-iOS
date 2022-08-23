//
//  LogoSelectorCollectionViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/12/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
protocol LogoStorer{
    var systemImageString: String { get set}
    func refreshLogoCell()
}
class LogoSelectorViewController: UIViewController {
    var delegate: LogoStorer?
    var color: UIColor = .systemBackground
    @IBOutlet weak var collectionView: UICollectionView!
    
    //logos available if OS is less than 14
    var systemCourseLogoNames: [String] = ["plus", "minus", "multiply", "divide","function", "pencil", "folder", "book", "film", "lightbulb", "tv"]
    
    var systemHabitLogoNames: [String] = ["heart","envelope", "sun.max", "moon", "zzz", "sparkles", "cloud","mic", "message", "phone","paperplane","hammer", "map","gamecontroller", "headphones","car", "airplane", "bolt", "creditcard", "cart"]
                                     
    var letterAndNumberNames: [String] = [ "a.circle","b.circle","c.circle","d.circle","e.circle","f.circle","g.circle","h.circle","i.circle","j.circle","k.circle","l.circle","m.circle","n.circle","o.circle","p.circle","q.circle","r.circle","s.circle","t.circle","u.circle","v.circle","w.circle","x.circle","y.circle","z.circle", "1.circle","2.circle","3.circle","4.circle","5.circle","6.circle","7.circle","8.circle","9.circle","10.circle"]
    
    //logos available if OS is 14 or greater.
    var iOS14SystemLogoNames: [String] = ["atom", "cross", "leaf", "lungs", "comb", "guitars", "laptopcomputer", "cpu","ipad", "ipodtouch", "wrench.and.screwdriver", "gearshape", "graduationcap",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "LogoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LogoCollectionViewCell")
    }
}

extension LogoSelectorViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var logoNames = systemCourseLogoNames + systemHabitLogoNames;
        if #available(iOS 14.0, *) {
            logoNames += iOS14SystemLogoNames + letterAndNumberNames
        } else {
            logoNames += letterAndNumberNames
        }
        delegate?.systemImageString = logoNames[indexPath.row]
        delegate?.refreshLogoCell()
        self.navigationController?.popViewController(animated: true)
    }
}

extension LogoSelectorViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if #available(iOS 14.0, *){
            return iOS14SystemLogoNames.count + letterAndNumberNames.count + systemCourseLogoNames.count + systemHabitLogoNames.count
        }else{
            return letterAndNumberNames.count + systemCourseLogoNames.count + systemHabitLogoNames.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var logoNames = systemCourseLogoNames + systemHabitLogoNames;
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LogoCollectionViewCell", for: indexPath) as! LogoCollectionViewCell
        if #available(iOS 14.0, *) {
            logoNames += iOS14SystemLogoNames + letterAndNumberNames
        } else {
            logoNames += letterAndNumberNames
        }
        cell.setImage(systemImageName: logoNames[indexPath.row], tintColor: color )
        return cell
    }
}

extension LogoSelectorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}
