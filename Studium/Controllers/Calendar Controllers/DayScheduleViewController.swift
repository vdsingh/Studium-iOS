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
    let realm = try! Realm()
    let defaults = UserDefaults.standard
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    
    @IBAction func monthButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toCalendar", sender: self)
    }
    //    @IBAction func timeControlChanged(_ sender: UISegmentedControl) {
//        performSegue(withIdentifier: "toCalendar", sender: self)
//        sender.selectedSegmentIndex = 0
//    }
    
    func addCourses(for date: Date) -> [Event]{
        var events: [Event] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: date) //get weekday name. ex: "Tuesday"
        
        let usableString = weekDay.substring(toIndex: 3)//transform it to a usable string. ex: "Tuesday" to "Tue"
        // let allCoursesOnDay = separateCoursesHelper(dayStringIdentifier: usableString) //get all courses that occur on this day.
        
        var coursesOnDay: [Course] = []
        let allCourses = realm.objects(Course.self)
        for course in allCourses{
            if course.days.contains(usableString){ //course occurs on this day.
                coursesOnDay.append(course)
            }
        }
        
        for course in coursesOnDay{
            let courseEvent = Event()
            courseEvent.startDate = Calendar.current.date(bySettingHour: course.startDate.hour, minute: course.startDate.minute, second: 0, of: date)!
            courseEvent.endDate = Calendar.current.date(bySettingHour: course.endDate.hour, minute: course.endDate.minute, second: 0, of: date)!
            courseEvent.text = "\(course.startDate.format(with: "h:mm a")) - \(course.endDate.format(with: "h:mm a")): \(course.name)"
            courseEvent.color = UIColor(hexString: course.color)!
//            courseEvent.textColor = .white
            events.append(courseEvent)
            
        }
        return events
    }
    
    func addWakeTimes(for date: Date) -> [Event]{
        var events: [Event] = []
        let wakeTimeDictionary = ["Sun": defaults.array(forKey: "sunWakeUp")![0] as! Date, "Mon": defaults.array(forKey: "monWakeUp")![0] as! Date, "Tue": defaults.array(forKey: "tueWakeUp")![0] as! Date, "Wed": defaults.array(forKey: "wedWakeUp")![0] as! Date, "Thu": defaults.array(forKey: "thuWakeUp")![0] as! Date, "Fri": defaults.array(forKey: "friWakeUp")![0] as! Date, "Sat": defaults.array(forKey: "satWakeUp")![0] as! Date]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: date) //get weekday name. ex: "Tuesday"
        let usableString = weekDay.substring(toIndex: 3)
        let timeToWake = wakeTimeDictionary[usableString]!
        
        let hour = calendar.component(.hour, from: timeToWake)
        let minutes = calendar.component(.minute, from: timeToWake)
        let usableDate = Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: date)!
        
        dateFormatter.dateFormat = "h:mm a"
        //let formattedTime = dateFormatter.string(from: timeToWake)
        
        let anHourAgo = usableDate - (60*60)
        //let newEvent = CalendarEvent(startDate: anHourAgo, endDate: usableDate, title: "Wake Up: \(formattedTime)", location: "")
        let newEvent = Event()
        newEvent.startDate = anHourAgo
        newEvent.endDate = usableDate
