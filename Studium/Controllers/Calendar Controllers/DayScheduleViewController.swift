//
//  DayScheduleViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//
//
//import UIKit
//import CalendarKit
import RealmSwift
import UIKit
import CalendarKit
import DateToolsSwift
//
class DayScheduleViewController: DayViewController{
    let app = App(id: Secret.appID)

    var realm: Realm!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = app.currentUser else {
            print("ERROR: error getting user in DayScheduleViewController viewDidLoad")
            return
        }
        realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
        dayView.autoScrollToFirstEvent = true
        
//        tabBarController?.tabBar.tintColor = K.themeColor
        tabBarController?.tabBar.backgroundColor = K.themeColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
//        viewDidLoad()
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

        if let user = app.currentUser{
            realm = try! Realm(configuration: user.configuration(partitionValue: user.id))

        }else{
            print("$ ERROR: error getting user when adding courses in DayScheduleViewController. Logging Out.")
            K.handleLogOut()
            return []
        }
    
        var coursesOnDay: [Course] = []
        let allCourses = realm.objects(Course.self)
        for course in allCourses{
            if course.days.contains(date.weekday){ //course occurs on this day.
                coursesOnDay.append(course)
            }
        }
        
        for course in coursesOnDay{
            let courseEvent = Event()
            courseEvent.startDate = Calendar.current.date(bySettingHour: course.startDate.hour, minute: course.startDate.minute, second: 0, of: date)!
            courseEvent.endDate = Calendar.current.date(bySettingHour: course.endDate.hour, minute: course.endDate.minute, second: 0, of: date)!
            courseEvent.color = UIColor(hexString: course.color)!
            
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
            print("LOG: user did not specify wake times.")
            return []
        }
        
        let timeToWake = defaults.array(forKey: K.wakeUpKeyDict[date.weekday]!)![0] as! Date
        
