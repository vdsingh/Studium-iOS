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
import DateToolsSwift
//
class DayScheduleViewController: DayViewController {
    
    let debug = false
    
    let defaults = UserDefaults.standard
    
//    var generatedEvents = [Event]()
    
    override func viewDidLoad() {
        printDebug("View Did Load")
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
        super.viewWillAppear(animated)
        reloadData()
        generatedEvents = []
        alreadyGeneratedSet = Set<Date>()
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    
    @IBAction func monthButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toCalendar", sender: self)
    }
    
    func addCourses(for date: Date) -> [Event]{
        var events: [Event] = []
        var coursesOnDay: [Course] = []
        let allCourses = DatabaseService.shared.getStudiumObjects(expecting: Course.self)
        for course in allCourses{
            if course.days.contains(date.studiumWeekday){ //course occurs on this day.
                coursesOnDay.append(course)
            }
        }
        
        for course in coursesOnDay{
            let courseEvent = Event()
            courseEvent.startDate = Calendar.current.date(bySettingHour: course.startDate.hour, minute: course.startDate.minute, second: 0, of: date)!
            courseEvent.endDate = Calendar.current.date(bySettingHour: course.endDate.hour, minute: course.endDate.minute, second: 0, of: date)!
            courseEvent.color = course.color
            
            let string = "\(course.startDate.format(with: "h:mm a")) - \(course.endDate.format(with: "h:mm a")): \(course.name)"
            let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.label]
            let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
            courseEvent.attributedText = attributedString
            events.append(courseEvent)
        }
        return events
    }
    
    func addWakeTimes(for date: Date) -> [Event]{
        var events: [Event] = []
        
        if UserDefaults.standard.object(forKey: K.wakeUpKeyDict[date.weekday]!) == nil {
            print("$Log: user did not specify wake times.")
            return []
        }
        
        let timeToWake = defaults.array(forKey: K.wakeUpKeyDict[date.weekday]!)![0] as! Date
        
        let hour = calendar.component(.hour, from: timeToWake)
        let minutes = calendar.component(.minute, from: timeToWake)
        let usableDate = Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: date)!

        let anHourAgo = usableDate - (60 * 60)
        let newEvent = Event()
        newEvent.startDate = anHourAgo
        newEvent.endDate = usableDate
        newEvent.color = UIColor.yellow
        
        
        let string = "\(usableDate.format(with: DateFormat.standardTime.rawValue)): Wake Up"
        
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.label]
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        newEvent.attributedText = attributedString
        
        events.append(newEvent)
        return events
    }
    
    func addHabits(for date: Date, with outsideEvents: [Event]) -> [Event]{//algorithm to find right time based on pre-existing events.
        let allHabits = DatabaseService.shared.getStudiumObjects(expecting: Habit.self)
//        let allHabits = realm.objects(Habit.self)
        var events: [Event] = []
        
        var habitsOnDay: [Habit] = []
        for habit in allHabits{
            if habit.days.contains(date.studiumWeekday){ //course occurs on this day.
                habitsOnDay.append(habit)
            }
        }
        for habit in habitsOnDay{
//            if habit.autoschedule{ // auto schedule habit
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                let weekDay = dateFormatter.string(from: date) //get weekday name. ex: "Tuesday"
                //print(weekDay)
//                let usableString = weekDay.substring(toIndex: 3)//transform it to a usable string. ex: "Tuesday" to "Tue"
                if habit.days.contains(date.studiumWeekday) {
                    //habit occurs on this day
                    var components = Calendar.current.dateComponents([.hour, .minute], from: habit.startDate)
                    var usableStartDate = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: date)!
                    
                    components = Calendar.current.dateComponents([.hour, .minute], from: habit.endDate)
                    var usableEndDate = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: date)!
                    
                    //if this habit is autoscheduled, we use the Autoschedule algorithm from Autoschedule class to find the best time for this event to occur. We then change usableStartDate and usableEndDate to the dates calculated by the algorithm.
                    if habit.autoschedule{
                        let dates: [Date]? = Autoschedule.getStartAndEndDates(dateOccurring: date, startBound: usableStartDate, endBound: usableEndDate, totalMinutes: habit.autoLengthMinutes)
                        //there were no open time slots.
                        if dates == nil{
                            continue
                        }
                        print("AUTOSCHEDULING HABIT: \(habit.name) with minutes: \(habit.autoLengthMinutes). AND FOUND DATES: \(dates ?? [])")
                        usableStartDate = dates![0]
                        print("Start: \(usableStartDate.format(with: "h:mm a zzz"))")
                        
                        usableEndDate = dates![1]

//                        components = Calendar.current.dateComponents([.hour, .minute], from: dates[0])
//                        usableStartDate = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: date)!
//
//                        components = Calendar.current.dateComponents([.hour, .minute], from: dates[1])
//                        usableEndDate = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: date)!
                    }
                    let newEvent = Event()
                    newEvent.startDate = usableStartDate
                    newEvent.endDate = usableEndDate
                    newEvent.text = "\(usableStartDate.format(with: DateFormat.standardTime.rawValue)) - \(usableEndDate.format(with: DateFormat.standardTime.rawValue)): \(habit.name)"
                    events.append(newEvent)
                }
            }
        return events
    }
    
    
    
    func addAssignments(for date: Date) -> [Event]{
        var events: [Event] = []
        let allAssignments = DatabaseService.shared.getStudiumObjects(expecting: Assignment.self)

//        let allAssignments = realm.objects(Assignment.self)
        for assignment in allAssignments {
            if assignment.endDate.year == date.year && assignment.endDate.month == date.month && assignment.endDate.day == date.day{
                guard let course = assignment.parentCourse else {
                    print("$Error (DayScheduleViewController): Parent course was nil when adding assignments")
                    continue
                }
                
                let newEvent = Event()
                newEvent.startDate = assignment.startDate
                newEvent.endDate = assignment.endDate
                newEvent.color = course.color
                
                var string = "\(assignment.endDate.format(with: "h:mm a")): \(assignment.name) due (\(course.name))"
                
                if(assignment.isAutoscheduled){
                    string = "\(assignment.startDate.format(with: "h:mm a")) - \(assignment.endDate.format(with: "h:mm a")): \(assignment.name) (\(course.name))"
                }

                let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.label]
                let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
                if assignment.complete{
                    print("Assignment \(assignment.name) is complete!");
                    attributedString.addAttributes([
                    NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                        NSAttributedString.Key.strikethroughColor: UIColor.label,
                    ], range: NSMakeRange(0, attributedString.length))
                }
                newEvent.attributedText = attributedString
                events.append(newEvent)
                print("added assignment \(assignment.name) with start time \(newEvent.startDate) and end time \(newEvent.endDate)")
            }
        }
        return events
    }
    
    func addOtherEvents(for date: Date) -> [Event]{
        var events: [Event] = []
        let allOtherEvents = DatabaseService.shared.getStudiumObjects(expecting: OtherEvent.self)

        for otherEvent in allOtherEvents{
            if otherEvent.endDate.year == date.year && otherEvent.endDate.month == date.month && otherEvent.endDate.day == date.day{
                let newEvent = Event()
                newEvent.startDate = otherEvent.startDate
                newEvent.endDate = otherEvent.endDate
                newEvent.color = .blue
                let string = "\(otherEvent.startDate.format(with: "h:mm a")) - \(otherEvent.endDate.format(with: "h:mm a")) - \(otherEvent.name)"
                
                let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.label]
                let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
                newEvent.attributedText = attributedString
                
                events.append(newEvent)
            }
        }
        return events
    }
    
    // MARK: EventDataSource
    var generatedEvents = [EventDescriptor]()
    var alreadyGeneratedSet = Set<Date>()
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        if !alreadyGeneratedSet.contains(date) {
            alreadyGeneratedSet.insert(date)
            
            generatedEvents.append(contentsOf: generateEventsForDate(date))
        }
        return generatedEvents
    }
    
    private func generateEventsForDate(_ date: Date) -> [EventDescriptor] {
        
        var events = [Event]()
        events.append(contentsOf: addWakeTimes(for: date))
        events.append(contentsOf: addCourses(for: date))
        events.append(contentsOf: addOtherEvents(for: date))
        events.append(contentsOf: addHabits(for: date, with: events))
        events.append(contentsOf: addAssignments(for: date))
    
        return events
    }
    // MARK: DayViewDelegate
    
    private var createdEvent: EventDescriptor?
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        
        print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        endEventEditing()
        print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
        beginEditing(event: descriptor, animated: true)
        print(Date())
    }
    
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
