//
//  MasterForm.swift
//  Studium
//
//  Created by Vikram Singh on 7/1/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import TableViewFormKit
import VikUtilityKit

/// characteristics of all forms.
let kLargeCellHeight: CGFloat = 150
let kMediumCellHeight: CGFloat = 60
let kNormalCellHeight: CGFloat = 50

class MasterForm: TableViewForm, Debuggable {
    
    var debug: Bool {
        true
    }
    
    let databaseService: DatabaseServiceProtocol! = DatabaseService.shared
    let autoscheduleService: AutoscheduleServiceProtocol = AutoscheduleService.shared
    
    // TODO: Docstrings
    lazy var alertTimes: [AlertOption] = {
        return self.databaseService.getDefaultAlertOptions()
    }()
    
    /// The name for the StudiumEvent being added/edited
    var name: String = ""
    
    // TODO: Docstrings
    var additionalDetails: String = ""
    
    /// The errors that can occur with adding/editing the StudiumEvent
    var errors: [StudiumFormError] = []
    
    /// The days selected for this StudiumEvent
    var daysSelected = Set<Weekday>()
    
    // TODO: Docstrings
    var color: UIColor = .white

    // TODO: Docstrings
    var icon: StudiumIcon = StudiumIcon.book
    
    // TODO: Docstrings
    var location: String = ""
    
    // TODO: Docstrings
    var startDate: Date = Date()
    
    // TODO: Docstrings
    var endDate: Date = Date() + (60*60)
    
    // TODO: Docstrings
    var totalLengthMinutes = 0
    
    // TODO: Docstrings
    var lengthPickerIndices: [Int] {
        let hours = self.totalLengthMinutes / 60
        let minutes =  self.totalLengthMinutes % 60
        return [hours, minutes]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the color of the navigation bar title text
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
        
        // Set the color of the navigation bar button text
        self.navigationController?.navigationBar.tintColor = StudiumColor.primaryLabel.uiColor
        self.navigationController?.navigationBar.backgroundColor = StudiumColor.primaryAccent.uiColor
        self.navigationController?.navigationBar.barTintColor = StudiumColor.secondaryBackground.uiColor
    }
    
    // TODO: Docstrings
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // TODO: Docstrings
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? LogoSelectorViewController {
            destinationVC.delegate = self
            guard let colorCellRow = self.cells[2].firstIndex(where: { cell in
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
        }
        
//        else if let destinationVC = segue.destination as? AlertTimeSelectionForm {
//            destinationVC.delegate = self
//            destinationVC.setSelectedAlertOptions(alertOptions: self.alertTimes)
//        }
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
    func findFirstTimeCellWithID(id: FormCellID.TimeCellID) -> IndexPath? {
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

// MARK: - TimeCell Setup

extension MasterForm {
    
    // TODO: Docstrings
    func timeCellClicked(indexPath: IndexPath) {
        guard let timeCell = tableView.cellForRow(at: indexPath) as? TimeCell else {
            Log.s(MasterForm.StudiumError.cellTypeMismatch, additionalDetails: "timeCellClicked was called in \(String(describing: self)) at indexPath \(indexPath) however the cell at this indexPath could not be optionally unwrapped as a TimeCell. The cell: \(String(describing: tableView.cellForRow(at: indexPath)))")
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
        var timePickerID = FormCellID.TimePickerCellID.startDateTimePicker
        switch timeCell.formCellID {
        case .endTimeCell:
            timePickerID = FormCellID.TimePickerCellID.endDateTimePicker
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
            timePickerID = FormCellID.TimePickerCellID.startDateTimePicker
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
            timePickerID = FormCellID.TimePickerCellID.lengthTimePicker
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
    
}

// MARK: - TimePicker Setup

extension MasterForm: UITimePickerDelegate {
    // TODO: Docstrings
    func timePickerValueChanged(sender: UIDatePicker, indexPath: IndexPath, pickerID: FormCellID.TimePickerCellID) {
        //we are getting the timePicker's corresponding timeCell by accessing its indexPath and getting the element in the tableView right before it. This is always the timeCell it needs to update. The indexPath of the timePicker is stored in the cell's class upon creation, so that it can be passed to this function when needed.
        guard let correspondingTimeCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as? TimeCell else {
            print("$ERR (MasterFormClass): couldn't find TimeCell when changing picker value.\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
            return
        }
        
        
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
}

// MARK: - Alert Time Selection
extension MasterForm: AlertTimeHandler {
    func alertTimesWereUpdated(selectedAlertOptions: [AlertOption]) {
        self.alertTimes = selectedAlertOptions
        self.printDebug("Selected alert times updated to \(self.alertTimes)")
    }
}

// MARK: - Logo Selection
extension MasterForm: LogoSelectionHandler {
    
    /// Handles what happens when the user selects a logo
    /// - Parameter logo: The logo that the user selected
    func logoWasUpdated(icon: StudiumIcon) {
        self.icon = icon
        guard let logoCellIndexPath = self.findFirstLogoCellIndex(),
              let logoCell = tableView.cellForRow(at: logoCellIndexPath) as? LogoSelectionCell
        else {
            print("$ERR (MasterForm): Can't locate logo cell or cast it as a LogoCell.")
            return
        }
        
        logoCell.setImage(image: icon.uiImage)
    }
}

// MARK: - PickerView Setup

// TODO: Docstrings
extension MasterForm: UIPickerViewDelegate {
    
    // TODO: Docstrings
    //determines the text in each row, given the row and component
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case FormCellID.PickerCellID.coursePickerCell.rawValue:
            let courses = self.databaseService.getStudiumObjects(expecting: Course.self)
            return courses[row].name
        case FormCellID.PickerCellID.lengthPickerCell.rawValue:
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
        case FormCellID.PickerCellID.lengthPickerCell.rawValue:
            return 2
        case FormCellID.PickerCellID.coursePickerCell.rawValue:
            return 1
        default:
            print("$ERR: Unknown pickerView ID\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
            return 0
        }
    }
    
    // TODO: Docstrings
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case FormCellID.PickerCellID.lengthPickerCell.rawValue:
            if component == 0 {
                return 24
            } else {
                return 60
            }
        case FormCellID.PickerCellID.coursePickerCell.rawValue:
            return self.databaseService.getStudiumObjects(expecting: Course.self).count
        default:
            print("$ERR: Unknown pickerView ID\nFile:\(#file)\nFunction:\(#function)\nLine:\(#line)")
            return 0
        }
    }
}

// MARK: - TableView Setup

extension MasterForm {
    
    // TODO: Docstrings
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: K.emptyHeaderHeight))
        
        return headerView
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
        case .labelCell(_, _, _, _, _, let onClick):
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
        case .pickerCell, .timePickerCell, .colorPickerCell, .errorCell:
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
    
    /// Scrolls the screen to the bottom of the Form
    func scrollToBottomOfTableView() {
        let lastSectionIndex = self.tableView.numberOfSections - 1
        let lastIndexPath = IndexPath(row: tableView.numberOfRows(inSection: lastSectionIndex) - 1, section: lastSectionIndex)
        
        self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
    }
}

extension MasterForm {
    private enum StudiumError: Error {
        case cellTypeMismatch
    }
}

// MARK: - TableViewForm Conformance
extension MasterForm {
    func fillForm(event: StudiumEvent) {
        fatalError("$ERR (MasterForm): fillForm method should be overriden by subclass.")
    }
}
