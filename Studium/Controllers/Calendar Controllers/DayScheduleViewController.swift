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
//
import UIKit
import CalendarKit
import DateToolsSwift

class DayScheduleViewController: DayViewController{
        let realm = try! Realm()
        let defaults = UserDefaults.standard

    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    //        var allAssignments: Results<Assignment>?
        //var allCourses: Results<Course>?
//        var allHabits: Results<Habit>?
//        var allOtherEvents: Results<OtherEvent>?
//
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            title = "CalendarKit Demo"
//
//            dayView.autoScrollToFirstEvent = true
//            reloadData()
//        }
//
//        override func viewWillAppear(_ animated: Bool) {
//            loadAssignments()
//            loadCourses()
//            loadHabits()
//            loadOtherEvents()
//            reloadData()
//            navigationItem.hidesBackButton = true
//
//            let navigationBar = navigationController!.navigationBar
//
//            navigationBar.barTintColor = UIColor(red: 0.65882, green: 0.08627, blue: 0.08627, alpha: 1)
//    //        navigationBar.isTranslucent = false
//    //        navigationBar.setBackgroundImage(UIImage(), for: .default)
//    //        navigationBar.shadowImage = UIImage()
//
//            let navBarColor = navigationBar.barTintColor
//            var style = CalendarStyle()
//            style.header.backgroundColor = navBarColor!
//
//            dayView.autoScrollToFirstEvent = true
//            dayView.updateStyle(style)
//        }
//
        @IBAction func timeControlChanged(_ sender: UISegmentedControl) {
            performSegue(withIdentifier: "toCalendar", sender: self)
            sender.selectedSegmentIndex = 0
        }
//
//        override func eventsForDate(_ date: Date) -> [EventDescriptor] {
//            //viewWillAppear(true)
//
//            //let event = CalendarEvent()
//
//            var models: [CalendarEvent] = []
//            models = models + addCoursesBasedOnDay(onDate: date)
//            models = models + addAssignments()
//            models = models + addWakeTimes(onDate: date)
//
//            models = models + addOtherEvents()
//            models = models + addHabits(onDate: date, withEvents: models)
//
//            var events = [Event]()
//
//            for model in models {
//                let event = Event()
//                event.startDate = model.startDate
//                event.endDate = model.endDate
//                var info = [model.title, model.location]
//                info.append("\(event.startDate.format(with: "HH:mm")) - \(event.endDate.format(with: "HH:mm"))")
//                event.text = info.reduce("", {$0 + $1 + "\n"})
//                events.append(event)
//            }
//            return events
//        }
//
//
//        func loadCourses(){
//            allCourses = realm.objects(Course.self)
//        }
//        func loadHabits(){
//            allHabits = realm.objects(Habit.self)
//        }
//        func loadAssignments(){
//            allAssignments = realm.objects(Assignment.self)
//        }
//        func loadOtherEvents(){
//            allOtherEvents = realm.objects(OtherEvent.self)
//        }
//        func addAssignments() -> [CalendarEvent]{
//            var newArr: [CalendarEvent] = []
//            if let assignmentsArray = allAssignments{
//                for assignment in assignmentsArray{
//                    let newAssignmentEvent = CalendarEvent(startDate: assignment.startDate, endDate: assignment.endDate, title: assignment.name, location: "Due at: \(assignment.endDate.format(with: "h:mm a"))")
//                    newArr.append(newAssignmentEvent)
//                }
//            }else{
//                print("error. allAssignments is nil.")
//            }
//            return newArr
//        }
//
//        func addOtherEvents() -> [CalendarEvent]{
//            var newArr: [CalendarEvent] = []
//            if let otherEventArray = allOtherEvents{
//                for otherEvent in otherEventArray{
//                    let newOtherEvent = CalendarEvent(startDate: otherEvent.startDate, endDate: otherEvent.endDate, title: otherEvent.name, location: "\(otherEvent.endDate.format(with: "h:mm a"))")
//                    newArr.append(newOtherEvent)
//                }
//            }else{
//                print("error. allAssignments is nil.")
//            }
//            return newArr
//        }
//
//        func separateCoursesHelper(dayStringIdentifier: String) -> [Course]{
//
//            return daysArray
//        }
////
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
                courseEvent.text = course.name
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
            newEvent.text = "Wake Up"

