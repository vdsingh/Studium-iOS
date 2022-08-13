//
//  TimePickerCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

protocol UITimePickerDelegate {
    func pickerValueChanged(sender: UIDatePicker, indexPath: IndexPath)
}

class TimePickerCell: BasicCell {
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

//        let date = Date(dateString: "5:30 PM", format: "h:mm a")
//        picker.setDate(date, animated: true)
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {
       delegate?.pickerValueChanged(sender: sender, indexPath: indexPath!)
    }
    
}

extension TimePickerCell: FormCell {
    public static var id: String = "TimePickerCell"
}
