//
//  MasterForm.swift
//  Studium
//
//  Created by Vikram Singh on 7/1/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

//TODO: Move to separate file


//public let kCellBackgroundColor = UIColor.secondarySystemBackground

//typealias MasterForm = MasterFormClass

/// characteristics of all forms.
let kLargeCellHeight: CGFloat = 150
let kMediumCellHeight: CGFloat = 60
let kNormalCellHeight: CGFloat = 50

class MasterForm: UITableViewController, UNUserNotificationCenterDelegate, LogoStorer, UITimePickerDelegate {
    
    let databaseService: DatabaseServiceProtocol! = nil
    
    // TODO: Docstrings
    var debug: Bool {
        false
    }
    
    // TODO: Docstrings
    lazy var alertTimes: [AlertOption] = {
        return self.databaseService.getDefaultAlertOptions()
    }()
    
    /// The name for the StudiumEvent being added/edited
    var name: String = ""
    
    // TODO: Docstrings
    var additionalDetails: String = ""
    
    /// The errors that can occur with adding/editing the StudiumEvent
    var errors: [FormError] = []
    
    /// The days selected for this StudiumEvent
    var daysSelected = Set<Weekday>()
    
    // TODO: Docstrings
    var color: UIColor = .black

    // TODO: Docstrings
    var logo: SystemIcon = .book
    
    // TODO: Docstrings
    var location: String = ""
    
    // TODO: Docstrings
    var startDate: Date = Date()
    
    // TODO: Docstrings
    var endDate: Date = Date() + (60*60)
    
//    var totalLengthHours = 1
    // TODO: Docstrings
    var totalLengthMinutes = 0
    
    // TODO: Docstrings
    var cells: [[FormCell]] = [[]]
    
//    var lengthMinutes: Int = 0
    
    // TODO: Docstrings
    var lengthPickerIndices: [Int] {
        let hours = self.totalLengthMinutes / 60
        //                    timePickerCell.picker.selectRow(hours, inComponent: 0, animated: true)
        
        let minutes =  self.totalLengthMinutes % 60
        //                    timePickerCell.picker.selectRow(minutes, inComponent: 1, animated: true)
        return [hours, minutes]
        
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = StudiumColor.background.uiColor
        
        // Set the color of the navigation bar title text
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
        
        // Set the color of the navigation bar button text
        self.navigationController?.navigationBar.tintColor = StudiumColor.primaryLabel.uiColor
        self.navigationController?.navigationBar.backgroundColor = StudiumColor.primaryAccent.uiColor
        self.navigationController?.navigationBar.barTintColor = StudiumColor.secondaryBackground.uiColor
        
        // registering the necessary cells for the form.
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
        
        //TODO: move to separate function
        let defaults = UserDefaults.standard
        
        if let times = defaults.value(forKey: K.defaultNotificationTimesKey) as? [Int] {
            self.alertTimes = times.compactMap { AlertOption(rawValue: $0) }
        }
    }
    
    // TODO: Docstrings
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // TODO: Docstrings
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: K.emptyHeaderHeight))
        
        return headerView
    }
    
    // TODO: Docstrings
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cells[indexPath.section][indexPath.row]
        switch cell {
        case .textFieldCell(let placeholderText, let text, let id, let textFieldDelegate, let delegate):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.id, for: indexPath) as! TextFieldCell
            cell.textField.placeholder = placeholderText
            cell.textField.delegate = textFieldDelegate
            cell.delegate = delegate
            cell.textFieldID = id
            cell.textField.text = text
            return cell
        case .switchCell(let cellText, let isOn, let switchDelegate, let infoDelegate):
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.id, for: indexPath) as! SwitchCell
            cell.switchDelegate = switchDelegate
            cell.infoDelegate = infoDelegate
            cell.label.text = cellText
            cell.tableSwitch.isOn = isOn
            return cell
        case .labelCell(let cellText, let textColor, let backgroundColor, let cellAccessoryType, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: LabelCell.id, for: indexPath) as! LabelCell
            cell.label.text = cellText
            cell.label.textColor = textColor
            cell.backgroundColor = backgroundColor
            cell.accessoryType = cellAccessoryType
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
            let cell = tableView.dequeueReusableCell(withIdentifier: LogoCell.id, for: indexPath) as! LogoCell
            cell.setImage(systemIcon: logo)
            return cell
        }
    }
    
    // TODO: Docstrings
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = cells[indexPath.section][indexPath.row]
        switch cell {
        case .timeCell(_, _, _, _, _, let onClick):
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
    
    // TODO: Docstrings
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
    
    // TODO: Docstrings
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    // TODO: Docstrings
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    // TODO: Docstrings
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        
        return K.emptyHeaderHeight
    }
    
    // TODO: Docstrings
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
            destinationVC.color = colorCell.colorPreview.backgroundColor ?? StudiumColor.primaryLabel.uiColor
        } else if let destinationVC = segue.destination as? AlertTableViewController {
            destinationVC.delegate = self
            destinationVC.setSelectedAlertOptions(alertOptions: self.alertTimes)
        }
    }
    
    /// When we pick a logo, this function is called to update the preview on the logo cell.
    func refreshLogoCell() {
        guard let logoCellIndexPath = self.findFirstLogoCellIndex() else {
            print("$ERR: Can't locate logo cell")
            return
        }
        guard let logoCell = tableView.cellForRow(at: logoCellIndexPath) as? LogoCell else {
            print("$ERR: LogoCell not found")
            return
        }
        
        logoCell.setImage(systemIcon: self.logo)
    }
}

