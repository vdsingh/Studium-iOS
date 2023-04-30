//
//  TimeCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

//TODO: Docstrings
class TimeCell: BasicCell {
    
    //TODO: Docstrings
    public var formCellID: FormCellID.TimeCell?

    //TODO: Docstrings
    @IBOutlet weak var label: UILabel!
    
    //TODO: Docstrings
    @IBOutlet weak var timeLabel: UILabel!
    
    //TODO: Docstrings
    private var date: Date!
    
    //TODO: Docstrings
    private var dateFormat: DateFormat!
    
    //TODO: Docstrings
    private var timePickerMode: UIDatePicker.Mode!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = StudiumColor.secondaryBackground.uiColor
        self.label.textColor = StudiumColor.primaryLabel.uiColor
        self.timeLabel.textColor = StudiumColor.primaryLabel.uiColor
    }
    
    //TODO: Docstrings
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
        self.timeLabel.text = date.format(with: dateFormat.rawValue)
        self.dateFormat = dateFormat
        self.timePickerMode = timePickerMode
    }
    
    // MARK: - Getters

    //TODO: Docstrings
    func getDate() -> Date {
        return self.date
    }
    
    //TODO: Docstrings
    func getDateFormat() -> DateFormat{
        return self.dateFormat
    }
    
    //TODO: Docstrings
    func getTimePickerMode() -> UIDatePicker.Mode {
        return self.timePickerMode
    }
    
    // MARK: - Setters
    
    //TODO: Docstrings
    func setDate(_ date: Date) {
        self.date = date
        self.timeLabel.text = date.format(with: self.dateFormat.rawValue)
    }
}

extension TimeCell: FormCellProtocol {
    public static var id: String = "TimeCell"
}
