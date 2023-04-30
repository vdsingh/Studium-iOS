//
//  TimePickerCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

//TODO: Docstrings
public protocol UITimePickerDelegate {
    
    //TODO: Docstrings
    func pickerValueChanged(sender: UIDatePicker, indexPath: IndexPath, pickerID: FormCellID.TimePickerCell)
}

//TODO: Docstrings
class TimePickerCell: BasicCell {
    
    //TODO: Docstrings
    public var formCellID: FormCellID.TimePickerCell?
    
    //TODO: Docstrings
    @IBOutlet weak var picker: UIDatePicker!
    
    //TODO: Docstrings
    var delegate: UITimePickerDelegate?
    
    //TODO: Docstrings
    var indexPath : IndexPath?
    
    //TODO: Docstrings
    var pickerID: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.picker.setValue(UIColor.white, forKeyPath: "textColor")
        self.picker.timeZone = NSTimeZone.local
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }
    }
    
    //TODO: Docstrings
    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {
        guard let indexPath = self.indexPath, let formCellID = self.formCellID else {
            print("$ERR (TimePickerCell): indexPath or formCellID were nil.\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
            return
        }
        
        guard let delegate = self.delegate else {
            print("$ERR (TimePickerCell): delegate is nil.\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
            return
        }
        
        delegate.pickerValueChanged(sender: sender, indexPath: indexPath, pickerID: formCellID)
    }
    
    //TODO: Docstrings
    func setPickerMode(datePickerMode: UIDatePicker.Mode) {
        self.picker.datePickerMode = datePickerMode
    }
}

extension TimePickerCell: FormCellProtocol {
    public static var id: String = "TimePickerCell"
}