// MARK: - FormCell Searching

// TODO: Docstrings
extension MasterForm {
    
    // TODO: Docstrings
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
    
    // TODO: Docstrings
    func findFirstTimePickerCellIndex(section: Int) -> Int? {
        for i in 0 ..< cells[section].count {
            switch cells[section][i] {
            case .timePickerCell:
                return i
            default:
                continue
            }
        }
        return nil
    }
    
    // TODO: Docstrings
    func findFirstTimeCellWithID(id: FormCellID.TimeCell) -> IndexPath? {
        for i in 0 ..< cells.count {
            for j in 0 ..< cells[i].count {
                switch cells[i][j] {
                case .timeCell(_, _, _, _, let cellID, _):
                    if id == cellID {
                        return IndexPath(row: j, section: i)
                    }
                default:
                    continue
                }
            }
        }
        
        return nil
    }
}

// MARK: - FormCell Mutations

// TODO: Docstrings
extension MasterForm {
    
    // TODO: Docstrings
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
    
    // TODO: Docstrings
    func timeCellClicked(indexPath: IndexPath) {
        guard let timeCell = tableView.cellForRow(at: indexPath) as? TimeCell else {
            print("$ERR: Time Cell Mismatch.\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
            return
        }
        
        var timeCellIndex = indexPath.row
        tableView.beginUpdates()
        
        // Find the first time picker (if there is one) and remove it
        if let indexOfFirstTimePicker = self.findFirstTimePickerCellIndex(section: indexPath.section) {
            cells[indexPath.section].remove(at: indexOfFirstTimePicker)
            tableView.deleteRows(at: [IndexPath(row: indexOfFirstTimePicker, section: indexPath.section)], with: .right)
            /// Clicked on time cell while corresopnding timepicker is already expanded.
            if indexOfFirstTimePicker == indexPath.row + 1 {
                tableView.endUpdates()
                return
                // Clicked on time cell while above timepicker is expanded
            } else if indexOfFirstTimePicker == indexPath.row - 1 {
                // Remove one from the index since we removed a cell above
                timeCellIndex -= 1
            }
        }
        var timePickerID = FormCellID.TimePickerCell.startDateTimePicker
        switch timeCell.formCellID {
        case .endTimeCell:
            timePickerID = FormCellID.TimePickerCell.endDateTimePicker
            cells[indexPath.section].insert(
                .timePickerCell(
                    date: timeCell.getDate(),
                    dateFormat: timeCell.getDateFormat(),
                    timePickerMode: timeCell.getTimePickerMode(),
                    id: timePickerID,
                    delegate: self
                ),
                at: timeCellIndex + 1
            )
        case .startTimeCell:
            timePickerID = FormCellID.TimePickerCell.startDateTimePicker
            cells[indexPath.section].insert(
                //                .timePickerCell(dateString: "\(timeCell.date!.format(with: timeCell.dateFormat))",
                .timePickerCell(
                    date: timeCell.getDate(),
                    dateFormat: timeCell.getDateFormat(),
                    timePickerMode: timeCell.getTimePickerMode(),
                    id: timePickerID,
                    delegate: self
                ),
                at: timeCellIndex + 1)
        case .lengthTimeCell:
            timePickerID = FormCellID.TimePickerCell.lengthTimePicker
            cells[indexPath.section].insert(
                .pickerCell(cellText: "Length of Habit", indices: self.lengthPickerIndices, tag: .lengthPickerCell, delegate: self, dataSource: self),
                at: timeCellIndex + 1)
        default:
            print("$ERR: unexpected cell ID.\nFile: \(#file)\nFunction:\(#function)\nLine:\(#line)")
            return
        }
        
        tableView.insertRows(at: [IndexPath(row: timeCellIndex + 1, section: indexPath.section)], with: .left)
        tableView.endUpdates()
    }
    
    // TODO: Docstrings
    func pickerValueChanged(sender: UIDatePicker, indexPath: IndexPath, pickerID: FormCellID.TimePickerCell) {
        //we are getting the timePicker's corresponding timeCell by accessing its indexPath and getting the element in the tableView right before it. This is always the timeCell it needs to update. The indexPath of the timePicker is stored in the cell's class upon creation, so that it can be passed to this function when needed.
        guard let correspondingTimeCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as? TimeCell else {
            print("$ERR (MasterFormClass): couldn't find TimeCell when changing picker value.\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
            return
        }
        
//        printDebug("SENDER DATE: \(sender.date)")
        
        var components = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: sender.date)
        components.year = Date().year
        var pickerDate = Calendar.current.date(from: components)
        
        if pickerDate != nil {
            if pickerDate! < Date() {
                components.year = Date().year + 1
                pickerDate = Calendar.current.date(from: components)
                
            }
            
            //            correspondingTimeCell.timeLabel.text = pickerDate!.format(with: correspondingTimeCell.getDateFormat())
            //            correspondingTimeCell.setDateFormat()
        } else {
            print("$ERR (MasterFormClass): date is nil.\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
        }
        
        switch pickerID {
        case .startDateTimePicker:
            self.startDate = sender.date
            print("$LOG: updated startDate \(self.startDate)")
        case .endDateTimePicker:
            self.endDate = sender.date
            print("$LOG: updated endDate \(self.endDate)")
        default:
            print("$ERR (MasterFormClass): unexpected TimePicker ID.\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
            return
        }
        
        correspondingTimeCell.setDate(sender.date)
    }
    
    // TODO: Docstrings
    func navigateToLogoSelection() {
        self.performSegue(withIdentifier: "toLogoSelection", sender: self)
    }
    
    // TODO: Docstrings
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

// TODO: Docstrings
extension MasterForm: UIPickerViewDelegate {
    //    extension AddHabitViewController: UIPickerViewDelegate{
    
    // TODO: Docstrings
    //determines the text in each row, given the row and component
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case FormCellID.PickerCell.coursePickerCell.rawValue:
            let courses = self.databaseService.getStudiumObjects(expecting: Course.self)
            return courses[row].name
        case FormCellID.PickerCell.lengthPickerCell.rawValue:
            if component == 0 {
                return "\(row) hours"
            } else {
                return "\(row) min"
            }
        default:
            print("$ERR: Unknown pickerView ID\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
            return nil
        }
    }
    
    // TODO: Docstrings
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let lengthHours = pickerView.selectedRow(inComponent: 0)
        let lengthMinutes = pickerView.selectedRow(inComponent: 1)
        self.totalLengthMinutes = (lengthHours * 60) + lengthMinutes
        print("set totalLengthMinutes to \(self.totalLengthMinutes)")
    }
}

// TODO: Docstrings
extension MasterForm: UIPickerViewDataSource {
    
    // TODO: Docstrings
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case FormCellID.PickerCell.lengthPickerCell.rawValue:
            return 2
        case FormCellID.PickerCell.coursePickerCell.rawValue:
            return 1
        default:
            print("$ERR: Unknown pickerView ID\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
            return 0
        }
    }
    
    // TODO: Docstrings
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case FormCellID.PickerCell.lengthPickerCell.rawValue:
            if component == 0 {
                return 24
            } else {
                return 60
            }
        case FormCellID.PickerCell.coursePickerCell.rawValue:
//            return StudiumState.state.getCourses().count
            return self.databaseService.getStudiumObjects(expecting: Course.self).count
            //            break
        default:
            print("$ERR: Unknown pickerView ID\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
            return 0
        }
    }
    
    //    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    //           if pickerView.tag == 1{
    //               return courses?.count ?? 1
    //           }else if pickerView.tag == 0{
    //               if component == 0{
    //                   return 24
    //               }
    //               return 60
    //           }
    //           return 0
    //       }
}

extension MasterForm: AlertTimeHandler {
    func alertTimesWereUpdated(selectedAlertOptions: [AlertOption]) {
        self.alertTimes = selectedAlertOptions
        self.printDebug("Selected alert times updated to \(selectedAlertOptions)")
    }
}

extension MasterForm: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (\(String(describing: self)): \(message)")
        }
    }
}
