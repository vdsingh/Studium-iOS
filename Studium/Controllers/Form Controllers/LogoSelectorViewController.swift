//
//  LogoSelectorCollectionViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/12/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import ChameleonFramework
protocol LogoStorer{
    var systemImageString: String { get set}
    func refreshLogoCell()
}
class LogoSelectorViewController: UIViewController {
    var delegate: LogoStorer?
    var color: UIColor?
    @IBOutlet weak var collectionView: UICollectionView!
    var systemLogoNames: [String] = ["mic.fill", "message.fill", "phone.fill", "envelope.fill", "sun.max.fill", "moon.fill", "zzz", "sparkles", "cloud.fill", "pencil", "trash.fill", "folder.fill", "paperplane.fill", "book.fill", "hammer.fill", "lock.fill", "map.fill", "film.fill", "gamecontroller.fill", "headphones", "gift.fill", "lightbulb.fill", "tv.fill", "car.fill", "airplane", "bolt.fill", "paragraph", "a", "play.fill", "bag.fill", "creditcard.fill", "cart.fill", "function", "plus", "minus", "multiply", "divide", "number", "heart.fill", "bandage.fill", "trash.fill", "a.circle.fill","b.circle.fill","c.circle.fill","d.circle.fill","e.circle.fill","f.circle.fill","g.circle.fill","h.circle.fill","i.circle.fill","j.circle.fill","k.circle.fill","l.circle.fill","m.circle.fill","n.circle.fill","o.circle.fill","p.circle.fill","q.circle.fill","r.circle.fill","s.circle.fill","t.circle.fill","u.circle.fill","v.circle.fill","w.circle.fill","x.circle.fill","y.circle.fill","z.circle.fill", "1.circle.fill","2.circle.fill","3.circle.fill","4.circle.fill","5.circle.fill","6.circle.fill","7.circle.fill","8.circle.fill","9.circle.fill","10.circle.fill",]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "LogoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LogoCollectionViewCell")
        
        //choose the background of the selection form depending on the color, so that the user can see the form properly.
        collectionView.backgroundColor = UIColor(contrastingBlackOrWhiteColorOn: color!, isFlat: true)
        self.view.backgroundColor = UIColor(contrastingBlackOrWhiteColorOn: color!, isFlat: true)

    }
}

extension LogoSelectorViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.systemImageString = systemLogoNames[indexPath.row]
        delegate?.refreshLogoCell()
        self.navigationController?.popViewController(animated: true)

    }
}

extension LogoSelectorViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return systemLogoNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LogoCollectionViewCell", for: indexPath) as! LogoCollectionViewCell
        cell.setImage(systemImageName: systemLogoNames[indexPath.row], tintColor: color!)
        
//        cell.backgroundColor = .blue
        return cell
        
    }
}

extension LogoSelectorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}
