//
//  DaySelectorCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

//TODO: Docstrings
public protocol DaySelectorDelegate {
    func updateDaysSelected(weekdays: Set<Weekday>)
}

//TODO: Docstrings
public class DaySelectorCell: BasicCell {
    
    //TODO: Docstrings
    public var delegate: DaySelectorDelegate?
    
    //TODO: Docstrings
    @IBOutlet var dayButtons: [UIButton]!
    
    //TODO: Docstrings
    private var daysSelected = Set<Weekday>()
    
    var buttonTintColor: UIColor = ColorManager.primaryAccentColor {
        didSet {
            for button in self.dayButtons {
                button.tintColor = self.buttonTintColor
            }
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        for button in self.dayButtons {
            button.tintColor = self.buttonTintColor
        }
    }

    //TODO: Docstrings
    public func selectDays(days: Set<Weekday>) {
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
            Log.e("Couldn't find the button index or construct a Weekday type")
        }
    }
    
}

extension DaySelectorCell: FormCellProtocol {
    public static var id: String = "DaySelectorCell"
}
