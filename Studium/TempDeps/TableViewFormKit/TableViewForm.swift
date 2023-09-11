//
//  TableViewForm.swift
//  
//
//  Created by Vikram Singh on 5/14/23.
//

import Foundation
import UIKit

open class TableViewForm: UITableViewController {
    
    // TODO: Docstrings
    open var cells: [[FormCell]] = [[]]
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorManager.primaryBackgroundColor
        self.tableView.separatorColor = ColorManager.tableViewSeparatorColor
        self.registerFormCells()
    }
    
    private func registerFormCells() {
        // registering the necessary cells for the form.
        self.tableView.register(UINib(nibName: TextFieldCell.id, bundle: nil), forCellReuseIdentifier: TextFieldCell.id)
        self.tableView.register(TextFieldCellV2.self, forCellReuseIdentifier: TextFieldCellV2.id)

        self.tableView.register(UINib(nibName: TimeCell.id, bundle: nil), forCellReuseIdentifier: TimeCell.id)
        self.tableView.register(UINib(nibName: PickerCell.id, bundle: nil), forCellReuseIdentifier: PickerCell.id)
        self.tableView.register(UINib(nibName: TimePickerCell.id, bundle: nil), forCellReuseIdentifier: TimePickerCell.id)
        self.tableView.register(DatePickerCell.self, forCellReuseIdentifier: DatePickerCell.id)
        self.tableView.register(UINib(nibName: LabelCell.id, bundle: nil), forCellReuseIdentifier: LabelCell.id)
        self.tableView.register(UINib(nibName: SwitchCell.id, bundle: nil), forCellReuseIdentifier: SwitchCell.id)
        self.tableView.register(UINib(nibName: DaySelectorCell.id, bundle: nil), forCellReuseIdentifier: DaySelectorCell.id)
        self.tableView.register(UINib(nibName: LogoSelectionCell.id, bundle: nil), forCellReuseIdentifier: LogoSelectionCell.id)
        self.tableView.register(UINib(nibName: ColorPickerCell.id, bundle: nil), forCellReuseIdentifier: ColorPickerCell.id)
        self.tableView.register(ColorPickerCellV2.self, forCellReuseIdentifier: ColorPickerCellV2.id)
        self.tableView.register(UINib(nibName: SegmentedControlCell.id, bundle: nil), forCellReuseIdentifier: SegmentedControlCell.id)
    }
    
     
    private func constructErrorString(errors: [any FormError]) -> String {
        let errorsString: String = errors
            .compactMap({ $0.stringRepresentation })
            .joined(separator: "\n")
        return errorsString
    }
}

// MARK: - TableView DataSource
extension TableViewForm {
    // TODO: Docstrings
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cells[indexPath.section][indexPath.row]
        switch cell {
        case .textFieldCell(let placeholderText, let text, let charLimit, let textfieldWasEdited):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCellV2.id, for: indexPath) as! TextFieldCellV2
//            cell.textField.placeholder = placeholderText
//            cell.textFieldWasEdited = textfieldWasEdited
//            cell.delegate = delegate
//            cell.textFieldID = id
//            cell.textField.text = text
//            cell.setCharLimit(charLimit)
            cell.host(parent: self, initialText: text, charLimit: charLimit, placeholder: placeholderText,
                      textfieldWasEdited: textfieldWasEdited)
            
//            let cell = tableView.dequeueReusableCell(withIdentifier: ColorPickerCellV2.id, for: indexPath) as! ColorPickerCellV2
//            cell.host(parent: self, colors: colors, colorWasSelected: colorWasSelected)
//            return cell
            return cell
        case .switchCell(let cellText, let isOn, let switchDelegate, let infoDelegate):
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.id, for: indexPath) as! SwitchCell
            cell.switchDelegate = switchDelegate
            cell.infoDelegate = infoDelegate
            cell.label.text = cellText
            cell.tableSwitch.isOn = isOn
            return cell
        case .labelCell(let cellText, let icon, let textColor, let backgroundColor, let cellAccessoryType, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: LabelCell.id, for: indexPath) as! LabelCell
            cell.label.text = cellText
            cell.label.textColor = textColor
            cell.backgroundColor = backgroundColor
            cell.accessoryType = cellAccessoryType
            cell.setIcon(iconImage: icon)
            return cell
        case .errorCell(let errors):
            let cell = tableView.dequeueReusableCell(withIdentifier: LabelCell.id, for: indexPath) as! LabelCell
            cell.label.text = self.constructErrorString(errors: errors)
            cell.label.textColor = ColorManager.failure
            cell.label.numberOfLines = 0
            cell.setIcon(iconImage: nil)
            cell.backgroundColor = ColorManager.primaryBackgroundColor
            cell.accessoryType = .none
            return cell
        case .timeCell(let cellText, let date, let dateFormat, let timePickerMode, let id, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: TimeCell.id, for: indexPath) as! TimeCell
            cell.configure(cellLabelText: cellText, formCellID: id, date: date, dateFormat: dateFormat, timePickerMode: timePickerMode)
            return cell
        case .timePickerCell(let date, let dateFormat, let timePickerMode, let formCellID, let delegate):
            let cell = tableView.dequeueReusableCell(withIdentifier: TimePickerCell.id, for: indexPath) as! TimePickerCell
            cell.delegate = delegate
            cell.indexPath = indexPath
            cell.formCellID = formCellID
            cell.picker.datePickerMode = timePickerMode
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat.rawValue
            cell.picker.setDate(date, animated: true)
            return cell
        case .datePickerCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerCell.id, for: indexPath) as! DatePickerCell
            cell.host(parent: self)
            return cell
        case .daySelectorCell(let daysSelected, let delegate):
            let cell = tableView.dequeueReusableCell(withIdentifier: DaySelectorCell.id, for: indexPath) as! DaySelectorCell
            cell.delegate = delegate
            cell.selectDays(days: daysSelected)
            return cell
        case .segmentedControlCell(let firstTitle, let secondTitle, let delegate):
            let cell = tableView.dequeueReusableCell(withIdentifier: SegmentedControlCell.id, for: indexPath) as! SegmentedControlCell
            cell.segmentedControl.setTitle(firstTitle, forSegmentAt: 0)
            cell.segmentedControl.setTitle(secondTitle, forSegmentAt: 1)
            
            cell.delegate = delegate
            return cell
        case .colorPickerCell(let delegate):
            let cell = tableView.dequeueReusableCell(withIdentifier: ColorPickerCell.id, for: indexPath) as! ColorPickerCell
            cell.delegate = delegate
            return cell
        case .colorPickerCellV2(let colors, let colorWasSelected):
            let cell = tableView.dequeueReusableCell(withIdentifier: ColorPickerCellV2.id, for: indexPath) as! ColorPickerCellV2
            cell.host(parent: self, colors: colors, colorWasSelected: colorWasSelected)
            return cell
        case .pickerCell(_, let indices, let tag, let delegate, let dataSource):
            let cell = tableView.dequeueReusableCell(withIdentifier: PickerCell.id, for: indexPath) as! PickerCell
            cell.picker.delegate = delegate
            cell.picker.dataSource = dataSource
            cell.picker.tag = tag.rawValue
            for i in 0..<indices.count {
                cell.picker.selectRow(indices[i], inComponent: i, animated: true)
            }
            cell.indexPath = indexPath
            return cell
        case .logoCell(let logo, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: LogoSelectionCell.id, for: indexPath) as! LogoSelectionCell
            cell.setImage(image: logo)
            return cell
        }
    }
}
