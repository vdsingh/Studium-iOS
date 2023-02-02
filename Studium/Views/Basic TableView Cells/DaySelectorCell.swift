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
        self.backgroundColor = defaultBackgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //TODO: Finish this function
    func selectDays(days: Set<Weekday>) {
//        daysSelected =
//        daysSelected = []
//        for button in dayButtons{
//            let buttonText = button.titleLabel?.text
//            if days.contains(K.weekdayDict[buttonText!]!){
////            if days.contains(buttonText!){
//                daysSelected.append(buttonText!)
//                button.isSelected = true
//            }else{
//                button.isSelected = false
//            }
//        }
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
        if let buttonIndex = self.dayButtons.firstIndex(of: sender),
            let weekday = Weekday(rawValue: buttonIndex + 1) {
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
            print("$Error: Couldn't find the button index or construct a Weekday type")
        }
    }
    
}

extension DaySelectorCell: FormCellProtocol {
    static var id: String = "DaySelectorCell"
}