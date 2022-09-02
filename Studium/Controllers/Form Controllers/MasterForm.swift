//
//  MasterForm.swift
//  Studium
//
//  Created by Vikram Singh on 7/1/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

public let kCellBackgroundColor = UIColor.secondarySystemBackground

/// Form cells and all their necessary information to build a form
public enum FormCell: Equatable {
    public static func == (lhs: FormCell, rhs: FormCell) -> Bool {
        return "\(lhs)" == "\(rhs)"
    }
    
    case textFieldCell(placeholderText: String, id: FormCellID.TextFieldCell, textFieldDelegate: UITextFieldDelegate, delegate: UITextFieldDelegateExt)
    case switchCell(cellText: String, switchDelegate: CanHandleSwitch?, infoDelegate: CanHandleInfoDisplay?)
    case labelCell(cellText: String, textColor: UIColor = .label, backgroundColor: UIColor = kCellBackgroundColor, cellAccessoryType: UITableViewCell.AccessoryType = .none, onClick: (() -> Void)? = nil)
    case timeCell(cellText: String, date: Date, dateFormat: String, id: FormCellID.TimeCell, onClick: ((IndexPath) -> Void)? = nil)
    case timePickerCell(dateString: String, dateFormat: String, id: FormCellID.TimePickerCell, delegate: UITimePickerDelegate)
    case daySelectorCell(delegate: DaySelectorDelegate)
    case segmentedControlCell(firstTitle: String, secondTitle: String, delegate: SegmentedControlDelegate)
    case colorPickerCell(delegate: ColorDelegate)
    case pickerCell(cellText: String, tag: FormCellID.PickerCell, delegate: UIPickerViewDelegate, dataSource: UIPickerViewDataSource)
    case logoCell(imageString: String, onClick: (() -> Void)? = nil)
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

typealias MasterForm = MasterFormClass

//characteristics of all forms.
let kLargeCellHeight: CGFloat = 150
let kMediumCellHeight: CGFloat = 60
let kNormalCellHeight: CGFloat = 50
class MasterFormClass: UITableViewController, UNUserNotificationCenterDelegate, AlertInfoStorer, LogoStorer, UITimePickerDelegate {

    var systemImageString: String = "book.fill"
    var startDate: Date = Date()
    var endDate: Date = Date() + (60*60)
    
    var alertTimes: [Int] = []
    
    var cells: [[FormCell]] = [[]]
    
    //reference to the realm database.
    let app = App(id: Secret.appID)
    
    var realm: Realm!
    
    override func viewDidLoad() {
        guard let user = app.currentUser else {
            print("Error getting user in MasterForm")
            return
        }

        realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
        
        /// registering the necessary cells for the form.
        tableView.register(UINib(nibName: TextFieldCell.id, bundle: nil), forCellReuseIdentifier: TextFieldCell.id)
        tableView.register(UINib(nibName: TimeCell.id, bundle: nil), forCellReuseIdentifier: TimeCell.id)
        tableView.register(UINib(nibName: PickerCell.id, bundle: nil), forCellReuseIdentifier: PickerCell.id)
        tableView.register(UINib(nibName: TimePickerCell.id, bundle: nil), forCellReuseIdentifier: TimePickerCell.id)
        tableView.register(UINib(nibName: LabelCell.id, bundle: nil), forCellReuseIdentifier: LabelCell.id)
        tableView.register(UINib(nibName: SwitchCell.id, bundle: nil), forCellReuseIdentifier: SwitchCell.id)
        tableView.register(UINib(nibName: DaySelectorCell.id, bundle: nil), forCellReuseIdentifier: DaySelectorCell.id)
        tableView.register(UINib(nibName: LogoCell.id, bundle: nil), forCellReuseIdentifier: LogoCell.id)
        tableView.register(UINib(nibName: ColorPickerCell.id, bundle: nil), forCellReuseIdentifier: ColorPickerCell.id)
        tableView.register(UINib(nibName: SegmentedControlCell.id, bundle: nil), forCellReuseIdentifier: SegmentedControlCell.id)

    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor.systemBackground

      return headerView
    }
    
