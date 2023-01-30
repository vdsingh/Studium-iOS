//
//  TimeCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

class TimeCell: BasicCell {
    public var formCellID: FormCellID.TimeCell?

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    private var date: Date
    private var dateFormat: DateFormat
    
    private var timePickerMode: UIDatePicker.Mode
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.timeLabel.text = date.format(with: self.dateFormat.rawValue)
        self.backgroundColor = defaultBackgroundColor
    }
    
    func configure(
        cellLabelText: String,
        formCellID: FormCellID.TimeCell?,
        date: Date,
        dateFormat: DateFormat,
        timePickerMode: UIDatePicker.Mode
    ) {
        self.label.text = cellLabelText
        self.formCellID = formCellID
        self.date = date
        self.dateFormat = dateFormat
        self.timePickerMode = timePickerMode
    }
    
    // MARK: - Getters

    func getDate() -> Date {
        return self.date
    }
    
    func getDateFormat() -> DateFormat{
        return self.dateFormat
    }
    
    func getTimePickerMode() -> UIDatePicker.Mode {
        return self.timePickerMode
    }
    
    // MARK: - Setters
    func setDate(_ date: Date) {
        self.date = date
        self.timeLabel.text = date.format(with: self.dateFormat.rawValue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TimeCell: FormCellProtocol {
    public static var id: String = "TimeCell"
}
