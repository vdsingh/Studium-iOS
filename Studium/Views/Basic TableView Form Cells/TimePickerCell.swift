//
//  TimePickerCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

public protocol UITimePickerDelegate {
    func pickerValueChanged(sender: UIDatePicker, indexPath: IndexPath, pickerID: FormCellID.TimePickerCell)
}

class TimePickerCell: BasicCell {
    public var formCellID: FormCellID.TimePickerCell?
    
    @IBOutlet weak var picker: UIDatePicker!
    
    var delegate: UITimePickerDelegate?
    var indexPath : IndexPath?
    var pickerID: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        picker.timeZone = NSTimeZone.local
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }

        self.backgroundColor = defaultBackgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {
        guard let indexPath = self.indexPath, let formCellID = self.formCellID else {
            print("$ ERROR: indexPath or formCellID were nil.\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
            return
        }
        
        guard let delegate = self.delegate else {
            print("$ ERROR: delegate is nil.\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
            return
        }
        
        delegate.pickerValueChanged(sender: sender, indexPath: indexPath, pickerID: formCellID)
    }
}

extension TimePickerCell: FormCellProtocol {
    public static var id: String = "TimePickerCell"
}
