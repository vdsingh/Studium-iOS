//
//  TimeCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

//TODO: Docstrings
public class TimeCell: BasicCell {
    
    //TODO: Docstrings
    public var formCellID: FormCellID.TimeCellID?

    /// Label usually used to display what the date represents (ex: "start time")
    @IBOutlet weak var label: UILabel!
    
    /// Label that displays a date
    @IBOutlet weak var timeLabel: UILabel!
    
    /// The date that we want to display
    private var date: Date!
    
    /// The format that we want to use to display the date
    private var dateFormat: String!
    
    /// The mode of the date picker
    private var timePickerMode: UIDatePicker.Mode!

    override public func awakeFromNib() {
        super.awakeFromNib()
//        self.backgroundColor = StudiumColor.secondaryBackground.uiColor
        self.label.textColor = ColorManager.primaryTextColor
        self.timeLabel.textColor = ColorManager.primaryTextColor
    }
    
    //TODO: Docstrings
    public func configure(
        cellLabelText: String,
        formCellID: FormCellID.TimeCellID?,
        date: Date,
        dateFormat: String,
        timePickerMode: UIDatePicker.Mode
    ) {
        self.label.text = cellLabelText
        self.formCellID = formCellID
        self.date = date
        self.timeLabel.text = date.format(with: dateFormat)
        self.dateFormat = dateFormat
        self.timePickerMode = timePickerMode
    }
    
    // MARK: - Getters

    //TODO: Docstrings
    public func getDate() -> Date {
        return self.date
    }
    
    //TODO: Docstrings
    public func getDateFormat() -> String {
        return self.dateFormat
    }
    
    //TODO: Docstrings
    public func getTimePickerMode() -> UIDatePicker.Mode {
        return self.timePickerMode
    }
    
    // MARK: - Setters
    
    //TODO: Docstrings
    public func setDate(_ date: Date) {
        self.date = date
        self.timeLabel.text = date.format(with: self.dateFormat)
    }
}

extension TimeCell: FormCellProtocol {
    public static var id: String = "TimeCell"
}
