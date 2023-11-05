//
//  Habit.swift
//  Studium
//
//  Created by Vikram Singh on 5/27/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftUI

// TODO: Docstrings
class Habit: RecurringStudiumEvent, Autoscheduling {

    typealias AutoscheduledEventType = OtherEvent

    // MARK: - Autoscheduleable Variables

    /// Contains the events that this habit has autoscheduled
    @Persisted var autoscheduledEventsList = RealmSwift.List<OtherEvent>()

    /// DO NOT USE: use `habit.autoschedulingConfig` instead, which decodes/encodes the data
    @Persisted var autoschedulingConfigData: Data?

    // TODO: Docstrings
    convenience init(
        name: String,
        location: String,
        additionalDetails: String,
        startTime: Time,
        endTime: Time,
        autoschedulingConfig: AutoschedulingConfig?,
        alertTimes: Set<AlertOption>,
        days: Set<Weekday>,
        icon: StudiumIcon,
        color: UIColor
    ) {
        self.init()
        self.name = name
        self.location = location
        self.additionalDetails = additionalDetails
        self.startTime = startTime
        self.endTime = endTime

//        self.init(name: name, location: location, additionalDetails: additionalDetails, startTime: startTime, endTime: endTime, color: color, icon: icon, alertTimes: alertTimes)
        self.autoschedulingConfig = autoschedulingConfig
        self.alertTimes = alertTimes
        self.days = days
        self.icon = icon
        self.color = color
    }

    func instantiateAutoscheduledEvents(datesAndTimeChunks: [(Date, TimeChunk)]) -> [OtherEvent] {
        var otherEvents = [OtherEvent]()
        for (date, timeChunk) in datesAndTimeChunks {
            let startDate = date.setTime(hour: timeChunk.startTime.hour, minute: timeChunk.startTime.minute, second: 0)
            let endDate = date.setTime(hour: timeChunk.endTime.hour, minute: timeChunk.endTime.minute, second: 0)

            let otherEvent = OtherEvent(
                name: self.name,
                location: self.location,
                additionalDetails: "This Event was Autoscheduled by your Habit: \(self.name)",
                startDate: startDate,
                endDate: endDate,
                alertTimes: self.alertTimes,
                icon: self.icon,
                color: self.color
            )
            otherEvent.autoscheduled = true
            otherEvents.append(otherEvent)
        }

        return otherEvents
    }

    override func timeChunkForDate(date: Date) -> TimeChunk? {
        if self.autoscheduling {
            return nil
        }

        return super.timeChunkForDate(date: date)
    }

    // MARK: - View Related

    // MARK: Class (Relevant to the Habit Type)

    override class var displayName: String {
        return "Habit"
    }

    override class var tabItemConfig: TabItemConfig {
        return .habitsList
    }

    override class func addFormView() -> AnyView {
        return AnyView(
            HabitFormView(viewModel: .init(willComplete: {}))
        )
    }
    
    override class var emptyListPositiveCTACardViewModel: ImageDetailViewModel {
        return ImageDetailViewModel(
            image: FlatImage.travelingAndSports.uiImage,
            title: "No Habits here yet",
            subtitle: nil,
            buttonText: "Add a Habit"
        )
    }

    // MARK: Instance (Relevant to a specific Habit)

    override func detailsView() -> AnyView {
        return AnyView(
            HabitView(habit: self)
        )
    }

    override func editFormView() -> AnyView {
        return AnyView(
            HabitFormView(
                viewModel: HabitFormViewModel(habit: self, willComplete: {})
            )
        )
    }
}

// MARK: - Mocking

extension Habit {
    static func mock(autoscheduling: Bool) -> Habit {
        let autoschedulingConfig: AutoschedulingConfig? = autoscheduling ? .mock() : nil
        let habit = Habit(
            name: "Mock Habit",
            location: "Mock Location",
            additionalDetails: "Mock Additional Details",
            startTime: Time.noon,
            endTime: (Time.noon+60),
            autoschedulingConfig: autoschedulingConfig,
            alertTimes: [.fiveMin, .fifteenMin],
            days: [.monday, .wednesday],
            icon: .binoculars,
            color: StudiumEventColor.blue.uiColor
        )

        habit.ekEventID = "EK Event ID"
        habit.googleCalendarEventID = "Google Calendar Event ID"

        return habit
    }
}
