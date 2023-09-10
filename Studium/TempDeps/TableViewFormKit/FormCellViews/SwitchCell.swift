//
//  SwitchCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

//TODO: Docstrings
public protocol CanHandleSwitch {
    
    //TODO: Docstrings
    func switchValueChanged(sender: UISwitch)
}

//TODO: Docstrings
public protocol CanHandleInfoDisplay: UIViewController {
    
    //TODO: Docstrings
    func displayInformation()
}

//TODO: Docstrings
public class SwitchCell: BasicCell {
    
    //TODO: Docstrings
    @IBOutlet weak public var tableSwitch: UISwitch!
    
    //TODO: Docstrings
    @IBOutlet weak public var label: UILabel!
    
    //TODO: Docstrings
    @IBOutlet weak public var infoButton: UIButton!
    
    //TODO: Docstrings
    public var on: Bool = false
    
    //TODO: Docstrings
    public var switchDelegate: CanHandleSwitch?
    
    //TODO: Docstrings
    public var infoDelegate: CanHandleInfoDisplay?
    
//    var cellBackgroundColor: UIColor {
//        didSet {
//            self.backgroundColor = self.cellBackgroundColor
//        }
//    }
//    
    override public func awakeFromNib() {
        super.awakeFromNib()
//        self.backgroundColor = StudiumColor.secondaryBackground.uiColor
        self.label.textColor = ColorManager.primaryTextColor
        self.infoButton.backgroundColor = ColorManager.cellBackgroundColor
    }
    
    
    //TODO: Docstrings
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        self.on = sender.isOn
        if let del = switchDelegate{
            del.switchValueChanged(sender: sender)
        }
    }

    //TODO: Docstrings
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        if let del = infoDelegate {
            del.displayInformation()
        } else {
           print("error accessing infoDelegate")
        }
    }
    
}

extension SwitchCell: FormCellProtocol {
    public static var id: String = "SwitchCell"
}
