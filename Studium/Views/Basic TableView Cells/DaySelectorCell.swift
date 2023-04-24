//
//  DaySelectorCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift

public protocol DaySelectorDelegate {
    func updateDaysSelected(weekdays: Set<Weekday>)
}

class DaySelectorCell: BasicCell {
    var delegate: DaySelectorDelegate?
    
    @IBOutlet var dayButtons: [UIButton]!
    
    private var daysSelected = Set<Weekday>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.backgroundColor = StudiumColor.secondaryBackground.uiColor
        
        for button in self.dayButtons {
            button.tintColor = StudiumColor.primaryAccent.uiColor
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func selectDays(days: Set<Weekday>) {
        for day in days {
            if let button = self.dayButtons.first(where: { $0.titleLabel?.text == day.buttonText }) {
                self.daysSelected.insert(day)
                button.isSelected = true
            } else {
                print("$ERR (DaySelectorCell): No Day Button could be found for day \(day) aka \(day.buttonText)")
            }
        }

    }
//    
//    func selectDays(days: [Int]){
//        daysSelected = []
//        for button in dayButtons{
//            let buttonText = button.titleLabel?.text
//            if days.contains(K.weekdayDict[buttonText!]!){
//                daysSelected.append(buttonText!)
//                button.isSelected = true
//            }else{
//                button.isSelected = false
//            }
//        }
//    }
//    
    @IBAction func dayButtonPressed(_ sender: UIButton) {
        
        // Find the index of the button pressed
        //        if let buttonIndex = self.dayButtons.firstIndex(of: sender),
        if let titleLabel = sender.titleLabel,
           let text = titleLabel.text {
            let weekday = Weekday(buttonText: text)
            //            let weekday = Weekday(rawValue: buttonIndex + 1) {
            // Add 1 to the index because Sunday = 1, Monday = 2, etc.
            
            // Day was unselected
            if sender.isSelected {
                sender.isSelected = false
                self.daysSelected.remove(weekday)
            }
            // Day was selected
            else {
                sender.isSelected = true
                self.daysSelected.insert(weekday)
            }
            
            delegate?.updateDaysSelected(weekdays: self.daysSelected)
        } else {
            print("$ERR: Couldn't find the button index or construct a Weekday type")
        }
    }
    
}

extension DaySelectorCell: FormCellProtocol {
    static var id: String = "DaySelectorCell"
}
