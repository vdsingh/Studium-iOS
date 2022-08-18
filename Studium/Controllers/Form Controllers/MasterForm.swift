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

//let cell = tableView.dequeueReusableCell(withIdentifier: LogoCell.id, for: indexPath) as! LogoCell
////cell.delegate = self
//cell.setImage(systemImageName: systemImageString)
//return cell

public let kCellBackgroundColor = UIColor.secondarySystemBackground

public enum FormCell: Equatable {
    public static func == (lhs: FormCell, rhs: FormCell) -> Bool {
        return "\(lhs)" == "\(rhs)"
    }
    

    case textFieldCell(placeholderText: String, id: FormCellID, textFieldDelegate: UITextFieldDelegate, delegate: UITextFieldDelegateExt)
    case switchCell(cellText: String, switchDelegate: CanHandleSwitch?, infoDelegate: CanHandleInfoDisplay?)
    case labelCell(cellText: String, textColor: UIColor = .label, backgroundColor: UIColor = kCellBackgroundColor, cellAccessoryType: UITableViewCell.AccessoryType = .none, onClick: (() -> Void)? = nil)
    case timeCell(cellText: String, date: Date, onClick: ((IndexPath) -> Void)? = nil)
    case timePickerCell(dateString: String, delegate: UITimePickerDelegate)
    case daySelectorCell(delegate: DaySelectorDelegate)
    case segmentedControlCell(firstTitle: String, secondTitle: String, delegate: SegmentedControlDelegate)
    case colorPickerCell(delegate: ColorDelegate)
    case pickerCell(cellText: String, delegate: UIPickerViewDelegate, dataSource: UIPickerViewDataSource)
    case logoCell(imageString: String, onClick: (() -> Void)? = nil)
}

public enum FormCellID {
    case nameTextField
    case locationTextField
    case additionalDetailsTextField
}

typealias MasterForm = MasterFormClass

//characteristics of all forms.
let kLargeCellHeight: CGFloat = 150
let kMediumCellHeight: CGFloat = 60
let kNormalCellHeight: CGFloat = 50
class MasterFormClass: UITableViewController, UNUserNotificationCenterDelegate, AlertInfoStorer{
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
//            if indexPath.section == 0 && indexPath.row == 3{
//                //                cell.label.textColor = .black
//                cell.accessoryType = .disclosureIndicator
//            }else{
//                cell.backgroundColor = .systemBackground
//                cell.label.textColor = UIColor.red
//            }
//            cell.label.text = cellText[indexPath.section][indexPath.row]
            //print("added a label cell")
            return cell
        case .timeCell(let cellText, let date, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: TimeCell.id, for: indexPath) as! TimeCell
            cell.label.text = cellText
            cell.timeLabel.text = date.format(with: "h:mm a")
            cell.date = date
            return cell
        case .timePickerCell(let dateString, let delegate):
            let cell = tableView.dequeueReusableCell(withIdentifier: TimePickerCell.id, for: indexPath) as! TimePickerCell
            cell.delegate = delegate
            cell.indexPath = indexPath
            let dateString = dateString
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            if let date = dateFormatter.date(from: dateString) {
                cell.picker.setDate(date, animated: true)
            } else {
                print("$ ERROR: date is nil.")
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
            //print("added a label cell")
            return cell
        case .colorPickerCell(let delegate):
            let cell = tableView.dequeueReusableCell(withIdentifier: ColorPickerCell.id, for: indexPath) as! ColorPickerCell
            cell.delegate = delegate
            return cell
        case .pickerCell(let cellText, let delegate, let dataSource):
            let cell = tableView.dequeueReusableCell(withIdentifier: PickerCell.id, for: indexPath) as! PickerCell
            cell.picker.delegate = delegate
            cell.picker.dataSource = dataSource
//            if resetAll{
//                cell.picker.selectRow(1, inComponent: 0, animated: true)
//            }
            cell.indexPath = indexPath
            return cell
        case .logoCell(let imageString, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: LogoCell.id, for: indexPath) as! LogoCell
            cell.setImage(systemImageName: imageString)
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = cells[indexPath.section][indexPath.row]
        switch cell {
        case .timeCell(_, _, let onClick):
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
        
//
//        let selectedRowText = cellText[indexPath.section][indexPath.row]
//        if cellType[indexPath.section][indexPath.row] == .timeCell{
//            let timeCell = tableView.cellForRow(at: indexPath) as! TimeCell
//            let pickerIndex = cellType[indexPath.section].firstIndex(of: .timePickerCell)
//
//            tableView.beginUpdates()
//
//            if let index = pickerIndex{
//                cellText[indexPath.section].remove(at: index)
//                cellType[indexPath.section].remove(at: index)
//                tableView.deleteRows(at: [IndexPath(row: index, section: indexPath.section)], with: .right)
//                if index == indexPath.row + 1{
//                    tableView.endUpdates()
//                    return
//                }
//            }
//
//            let newIndex = cellText[indexPath.section].firstIndex(of: selectedRowText)! + 1
//            tableView.insertRows(at: [IndexPath(row: newIndex, section: indexPath.section)], with: .left)
//
//            cellType[indexPath.section].insert(.timePickerCell, at: newIndex)
//            cellText[indexPath.section].insert("\(timeCell.date!.format(with: "h:mm a"))", at: newIndex)
//            tableView.endUpdates()
//        }else if cellType[indexPath.section][indexPath.row] == .logoCell {
//            performSegue(withIdentifier: "toLogoSelection", sender: self)
//        }else if cellText[indexPath.section][indexPath.row] == "Remind Me"{ //user selected "Remind Me"
//            performSegue(withIdentifier: "toAlertSelection", sender: self)
//        }
        
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
}

// MARK: - FormCell Searching
extension MasterFormClass {
//    func findFirstOccurrenceOfCell(cell: FormCell) -> IndexPath {
//        let cellString = "\(cell)"
//        for i in 0...cells.count {
//            for j in 0...cells[i].count {
//                if case cells[i][j] = cell {
//                    return IndexPath(row: j, section: i)
//                }
////                switch cells[i] {
////                default:
////                    if "\(cells[i][j])" == cellString {
////                        return IndexPath(row: j, section: i)
////                    }
////                }
//            }
//        }
//        // TODO: Fix this: return nil
//        return IndexPath(row: 0, section: 0)
//    }
//
//    func findFirstOccurrenceOfCell(cell: FormCell, section: Int) -> IndexPath {
        
//        let row = cells[2].firstIndex(where: { cell in
//            if case .colorPickerCell = cell {
//                return true
//            }
//            return false
//        }
//        let cellString = "\(cell)"
        
//        for j in 0...cells[section].count {
//            let cell = cells[section][j]
//            if case .colorPickerCell = cell {
//
//            }
//            switch cells[section][j] {
//            default:
//                if "\(cells[section][j])" == cellString {
//                    return IndexPath(row: j, section: section)
//                }
//            }
//        }
//        // TODO: Fix this: return nil
//        return IndexPath(row: 0, section: 0)
//    }
    
    func findFirstLogoCellIndex(section: Int) -> IndexPath? {
        for i in 0..<cells[section].count {
            switch cells[section][i] {
            case .logoCell(_, _):
                return IndexPath(row: i, section: section)
            default:
                continue
            }
        }
        return nil
    }
    
    func findFirstPickerCellIndex(section: Int) -> Int? {
        for i in 0..<cells[section].count {
            switch cells[section][i] {
            case .timePickerCell(_, _):
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
        default:
            return
        }
    }
}