        let hour = calendar.component(.hour, from: timeToWake)
        let minutes = calendar.component(.minute, from: timeToWake)
        let usableDate = Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: date)!

        let anHourAgo = usableDate - (60*60)
        let newEvent = Event()
        newEvent.startDate = anHourAgo
        newEvent.endDate = usableDate
        newEvent.color = UIColor.yellow
        
        
        let string = "\(usableDate.format(with: "h:mm a")): Wake Up"
        
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.label]
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        newEvent.attributedText = attributedString
        
        events.append(newEvent)
        return events
    }
    
    func addHabits(for date: Date, with outsideEvents: [Event]) -> [Event]{//algorithm to find right time based on pre-existing events.
        let allHabits = realm.objects(Habit.self)
        var events: [Event] = []
        
        var habitsOnDay: [Habit] = []
        for habit in allHabits{
            if habit.days.contains(date.weekday){ //course occurs on this day.
                habitsOnDay.append(habit)
            }
        }
        for habit in habitsOnDay{
//            if habit.autoschedule{ // auto schedule habit
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                let weekDay = dateFormatter.string(from: date) //get weekday name. ex: "Tuesday"
                //print(weekDay)
                let usableString = weekDay.substring(toIndex: 3)//transform it to a usable string. ex: "Tuesday" to "Tue"
                if habit.days.contains(date.weekday){ //habit occurs on this day
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
                    newEvent.text = "\(usableStartDate.format(with: "h:mm a")) - \(usableEndDate.format(with: "h:mm a")): \(habit.name)"
                    events.append(newEvent)
                }
            }
        
//        else{ //BASIC HABIT FUNCTIONALITY
//
//            }
//        }
        return events
    }
    
    
    
    func addAssignments(for date: Date) -> [Event]{
        var events: [Event] = []
        let allAssignments = realm.objects(Assignment.self)
        for assignment in allAssignments{
            if assignment.endDate.year == date.year && assignment.endDate.month == date.month && assignment.endDate.day == date.day{
                guard let course = assignment.parentCourse else{
                    print("ERROR: Error accessing parent course in DayScheduleViewController")
                    continue
                }
                let newEvent = Event()
                newEvent.startDate = assignment.startDate
                newEvent.endDate = assignment.endDate
                newEvent.color = UIColor(hexString: course.color)!
                
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
        let allOtherEvents = realm.objects(OtherEvent.self)
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
//        print("DayView = \(dayView) did move to: \(date)")
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
    
}
extension TimeChunk {
    static func dateComponents(seconds: Int = 0,
                               minutes: Int = 0,
                               hours: Int = 0,
                               days: Int = 0,
                               weeks: Int = 0,
                               months: Int = 0,
                               years: Int = 0) -> TimeChunk {
        return TimeChunk(seconds: seconds,
                         minutes: minutes,
                         hours: hours,
                         days: days,
                         weeks: weeks,
                         months: months,
                         years: years)
    }
}



//func isEventBetween(time1: Date, time2: Date, events: [Event]) -> Bool{
//    for event in events{
//        if event.startDate <= time1 && event.startDate >= time2{ //the event completely overlaps the space
//            return true
//        }
//
//        if event.startDate >= time1 && event.startDate <= time2{ //the event starts within the space
//            return true
//        }
//
//        if event.endDate >= time1 && event.endDate <= time2{ //the event ends within the space
//            return true
//        }
//    }
//    return false
//}
//
//func getEventBetween(time1: Date, time2: Date, events: [Event]) -> Event?{
//    for event in events{
//        if event.startDate <= time1 && event.startDate >= time2{ //the event completely overlaps the space
//            return event
//        }
//
//        if event.startDate >= time1 && event.startDate <= time2{ //the event starts within the space
//            return event
//        }
//
//        if event.endDate >= time1 && event.endDate <= time2{ //the event ends within the space
//            return event
//        }
//    }
//    return nil
//}

//    func autoschedule(for date: Date, earlier: Bool, finalStartBound: Date, finalEndBound: Date, autoEvent: Autoscheduleable, with outsideEvents: [Event], events: [Event]) -> Event{
//        if earlier{
//            var endHour = finalStartBound.hour + autoEvent.autoLengthHours;
//            var endMin = finalStartBound.minute + autoEvent.autoLengthMinutes;
//            if endMin >= 60{
//                endHour += 1
//                endMin -= 60
//            }
//            var startBound = Calendar.current.date(bySettingHour: finalStartBound.hour, minute: finalStartBound.minute, second: 0, of: date)!
//            var endBound = Calendar.current.date(bySettingHour: endHour, minute: endMin, second: 0, of: date)!
//            var counter = 0
//            while true {
//                counter+=1
//                if endBound.hour >= finalEndBound.hour && endBound.minute > finalEndBound.minute{
//                    print("there was no time to schedule this habit.")
//                    break
//                }
//                if isEventBetween(time1: startBound, time2: endBound, events: outsideEvents){
//                    let event = getEventBetween(time1: startBound, time2: endBound, events: outsideEvents)
//                    //                                   print("The event between \(startBound) and \(endBound) was \(event?.text)")
//                    startBound = event!.endDate + 1
//                    //print("end of event = \(event!.endDate). new start bound = \(startBound)")
//                    var newHour = startBound.hour + autoEvent.autoLengthHours
//                    var newMin = startBound.minute + autoEvent.autoLengthMinutes
//                    if(newMin >= 60){
//                        newHour += 1;
//                        newMin -= 60;
//                    }
//                    endBound = Calendar.current.date(bySettingHour: newHour, minute: newMin, second: 0, of: date)!
//
//                }else{
//                    //let newEvent = CalendarEvent(startDate: startBound, endDate: endBound, title: habit.name, location: habit.location)
//                    let newEvent = Event()
//                    newEvent.startDate = startBound
//                    newEvent.endDate = endBound
//                    newEvent.color = UIColor(hexString: autoEvent.color)!
//
//                    let string = "\(autoEvent.name) at \(startBound.format(with: "h:mm a"))"
//                    let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.label]
//                    let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
//                    newEvent.attributedText = attributedString
//
//                    //schedule notification here.
//                    if date.year == Date().year && date.month == Date().day && date.day == Date().day{
//                        do{
//                            try realm.write{
//
//                                autoEvent.deleteNotifications()
//                                for alertTime in autoEvent.notificationAlertTimes{
//                                    var title = ""
//                                    if alertTime < 60{
//                                        title = "\(autoEvent.name) starts in \(alertTime) minutes."
//                                    }else if alertTime == 60{
//                                        title = "\(autoEvent.name) starts in 1 hour"
//                                    }else{
//                                        title = "\(autoEvent.name) starts in \(alertTime / 60) hours"
//                                    }
//
//                                    let timeFormat = autoEvent.startDate.format(with: "H:MM a")
//                                    let notificationDate = startBound - (60 * Double(alertTime))
//                                    let identifier = UUID().uuidString
//                                    autoEvent.notificationIdentifiers.append(identifier)
//                                    K.scheduleNotification(components: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate), body: "Be there by \(timeFormat). Don't be late!", titles: title, repeatNotif: true, identifier: identifier)
//                                }
//                            }
//                        }catch{
//                            print("error scheduling autoschedulable habit.")
//                        }
//                    }
////                    events.append(newEvent)
////                    break
//                    return newEvent
//                }
//            }
//        }else{ //schedule the habit later rather than earlier
//            var startHour = finalEndBound.hour - autoEvent.autoLengthHours
//            var startMin = finalEndBound.minute - autoEvent.autoLengthMinutes
//            if startMin < 0{
//                startMin += 60
//                startHour -= 1
//            }
//            var startBound = Calendar.current.date(bySettingHour: startHour, minute: startMin, second: 0, of: date)!
//            var endBound = Calendar.current.date(bySettingHour: finalEndBound.hour, minute: startBound.minute, second: 0, of: date)!
//
//            var counter = 0
//            while true {
//                counter+=1
//                if startBound.hour <= finalStartBound.hour && startBound.minute < finalStartBound.minute{
//                    print("there was no time to schedule this habit.")
//                    break
//                }
//                if isEventBetween(time1: startBound, time2: endBound, events: outsideEvents){
//                    let event = getEventBetween(time1: startBound, time2: endBound, events: outsideEvents)
//
//                    endBound = event!.startDate - 1
//                    var startHour = endBound.hour - autoEvent.autoLengthHours
//                    var startMin = endBound.minute - autoEvent.autoLengthMinutes
//                    if startMin < 0{
//                        startMin += 60
//                        startHour -= 1
//                    }
//
//                    startBound = Calendar.current.date(bySettingHour: startHour, minute: startMin, second: 0, of: date)!
//
//                }else{
//
//                    let newEvent = Event()
//                    newEvent.startDate = startBound
//                    newEvent.endDate = endBound
//                    newEvent.color = UIColor(hexString: autoEvent.color)!
//
//                    let string = "\(autoEvent.name) at \(startBound.format(with: "h:mm a"))"
//                    let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.label]
//                    let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
//                    newEvent.attributedText = attributedString
//
//                    //schedule notification here.
//                    if date.year == Date().year && date.month == Date().day && date.day == Date().day{
//                        do{
//                            try realm.write{
//                                autoEvent.deleteNotifications()
//                                for alertTime in autoEvent.notificationAlertTimes{
//                                    var title = ""
//                                    if alertTime < 60{
//                                        title = "\(autoEvent.name) starts in \(alertTime) minutes."
//                                    }else if alertTime == 60{
//                                        title = "\(autoEvent.name) starts in 1 hour"
//                                    }else{
//                                        title = "\(autoEvent.name) starts in \(alertTime / 60) hours"
//                                    }
//
//                                    let timeFormat = autoEvent.startDate.format(with: "H:MM a")
//                                    let notificationDate = startBound - (60 * Double(alertTime))
//                                    let identifier = UUID().uuidString
//                                    autoEvent.notificationIdentifiers.append(identifier)
//                                    K.scheduleNotification(components: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate), body: "Be there by \(timeFormat). Don't be late!", titles: title, repeatNotif: true, identifier: identifier)
//                                }
//                            }
//                        }catch{
//                            print("error scheduling autoschedulable habit.")
//                        }
//                    }
//                    events.append(newEvent)
//                    break
//                    return newEvent
//                }
//            }
//        }
//        let newEvent = Event()
//        newEvent.startDate = autoEvent.startDate
//        newEvent.endDate = autoEvent.startDate + (autoEvent.autoLengthHours * 360) + (autoEvent.autoLengthMinutes * 60)
//        newEvent.color = UIColor(hexString: autoEvent.color)!
//        newEvent.text = "\(autoEvent.name) at \(autoEvent.startDate.format(with: "h:mm a"))"
//        return newEvent
//    }