            events.append(newEvent)
            return events
        }

    func addHabits(for date: Date, with outsideEvents: [Event]) -> [Event]{//algorithm to find right time based on pre-existing events.
            //loadHabits()
            let allHabits = realm.objects(Habit.self)
            var events: [Event] = []
                for habit in allHabits{
                    if habit.autoSchedule{ // auto schedule habit
                        if habit.startEarlier{
                            var startBound = Calendar.current.date(bySettingHour: habit.startDate.hour, minute: habit.startDate.minute, second: 0, of: date)!
                            var endBound = Calendar.current.date(bySettingHour: startBound.hour + habit.totalHourTime, minute: startBound.minute + habit.totalMinuteTime, second: 0, of: date)!

                            var counter = 0
                            while true {
                                counter+=1
                                if endBound.hour >= habit.endDate.hour && endBound.minute > habit.endDate.minute{
                                    print("was no time to schedule this event")
                                    break
                                }
                                if isEventBetween(time1: startBound, time2: endBound, events: outsideEvents){
                                    let event = getEventBetween(time1: startBound, time2: endBound, events: outsideEvents)
                                   print("The event between \(startBound) and \(endBound) was \(event?.text)")
                                    startBound = event!.endDate + 1
                                    //print("end of event = \(event!.endDate). new start bound = \(startBound)")
                                    endBound = Calendar.current.date(bySettingHour: startBound.hour + habit.totalHourTime, minute: startBound.minute + habit.totalMinuteTime, second: 0, of: date)!
                                }else{
                                    //let newEvent = CalendarEvent(startDate: startBound, endDate: endBound, title: habit.name, location: habit.location)
                                    let newEvent = Event()
                                    newEvent.startDate = startBound
                                    newEvent.endDate = endBound
                                    newEvent.text = habit.name

                                    events.append(newEvent)
                                    break
                                }
                            }
                        }else{ //schedule the habit later rather than earlier
                            
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
                            newEvent.text = habit.name
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
    
    var generatedEvents = [EventDescriptor]()
    var alreadyGeneratedSet = Set<Date>()
    
    //colors of events in the day view calendar
    var colors = [UIColor.blue,
                  UIColor.yellow,
                  UIColor.green,
                  UIColor.red]
    
    
    
    override func loadView() {
        dayView = DayView(calendar: calendar)
        view = dayView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dayView.autoScrollToFirstEvent = true
        reloadData()
    }
    
    
    //returns a date without any time components (strictly the date)
    func dateOnly(date: Date, calendar: Calendar) -> Date {
        let yearComponent = calendar.component(.year, from: date)
        let monthComponent = calendar.component(.month, from: date)
        let dayComponent = calendar.component(.day, from: date)
        let zone = calendar.timeZone
        
        let newComponents = DateComponents(timeZone: zone,
                                           year: yearComponent,
                                           month: monthComponent,
                                           day: dayComponent)
        let returnValue = calendar.date(from: newComponents)
        
        //    let returnValue = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date)
        
        
        return returnValue!
    }
    
    // MARK: EventDataSource
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        if !alreadyGeneratedSet.contains(date) {
            alreadyGeneratedSet.insert(date)
            generatedEvents.append(contentsOf: generateEventsForDate(date))
        }
        return generatedEvents
    }
    private func generateEventsForDate(_ date: Date) -> [EventDescriptor]{
        var events: [Event] = []
        events = events + addCourses(for: date)
        events = events + addWakeTimes(for: date)
        events = events + addHabits(for: date, with: events)
        for event in events{
            print(event.text)
            print(event.startDate)
        }
        return events
    }

//    private func generateEventsForDate(_ date: Date) -> [EventDescriptor] {
//        var workingDate = date.add(TimeChunk.dateComponents(hours: Int(arc4random_uniform(10) + 5)))
//        var events = [Event]()
//
//        for i in 0...4 {
//            let event = Event()
//            let duration = Int(arc4random_uniform(160) + 60)
//            let datePeriod = TimePeriod(beginning: workingDate,
//                                        chunk: TimeChunk.dateComponents(minutes: duration))
//
//            event.startDate = datePeriod.beginning!
//            event.endDate = datePeriod.end!
//
//            var info = data[Int(arc4random_uniform(UInt32(data.count)))]
//
//            let timezone = dayView.calendar.timeZone
//            print(timezone)
//            info.append(datePeriod.beginning!.format(with: "dd.MM.YYYY", timeZone: timezone))
//            info.append("\(datePeriod.beginning!.format(with: "HH:mm", timeZone: timezone)) - \(datePeriod.end!.format(with: "HH:mm", timeZone: timezone))")
//            event.text = info.reduce("", {$0 + $1 + "\n"})
//            event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
//            event.isAllDay = Int(arc4random_uniform(2)) % 2 == 0
//
//            // Event styles are updated independently from CalendarStyle
//            // hence the need to specify exact colors in case of Dark style
//            if #available(iOS 12.0, *) {
//                if traitCollection.userInterfaceStyle == .dark {
//                    event.textColor = textColorForEventInDarkTheme(baseColor: event.color)
//                    event.backgroundColor = event.color.withAlphaComponent(0.6)
//                }
//            }
//
//            events.append(event)
//
//            let nextOffset = Int(arc4random_uniform(250) + 40)
//            workingDate = workingDate.add(TimeChunk.dateComponents(minutes: nextOffset))
//            event.userInfo = String(i)
//        }
//
//        print("Events for \(date)")
//        return events
//    }
    
    private func textColorForEventInDarkTheme(baseColor: UIColor) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        baseColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s * 0.3, brightness: b, alpha: a)
    }
    
    // MARK: DayViewDelegate
    
    private var createdEvent: EventDescriptor?
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        //print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        endEventEditing()
        //print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
        beginEditing(event: descriptor, animated: true)
        //print(Date())
    }
    
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        endEventEditing()
        //print("Did Tap at date: \(date)")
    }
    
    override func dayViewDidBeginDragging(dayView: DayView) {
        //print("DayView did begin dragging")
    }
    
    override func dayView(dayView: DayView, willMoveTo date: Date) {
        //print("DayView = \(dayView) will move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
        //print("DayView = \(dayView) did move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        //print("Did long press timeline at date \(date)")
        // Cancel editing current event and start creating a new one
        endEventEditing()
        //print("Creating a new event")

    }
    
    
    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        //print("did finish editing \(event)")
        //print("new startDate: \(event.startDate) new endDate: \(event.endDate)")
        
        if let _ = event.editedEvent {
            event.commitEditing()
        }
        
        if let createdEvent = createdEvent {
            createdEvent.editedEvent = nil
            generatedEvents.append(createdEvent)
            self.createdEvent = nil
            endEventEditing()
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





