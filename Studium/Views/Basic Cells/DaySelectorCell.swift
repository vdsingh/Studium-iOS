//
//  DaySelectorCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift
protocol DaySelectorDelegate{
    func dayButtonPressed(sender: UIButton)
}
class DaySelectorCell: UITableViewCell {

    var delegate: DaySelectorDelegate?
    
    @IBOutlet var dayButtons: [UIButton]!
    var daysSelected: [String] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func selectDays(days: List<String>){
        daysSelected = []
        for button in dayButtons{
            let buttonText = button.titleLabel?.text
            if days.contains(buttonText!){
                daysSelected.append(buttonText!)
                button.isSelected = true
            }else{
                button.isSelected = false
            }
        }
    }
    
    @IBAction func dayButtonPressed(_ sender: UIButton) {
        delegate!.dayButtonPressed(sender: sender)
        
        
//        let dayTitle = sender.titleLabel!.text
//        if sender.isSelected{
//            sender.isSelected = false
//            for day in daysSelected{
//                if day == dayTitle{//if day is already selected, and we select it again
//                    daysSelected.remove(at: daysSelected.firstIndex(of: day)!)
//                }
//            }
//        }else{//day was not selected, and we are now selecting it.
//            sender.isSelected = true
//            daysSelected.append(dayTitle!)
//        }
    }
    
}
