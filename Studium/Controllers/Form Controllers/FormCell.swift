//
//  FormCell.swift
//  Studium
//
//  Created by Vikram Singh on 2/1/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

/// Form cells and all their necessary information to build a form
public enum FormCell: Equatable {
    public static func == (lhs: FormCell, rhs: FormCell) -> Bool {
        return "\(lhs)" == "\(rhs)"
    }
    
    case textFieldCell(
        placeholderText: String,
        id: FormCellID.TextFieldCell,
        textFieldDelegate: UITextFieldDelegate,
        delegate: UITextFieldDelegateExt
    )
    
    case switchCell(
        cellText: String,
        switchDelegate: CanHandleSwitch?,
        infoDelegate: CanHandleInfoDisplay?
    )
    
    case labelCell(
        cellText: String,
        textColor: UIColor = .label,
        backgroundColor: UIColor = kCellBackgroundColor,
        cellAccessoryType: UITableViewCell.AccessoryType = .none,
        onClick: (() -> Void)? = nil
    )
    
    case timeCell(
        cellText: String,
        date: Date,
        dateFormat: DateFormat,
        timePickerMode: UIDatePicker.Mode,
        id: FormCellID.TimeCell,
        onClick: ((IndexPath) -> Void)?
    )
    
    case timePickerCell(
        date: Date,
        dateFormat: DateFormat,
        timePickerMode: UIDatePicker.Mode,
        id: FormCellID.TimePickerCell,
        delegate: UITimePickerDelegate
    )
    
    case daySelectorCell(delegate: DaySelectorDelegate)
    
    case segmentedControlCell(
        firstTitle: String,
        secondTitle: String,
        delegate: SegmentedControlDelegate
    )
    
    case colorPickerCell(delegate: ColorDelegate)
    case pickerCell(
        cellText: String,
        tag: FormCellID.PickerCell,
        delegate: UIPickerViewDelegate,
        dataSource: UIPickerViewDataSource
    )
    
    case logoCell(
        logo: SystemIcon,
        onClick: (() -> Void)? = nil
    )
}

/// IDs for FormCells that we can use instead of hardcoded strings
public enum FormCellID {
    
    // TextField Cells
    public enum TextFieldCell {
        case nameTextField
        case locationTextField
        case additionalDetailsTextField
    }
    
    // TimePickerCells
    public enum TimePickerCell {
        case startDateTimePicker
        case endDateTimePicker
        case lengthTimePicker
    }
    
    // TimeCells
    public enum TimeCell {
        case startTimeCell
        case endTimeCell
        case lengthTimeCell
    }
    
    // PickerCells need to be Ints since we use tag
    public enum PickerCell: Int {
        case coursePickerCell = 0
        case lengthPickerCell = 1
    }
}