//        newEvent.text =
        newEvent.attributedText = NSMutableAttributedString(string: "\(usableDate.format(with: "h:mm a")): Wake Up")
        
        events.append(newEvent)
        return events
    }
    
    func addHabits(for date: Date, with outsideEvents: [Event]) -> [Event]{//algorithm to find right time based on pre-existing events.
        //loadHabits()
        let allHabits = realm.objects(Habit.self)
        var events: [Event] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: date) //get weekday name. ex: "Tuesday"
        
        let usableString = weekDay.substring(toIndex: 3)//transform it to a usable string. ex: "Tuesday" to "Tue"
        // let allCoursesOnDay = separateCoursesHelper(dayStringIdentifier: usableString) //get all courses that occur on this day.
        
        var habitsOnDay: [Habit] = []
        for habit in allHabits{
            if habit.days.contains(usableString){ //course occurs on this day.
                habitsOnDay.append(habit)
                print("habit: \(habit.name) occurs on day: \(usableString)")
            }
        }
        for habit in habitsOnDay{
            if habit.autoSchedule{ // auto schedule habit
                if habit.startEarlier{
                    var endHour = habit.startDate.hour + habit.totalHourTime;
                    var endMin = habit.startDate.minute + habit.totalMinuteTime;
                    print("\(habit.name) end hour before: \(endHour) end min before: \(endMin)")
                    if endMin >= 60{
                        endHour += 1
                        endMin -= 60
                    }
                    print("\(habit.name) end hour after: \(endHour) end min after: \(endMin)")

                    print("\(habit.name) start: \(habit.startDate.hour) habit end: \(habit.startDate.minute)")
                    var startBound = Calendar.current.date(bySettingHour: habit.startDate.hour, minute: habit.startDate.minute, second: 0, of: date)!
                    var endBound = Calendar.current.date(bySettingHour: endHour, minute: endMin, second: 0, of: date)!
                    var counter = 0
                    while true {
                        counter+=1
                        if endBound.hour >= habit.endDate.hour && endBound.minute > habit.endDate.minute{
                            print("there was no time to schedule this habit.")
                            break
                        }
                        if isEventBetween(time1: startBound, time2: endBound, events: outsideEvents){
                            let event = getEventBetween(time1: startBound, time2: endBound, events: outsideEvents)
                            //                                   print("The event between \(startBound) and \(endBound) was \(event?.text)")
                            startBound = event!.endDate + 1
                            //print("end of event = \(event!.endDate). new start bound = \(startBound)")
                            var newHour = startBound.hour + habit.totalHourTime
                            var newMin = startBound.minute + habit.totalMinuteTime
                            if(newMin >= 60){
                                newHour += 1;
                                newMin -= 60;
                            }
                            print("date: \(date)")
                            print("new hour: \(newHour) new min: \(newMin)")
                            endBound = Calendar.current.date(bySettingHour: newHour, minute: newMin, second: 0, of: date)!
                            
                        }else{
                            //let newEvent = CalendarEvent(startDate: startBound, endDate: endBound, title: habit.name, location: habit.location)
                            let newEvent = Event()
                            newEvent.startDate = startBound
                            newEvent.endDate = endBound
                            newEvent.color = UIColor(hexString: habit.color)!
//                            newEvent.textColor = .white
                            newEvent.text = "\(habit.name) at \(startBound.format(with: "h:mm a"))"
                            //schedule notification here.
                            if date.year == Date().year && date.month == Date().day && date.day == Date().day{
                                do{
                                    try realm.write{
                                        
                                        habit.deleteNotifications()
                                        for alertTime in habit.notificationAlertTimes{
                                            var title = ""
                                            if alertTime < 60{
                                                title = "\(habit.name) starts in \(alertTime) minutes."
                                            }else if alertTime == 60{
                                                title = "\(habit.name) starts in 1 hour"
                                            }else{
                                                title = "\(habit.name) starts in \(alertTime / 60) hours"
                                            }
                                            
                                            let timeFormat = habit.startDate.format(with: "H:MM a")
                                            let notificationDate = startBound - (60 * Double(alertTime))
                                            let identifier = UUID().uuidString
                                            habit.notificationIdentifiers.append(identifier)
                                            K.scheduleNotification(components: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate), body: "Be there by \(timeFormat). Don't be late!", titles: title, repeatNotif: true, identifier: identifier)
                                        }
                                    }
                                }catch{
                                    print("error scheduling autoschedulable habit.")
                                }
                            }
                            events.append(newEvent)
                            break
                        }
                    }
                }else{ //schedule the habit later rather than earlier
                    var startHour = habit.endDate.hour - habit.totalHourTime
                    var startMin = habit.endDate.minute - habit.totalMinuteTime
                    if startMin < 0{
                        startMin += 60
                        startHour -= 1
                    }
                    var startBound = Calendar.current.date(bySettingHour: startHour, minute: startMin, second: 0, of: date)!
                    var endBound = Calendar.current.date(bySettingHour: habit.endDate.hour, minute: startBound.minute, second: 0, of: date)!
                    
                    var counter = 0
                    while true {
                        counter+=1
                        if startBound.hour <= habit.startDate.hour && startBound.minute < habit.startDate.minute{
                            print("there was no time to schedule this habit.")
                            break
                        }
                        if isEventBetween(time1: startBound, time2: endBound, events: outsideEvents){
                            let event = getEventBetween(time1: startBound, time2: endBound, events: outsideEvents)

                            endBound = event!.startDate - 1
                            var startHour = endBound.hour - habit.totalHourTime
                            var startMin = endBound.minute - habit.totalMinuteTime
                            if startMin < 0{
                                startMin += 60
                                startHour -= 1
                            }
                            
                            startBound = Calendar.current.date(bySettingHour: startHour, minute: startMin, second: 0, of: date)!
                            
                        }else{

                            let newEvent = Event()
                            newEvent.startDate = startBound
                            newEvent.endDate = endBound
                            newEvent.color = UIColor(hexString: habit.color)!
//                            newEvent.textColor = .white
                            newEvent.text = "\(habit.name) at \(startBound.format(with: "h:mm a"))"
                            //schedule notification here.
                            if date.year == Date().year && date.month == Date().day && date.day == Date().day{
                                do{
                                    try realm.write{
                                        habit.deleteNotifications()
                                        for alertTime in habit.notificationAlertTimes{
                                            var title = ""
                                            if alertTime < 60{
                                                title = "\(habit.name) starts in \(alertTime) minutes."
                                            }else if alertTime == 60{
                                                title = "\(habit.name) starts in 1 hour"
                                            }else{
                                                title = "\(habit.name) starts in \(alertTime / 60) hours"
                                            }
                                            
                                            let timeFormat = habit.startDate.format(with: "H:MM a")
                                            let notificationDate = startBound - (60 * Double(alertTime))
                                            let identifier = UUID().uuidString
                                            habit.notificationIdentifiers.append(identifier)
                                            K.scheduleNotification(components: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate), body: "Be there by \(timeFormat). Don't be late!", titles: title, repeatNotif: true, identifier: identifier)
                                        }
                                    }
                                }catch{
                                    print("error scheduling autoschedulable habit.")
                                }
                            }
                            events.append(newEvent)
                            break
                        }
                    }
                }
            }else{ // schedule the habit as a regular event
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                let weekDay = dateFormatter.string(from: date) //get weekday name. ex: "Tuesday"
                //print(weekDay)
                let usableString = weekDay.substring(toIndex: 3)//transform it to a usable string. ex: "Tuesday" to "Tue"
                if habit.days.contains(usableString){ //habit occurs on this day
                    var components = Calendar.current.dateComponents([.hour, .minute], from: habit.startDate)
                    let usableStartDate = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: date)!
                    
                    components = Calendar.current.dateComponents([.hour, .minute], from: habit.endDate)
                    let usableEndDate = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: date)!
                    //let newEvent = CalendarEvent(startDate: usableStartDate, endDate: usableEndDate, title: habit.name, location: habit.location)
                    
                    let newEvent = Event()
                    newEvent.startDate = usableStartDate
                    newEvent.endDate = usableEndDate
                    newEvent.text = "\(habit.startDate.format(with: "h:mm a")) - \(habit.endDate.format(with: "h:mm a")): \(habit.name)"
                    events.append(newEvent)
                }
            }
        }
        return events
    }
    
    func isEventBetween(time1: Date, time2: Date, events: [Event]) -> Bool{
        for event in events{
            if event.startDate <= time1 && event.startDate >= time2{ //the event completely overlaps the space
                return true
            }
            
            if event.startDate >= time1 && event.startDate <= time2{ //the event starts within the space
                return true
            }
            
            if event.endDate >= time1 && event.endDate <= time2{ //the event ends within the space
                return true
            }
        }
        return false
    }
    
    func getEventBetween(time1: Date, time2: Date, events: [Event]) -> Event?{
        for event in events{
            if event.startDate <= time1 && event.startDate >= time2{ //the event completely overlaps the space
                return event
            }
            
            if event.startDate >= time1 && event.startDate <= time2{ //the event starts within the space
                return event
            }
            
            if event.endDate >= time1 && event.endDate <= time2{ //the event ends within the space
                return event
            }
        }
        return nil
    }
    
    func addAssignments(for date: Date) -> [Event]{
        var events: [Event] = []
        let allAssignments = realm.objects(Assignment.self)
        for assignment in allAssignments{
            if assignment.endDate.year == date.year && assignment.endDate.month == date.month && assignment.endDate.day == date.day{
                let newEvent = Event()
                newEvent.startDate = assignment.startDate
                newEvent.endDate = assignment.endDate
                let attributedText : NSMutableAttributedString =  NSMutableAttributedString(string: "\(assignment.endDate.format(with: "h:mm a")): \(assignment.name) due (\(assignment.parentCourse[0].name))")
                if assignment.complete{
                    print("Assignment \(assignment.name) is complete!");
                    attributedText.addAttributes([
                    NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    NSAttributedString.Key.strikethroughColor: UIColor.black,
                    ], range: NSMakeRange(0, attributedText.length))
                }
                newEvent.attributedText = attributedText
                newEvent.color = UIColor(hexString: assignment.parentCourse[0].color)!
//                newEvent.textColor = .white
                
                events.append(newEvent)
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
                newEvent.attributedText = NSMutableAttributedString(string:"\(otherEvent.startDate.format(with: "h:mm a")) - \(otherEvent.endDate.format(with: "h:mm a")) - \(otherEvent.name)")
//                newEvent.text = "\(otherEvent.startDate.format(with: "h:mm a")) - \(otherEvent.endDate.format(with: "h:mm a")) - \(otherEvent.name)"
                events.append(newEvent)
            }
        }
        return events
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayView.autoScrollToFirstEvent = true
        dayView.backgroundColor = .red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
//        viewDidLoad()
        generatedEvents = []
        alreadyGeneratedSet = Set<Date>()
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
