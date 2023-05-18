//
//  DayScheduleViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//
//
import UIKit
import CalendarKit

import VikUtilityKit

//TODO: Docstrings
class DayScheduleViewController: DayViewController {
    
    let debug = true

    //TODO: Docstring
    let databaseService: DatabaseServiceProtocol! = DatabaseService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayView.autoScrollToFirstEvent = true
        
        var style = CalendarStyle()
        style.header.backgroundColor = StudiumColor.secondaryBackground.uiColor
        
        style.header.daySelector.activeTextColor = StudiumColor.primaryLabel.uiColor
        style.header.daySelector.inactiveTextColor = StudiumColor.primaryLabel.uiColor
        style.header.daySelector.selectedBackgroundColor = StudiumColor.primaryAccent.uiColor
        
        style.header.daySelector.todayActiveTextColor = StudiumColor.primaryLabel.uiColor
        style.header.daySelector.todayInactiveTextColor = StudiumColor.primaryAccent.uiColor
        
        style.header.daySelector.todayActiveBackgroundColor = StudiumColor.primaryAccent.uiColor

        style.header.swipeLabel.textColor = StudiumColor.primaryLabel.uiColor
        
        style.header.daySymbols.weekDayColor = StudiumColor.primaryLabel.uiColor
        style.header.daySymbols.weekendColor = StudiumColor.secondaryLabel.uiColor

        
        
        style.timeline.backgroundColor = StudiumColor.secondaryBackground.uiColor
        style.timeline.separatorColor = StudiumColor.secondaryLabel.uiColor
        style.timeline.timeColor = StudiumColor.secondaryLabel.uiColor
        
        
        dayView.updateStyle(style)
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
        self.navigationController?.navigationBar.tintColor = StudiumColor.primaryAccent.uiColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        printDebug("View Will Appear")
        super.viewWillAppear(animated)
        reloadData()
        self.generatedEvents = []
        
