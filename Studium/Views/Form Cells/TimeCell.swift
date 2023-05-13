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

    /// Label usually used to display what the date represents (ex: "start time")
    @IBOutlet weak var label: UILabel!
    
    /// Label that displays a date
    @IBOutlet weak var timeLabel: UILabel!
    
    /// The date that we want to display
    private var date: Date!
    
    /// The format that we want to use to display the date
    private var dateFormat: DateFormat!
    
    /// The mode of the date picker
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
