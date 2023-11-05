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

//TODO: Docstrings
class DayScheduleViewController: DayViewController, Storyboarded {
    
    weak var coordinator: CalendarCoordinator?
    
    //TODO: Docstring
    let databaseService: DatabaseServiceProtocol! = DatabaseService.shared
    
    override func loadView() {
        super.loadView()
        self.dayView.autoScrollToFirstEvent = true
        
        var style = CalendarStyle()
        
        let selectedBackgroundColor = StudiumColor.primaryAccent.uiColor
        let selectedTextColor = StudiumColor.primaryLabelColor(forBackgroundColor: selectedBackgroundColor)
        let unselectedTextColor = StudiumColor.primaryLabel.uiColor
        
        style.header.backgroundColor = StudiumColor.secondaryBackground.uiColor
        
        style.header.daySelector.activeTextColor = selectedTextColor
        style.header.daySelector.inactiveTextColor = unselectedTextColor
        style.header.daySelector.selectedBackgroundColor = selectedBackgroundColor
        
        // Color of circle behind today's number
        style.header.daySelector.todayActiveBackgroundColor = selectedBackgroundColor
        
        // Today's number color
        style.header.daySelector.todayActiveTextColor = selectedTextColor
        
        style.header.daySelector.todayInactiveTextColor = StudiumColor.primaryAccent.uiColor
        
        style.header.swipeLabel.textColor = StudiumColor.primaryLabel.uiColor
        style.header.daySymbols.weekDayColor = StudiumColor.primaryLabel.uiColor
        style.header.daySymbols.weekendColor = StudiumColor.secondaryLabel.uiColor
        
        style.timeline.backgroundColor = StudiumColor.secondaryBackground.uiColor
        style.timeline.separatorColor = StudiumColor.secondaryLabel.uiColor
        style.timeline.timeColor = StudiumColor.secondaryLabel.uiColor
        
        
        self.dayView.updateStyle(style)
        
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumFormNavigationConstants.navBarForegroundColor.uiColor]
//        self.navigationController?.navigationBar.tintColor = StudiumFormNavigationConstants.navBarForegroundColor.uiColor

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = StudiumColor.background.uiColor
        self.navigationController?.navigationBar.prefersLargeTitles = false
//        self.navigationController?.navigationBar.backgroundColor = StudiumColor.background.uiColor
        
        self.navigationController?.navigationBar.tintColor = StudiumColor.primaryAccent.uiColor
        self.navigationController?.navigationBar.backgroundColor = StudiumColor.background.uiColor
        
        self.view.backgroundColor = StudiumColor.background.uiColor
        
        self.reloadData()
        self.generatedEvents = []
        
        if let state = dayView.state {
            self.updateTitle(selectedDate: state.selectedDate)
        } else {
            self.updateTitle(selectedDate: Date())
        }
    }
    
    //TODO: Docstrings
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        self.coordinator?.showSettingsFlow()
    }
    
    //TODO: Docstrings
    @IBAction func monthButtonPressed(_ sender: Any) {
        self.coordinator?.showMonthScheduleViewController()
    }
    
    //TODO: Docstring
    func createEventsForStudiumEvents(on date: Date) -> [Event] {
        let studiumEvents = self.databaseService.getAllStudiumObjects()
        var events = [Event]()
        for studiumEvent in studiumEvents {
            
            let newEvent = Event()
            guard let timeChunk = studiumEvent.timeChunkForDate(date: date) else {
                // event does not occur on date
                continue
            }
            
            if timeChunk.endDate < timeChunk.startDate {
                Log.e("endDate of StudiumEvent occurs before startDate")
                continue
            }
            
            Log.d("Creating new event with title \(studiumEvent.name). Object: \(studiumEvent)")
            newEvent.dateInterval.start = timeChunk.startDate
            newEvent.dateInterval.end = timeChunk.endDate
            newEvent.color = studiumEvent.scheduleDisplayColor
            let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
            let attributedString = NSMutableAttributedString(string: studiumEvent.scheduleDisplayString, attributes: attributes)
            newEvent.attributedText = attributedString
            
            // Is the event recurring?
            if let recurringEvent = studiumEvent as? RecurringStudiumEvent {
                if let studiumEvent = studiumEvent as? CompletableStudiumEvent {
                    if studiumEvent.complete {
                        attributedString.addAttributes([
                            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                            NSAttributedString.Key.strikethroughColor: UIColor.label,
                        ], range: NSMakeRange(0, attributedString.length))
                    }
                }
                
                if newEvent.dateInterval.start <= newEvent.dateInterval.end {
                    events.append(newEvent)
                } else {
                    // FIXME: Investigate
                }
            }
        }
        return events
    }
    
    //TODO: Docstrings
    func createWakeTimeEvent(for date: Date) -> Event? {
        
        // There is no wake up time for the specified date
        guard let wakeUpTime = self.databaseService.getUserSettings().getWakeUpTime(for: date),
              wakeUpTime.occursOn(date: date) else {
            Log.d("Wake up time for \(date.weekdayValue) was nil or mismatched the requested date. Wake Up Time: \(String(describing: self.databaseService.getUserSettings().getWakeUpTime(for: date))), Requested: \(date)")
            return nil
        }
        
        let anHourAgo = wakeUpTime - (60 * 60)
        let newEvent = Event()
        newEvent.dateInterval.start = anHourAgo
        newEvent.dateInterval.end = wakeUpTime
        newEvent.color = UIColor.yellow
        
        let string = "\(wakeUpTime.format(with: DateFormat.standardTime)): Wake Up"
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        newEvent.attributedText = attributedString
        
        return newEvent
    }
    
    // MARK: EventDataSource
    
    //TODO: Docstrings
    var generatedEvents = [EventDescriptor]()
    
    //TODO: Docstrings
    var alreadyGeneratedSet = Set<Date>()
    
    //TODO: Docstrings
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        return self.generateEventsForDate(date)
    }
    
    //TODO: Docstrings
    func generateEventsForDate(_ date: Date) -> [EventDescriptor] {
        var events = [Event]()
        events.append(contentsOf: self.createEventsForStudiumEvents(on: date))
        if let event = self.createWakeTimeEvent(for: date) {
            events.append(event)
        }
        
        return events
    }
    
    // MARK: DayViewDelegate
    
    // TODO: Docstrings
    private var createdEvent: EventDescriptor?
    
    // TODO: Investigate and lint
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        
        Log.d("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
    }
    
    // TODO: Investigate and lint
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        
        self.endEventEditing()
        Log.d("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
        self.beginEditing(event: descriptor, animated: true)
    }
    
    //TODO: Docstrings
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        self.endEventEditing()
        Log.d("Did Tap at date: \(date)")
    }
    
    override func dayViewDidBeginDragging(dayView: DayView) {
        Log.d("DayView did begin dragging")
    }
    
    // TODO: Investigate and lint
    override func dayView(dayView: DayView, willMoveTo date: Date) {
        
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
        self.updateTitle(selectedDate: date)
    }
    
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        Log.d("Did long press timeline at date \(date)")
        // Cancel editing current event and start creating a new one
        self.endEventEditing()
    }
    
    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        Log.d("did finish editing lol \(event)")
        Log.d("new startDate: \(event.dateInterval.start) new endDate: \(event.dateInterval.end)")
        
        if let _ = event.editedEvent {
            event.commitEditing()
        }
        
        self.reloadData()
    }
    
    func updateTitle(selectedDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        let monthString = dateFormatter.string(from: selectedDate)
        self.navigationItem.title = "\(monthString)"
    }
}
