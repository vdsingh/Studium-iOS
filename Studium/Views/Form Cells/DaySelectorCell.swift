//
//  DaySelectorCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift

//TODO: Docstrings
public protocol DaySelectorDelegate {
    func updateDaysSelected(weekdays: Set<Weekday>)
}

//TODO: Docstrings
class DaySelectorCell: BasicCell {
    
    //TODO: Docstrings
    var delegate: DaySelectorDelegate?
    
    //TODO: Docstrings
    @IBOutlet var dayButtons: [UIButton]!
    
    //TODO: Docstrings
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
    
    //TODO: Docstrings
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

    //TODO: Docstrings
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