        if let state = dayView.state {
            self.updateTitle(selectedDate: state.selectedDate)
        } else {
            self.updateTitle(selectedDate: Date())
        }
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    //TODO: Docstrings
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    
    //TODO: Docstrings
    @IBAction func monthButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toCalendar", sender: self)
    }
    
    //TODO: Docstring
    func createEventsForStudiumEvents(on date: Date) -> [Event] {
        printDebug("createEventsForStudiumEvents called")
        let studiumEvents = self.databaseService.getAllStudiumObjects()
        var events = [Event]()
        for studiumEvent in studiumEvents {
            printDebug("Creating StudiumEvent: \(studiumEvent.name) for Date: \(date)")
            
            let newEvent = Event()
            newEvent.startDate = studiumEvent.startDate
            newEvent.endDate = studiumEvent.endDate
            newEvent.color = studiumEvent.scheduleDisplayColor
            let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
            let attributedString = NSMutableAttributedString(string: studiumEvent.scheduleDisplayString, attributes: attributes)
            newEvent.attributedText = attributedString
            
            // Is the event recurring?
            if let recurringEvent = studiumEvent as? RecurringStudiumEvent {
                
                if let recurringEvent = recurringEvent as? (any Autoscheduleable),
                   recurringEvent.autoscheduling {
//                    let autoscheduleChunk = AutoscheduleService.shared.findAutoscheduleTimeChunk(dateToScheduleOn: date, startBound: <#T##Date#>, endBound: <#T##Date#>, totalMinutes: <#T##Int#>)
                } else {
                    
                    // Does the event occur on the requested date?
                    if let timechunk = recurringEvent.timeChunkForDate(date: date) {
                        newEvent.startDate = Calendar.current.date(bySettingHour: studiumEvent.startDate.hour, minute: studiumEvent.startDate.minute, second: 0, of: date)!
                        newEvent.endDate = Calendar.current.date(bySettingHour: studiumEvent.endDate.hour, minute: studiumEvent.endDate.minute, second: 0, of: date)!
                    }
                }
            } else {
//                continue
            }
            
            if let studiumEvent = studiumEvent as? CompletableStudiumEvent {
                if studiumEvent.complete {
                    attributedString.addAttributes([
                        NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                        NSAttributedString.Key.strikethroughColor: UIColor.label,
                    ], range: NSMakeRange(0, attributedString.length))
                }
            }

            printDebug("Appending event with text \(newEvent.attributedText?.string) and dates \(newEvent.startDate) - \(newEvent.endDate)")
            events.append(newEvent)
        }
        
        return events
    }
    
    //TODO: Docstrings
    func createWakeTimeEvent(for date: Date) -> Event? {
        printDebug("Creating Wake Time Events")
        
        // There is no wake up time for the specified date
        guard let wakeUpTime = self.databaseService.getUserSettings().getWakeUpTime(for: date),
              wakeUpTime.occursOn(date: date) else {
            printDebug("Wake up time for \(date.weekdayValue) was nil or mismatched the requested date. Wake Up Time: \(String(describing: self.databaseService.getUserSettings().getWakeUpTime(for: date))), Requested: \(date)")
            return nil
        }

        let anHourAgo = wakeUpTime - (60 * 60)
        let newEvent = Event()
        newEvent.startDate = anHourAgo
        newEvent.endDate = wakeUpTime
        newEvent.color = UIColor.yellow
        
        
        let string = "\(wakeUpTime.format(with: DateFormat.standardTime.rawValue)): Wake Up"
        
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        newEvent.attributedText = attributedString
        
        printDebug("Created Wake Up Event for \(date). Wake Up Time is \(wakeUpTime)")

        return newEvent
    }
    
    // MARK: EventDataSource
    
    //TODO: Docstrings
    var generatedEvents = [EventDescriptor]()
    
    //TODO: Docstrings
    var alreadyGeneratedSet = Set<Date>()
    
    //TODO: Docstrings
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
//        if !alreadyGeneratedSet.contains(date) {
//            alreadyGeneratedSet.insert(date)
//
//            generatedEvents.append(contentsOf: generateEventsForDate(date))
//        }
//        return generatedEvents
        printDebug("eventsForDate called")
        return self.generateEventsForDate(date)
    }
    
    //TODO: Docstrings
    func generateEventsForDate(_ date: Date) -> [EventDescriptor] {
        printDebug("generateEventsForDate called")
        var events = [Event]()
        events.append(contentsOf: self.createEventsForStudiumEvents(on: date))
        
        if let event = self.createWakeTimeEvent(for: date) {
            events.append(event)
        }
//        events.append(contentsOf: addWakeTimes(for: date))
//        events.append(contentsOf: addCourses(for: date))
//        events.append(contentsOf: addOtherEvents(for: date))
//        events.append(contentsOf: addHabits(for: date, with: events))
//        events.append(contentsOf: addAssignments(for: date))
    
        return events
    }
    // MARK: DayViewDelegate
    
    //TODO: Docstrings
    private var createdEvent: EventDescriptor?
    
    //TODO: Docstrings
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        
        print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
    }
    
    //TODO: Docstrings
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        endEventEditing()
        print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
        beginEditing(event: descriptor, animated: true)
        print(Date())
    }
    
    //TODO: Docstrings
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        endEventEditing()
        print("Did Tap at date: \(date)")
    }
    
    override func dayViewDidBeginDragging(dayView: DayView) {
        print("DayView did begin dragging")
    }
    
    override func dayView(dayView: DayView, willMoveTo date: Date) {
//        print("DayView = \(dayView) will move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
        self.updateTitle(selectedDate: date)
    }
    
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        print("Did long press timeline at date \(date)")
        // Cancel editing current event and start creating a new one
        endEventEditing()
    }
    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        print("did finish editing lol \(event)")
        print("new startDate: \(event.startDate) new endDate: \(event.endDate)")
        
        if let _ = event.editedEvent {
            event.commitEditing()
        }
        
        reloadData()
    }
    
    func updateTitle(selectedDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        let monthString = dateFormatter.string(from: selectedDate)
        self.navigationItem.title = "\(monthString)"
    }
}

extension DayScheduleViewController: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (DayScheduleViewController): \(message)")
        }
    }
}