    func processAlertTimes() {
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cells[indexPath.section][indexPath.row]
        switch cell {
        case .textFieldCell(let placeholderText, let id, let textFieldDelegate, let delegate):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.id, for: indexPath) as! TextFieldCell
            cell.textField.placeholder = placeholderText
            cell.textField.delegate = textFieldDelegate
            cell.delegate = delegate
            cell.textFieldID = id
            return cell
        case .switchCell(let cellText, let switchDelegate, let infoDelegate):
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.id, for: indexPath) as! SwitchCell
            cell.switchDelegate = switchDelegate
            cell.infoDelegate = infoDelegate
            cell.label.text = cellText
            return cell
        case .labelCell(let cellText, let textColor, let backgroundColor, let cellAccessoryType, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: LabelCell.id, for: indexPath) as! LabelCell
            cell.label.text = cellText
            cell.label.textColor = textColor
            cell.backgroundColor = backgroundColor
            cell.accessoryType = cellAccessoryType
            return cell
        case .timeCell(let cellText, let date, let dateFormat, let id, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: TimeCell.id, for: indexPath) as! TimeCell
            cell.label.text = cellText
            cell.timeLabel.text = date.format(with: "h:mm a")
            cell.date = date
            cell.dateFormat = dateFormat
            cell.formCellID = id
            return cell
        case .timePickerCell(let dateString, let dateFormat, let formCellID, let delegate):
            let cell = tableView.dequeueReusableCell(withIdentifier: TimePickerCell.id, for: indexPath) as! TimePickerCell
            cell.delegate = delegate
            cell.indexPath = indexPath
            cell.formCellID = formCellID
            let dateString = dateString
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            if let date = dateFormatter.date(from: dateString) {
                cell.picker.setDate(date, animated: true)
            } else {
                print("$ ERROR: date is nil. \n File: \(#file)\nFunction: \(#function)\nLine: \(#line)")
            }
            return cell
        case .daySelectorCell(let delegate):
            let cell = tableView.dequeueReusableCell(withIdentifier: DaySelectorCell.id, for: indexPath) as! DaySelectorCell
            cell.delegate = delegate
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
        case .pickerCell(_, let tag, let delegate, let dataSource):
            let cell = tableView.dequeueReusableCell(withIdentifier: PickerCell.id, for: indexPath) as! PickerCell
            cell.picker.delegate = delegate
            cell.picker.dataSource = dataSource
            cell.picker.tag = tag.rawValue
//            if resetAll{
//                cell.picker.selectRow(1, inComponent: 0, animated: true)
//            }
            cell.indexPath = indexPath
            return cell
        case .logoCell(let imageString, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: LogoCell.id, for: indexPath) as! LogoCell
            cell.setImage(systemImageName: imageString)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = cells[indexPath.section][indexPath.row]
        switch cell {
        case .timeCell(_, _, _, _, let onClick):
            if let onClick = onClick {
                onClick(indexPath)
            }
        case .logoCell(_, let onClick):
            if let onClick = onClick {
                onClick()
            }
        case .labelCell(_, _, _, _, let onClick):
            if let onClick = onClick {
                onClick()
            }
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = cells[indexPath.section][indexPath.row]
        switch cell{
        case .pickerCell, .timePickerCell, .colorPickerCell:
            return kLargeCellHeight
        case .logoCell:
            return kMediumCellHeight
        default:
            return kNormalCellHeight
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? LogoSelectorViewController {
            destinationVC.delegate = self
            guard let colorCellRow = cells[2].firstIndex(where: { cell in
                if case .colorPickerCell = cell {
                    return true
                }
                return false
            }) else {
                return
            }

            guard let colorCell = tableView.cellForRow(at: IndexPath(row: colorCellRow, section: 2)) as? ColorPickerCell else {
                return
            }
            destinationVC.color = colorCell.colorPreview.backgroundColor ?? .white
        }else if let destinationVC = segue.destination as? AlertTableViewController{
            destinationVC.delegate = self
        }
    }
    
    
    //when we pick a logo, this function is called to update the preview on the logo cell.
    func refreshLogoCell() {
        guard let logoCellIndexPath = self.findFirstLogoCellIndex() else {
            print("$ ERROR: Can't locate logo cell")
            return
        }
        guard let logoCell = tableView.cellForRow(at: logoCellIndexPath) as? LogoCell else {
            print("$ ERROR: LogoCell not found")
            return
        }
        logoCell.setImage(systemImageName: systemImageString)
    }
}

// MARK: - FormCell Searching
extension MasterFormClass {
    func findFirstLogoCellIndex() -> IndexPath? {
        for i in 0..<cells.count {
            for j in 0..<cells[i].count {
                switch cells[i][j] {
                case .logoCell:
                    return IndexPath(row: j, section: i)
                default:
                    continue
                }
            }
        }

        return nil
    }
    
    func findFirstPickerCellIndex(section: Int) -> Int? {
        for i in 0..<cells[section].count {
            switch cells[section][i] {
            case .timePickerCell:
                return i
            default:
                continue
            }
        }
        return nil
    }
}

// MARK: - FormCell Mutations
extension MasterFormClass {
    func replaceLabelText(text: String, section: Int, row: Int) {
        let oldCell = cells[section][row]
        switch oldCell {
        case .labelCell(_, let textColor, let backgroundColor, let cellAccessoryType, let onClick):
            cells[section][row] = .labelCell(cellText: text,
                                             textColor: textColor,
                                             backgroundColor: backgroundColor,
                                             cellAccessoryType: cellAccessoryType,
                                             onClick: onClick)
            tableView.reloadData()
        default:
            return
        }
    }
    
    func timeCellClicked(indexPath: IndexPath) {
        guard let timeCell = tableView.cellForRow(at: indexPath) as? TimeCell else {
            print("$ ERROR: Time Cell Mismatch.\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
            return
        }
        
        var timeCellIndex = indexPath.row
        tableView.beginUpdates()
        
        /// Find the first time picker (if there is one) and remove it
        if let indexOfFirstTimePicker = self.findFirstPickerCellIndex(section: indexPath.section) {
            cells[indexPath.section].remove(at: indexOfFirstTimePicker)
            tableView.deleteRows(at: [IndexPath(row: indexOfFirstTimePicker, section: indexPath.section)], with: .right)
            /// Clicked on time cell while corresopnding timepicker is already expanded.
            if indexOfFirstTimePicker == indexPath.row + 1 {
                tableView.endUpdates()
                return
            /// Clicked on time cell while above timepicker is expanded
            } else if indexOfFirstTimePicker == indexPath.row - 1 {
                /// Remove one from the index since we removed a cell above
                timeCellIndex -= 1
            }
        }
        var timePickerID = FormCellID.TimePickerCell.startDateTimePicker
        switch timeCell.formCellID {
        case .endTimeCell:
            timePickerID = FormCellID.TimePickerCell.endDateTimePicker
        case .startTimeCell:
            timePickerID = FormCellID.TimePickerCell.startDateTimePicker
        case .lengthTimeCell:
            timePickerID = FormCellID.TimePickerCell.lengthTimePicker
        default:
            print("$ ERROR: unexpected cell ID.\nFile: \(#file)\nFunction:\(#function)\nLine:\(#line)")
            return
        }
        
        cells[indexPath.section].insert(
            .timePickerCell(dateString: "\(timeCell.date!.format(with: "h:mm a"))",
                            dateFormat: timeCell.dateFormat,
                            id: timePickerID,
                            delegate: self),
            at: timeCellIndex + 1)
        tableView.insertRows(at: [IndexPath(row: timeCellIndex + 1, section: indexPath.section)], with: .left)
        tableView.endUpdates()
    }
    
    func pickerValueChanged(sender: UIDatePicker, indexPath: IndexPath, pickerID: FormCellID.TimePickerCell) {
        //we are getting the timePicker's corresponding timeCell by accessing its indexPath and getting the element in the tableView right before it. This is always the timeCell it needs to update. The indexPath of the timePicker is stored in the cell's class upon creation, so that it can be passed to this function when needed.
        guard let correspondingTimeCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as? TimeCell else {
            print("$ ERROR: couldn't find TimeCell when changing picker value.\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
            return
        }
        correspondingTimeCell.date = sender.date
        correspondingTimeCell.timeLabel.text = correspondingTimeCell.date!.format(with: "h:mm a")
        
        switch pickerID {
        case .startDateTimePicker:
            self.startDate = sender.date
            print("$ LOG: updated startDate \(self.startDate)")
        case .endDateTimePicker:
            self.endDate = sender.date
            print("$ LOG: updated endDate \(self.endDate)")
        default:
            print("$ ERROR: unexpected TimePicker ID.\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
        }
    }
    
    func navigateToLogoSelection() {
        self.performSegue(withIdentifier: "toLogoSelection", sender: self)
    }
    
    func navigateToAlertTimes() {
        self.performSegue(withIdentifier: "toAlertSelection", sender: self)
    }
}

//makes the keyboard dismiss when user clicks done
extension UIViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
