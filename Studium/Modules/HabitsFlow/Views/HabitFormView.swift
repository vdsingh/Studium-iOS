//
//  HabitFormView.swift
//  Studium
//
//  Created by Vikram Singh on 9/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

/// ViewModel to enable CourseFormView
class HabitFormViewModel: ObservableObject {
    
    private var originalHabit: Habit?
    private var willComplete: () -> Void
    
    private var isEditing: Bool {
        self.originalHabit != nil
    }
    
    var titleText: String {
        self.isEditing ? "Edit Habit" : "Add Habit"
    }
    
    var positiveCTAButtonText: String {
        self.isEditing ? "Done" : "Add"
    }
    
    // MARK: - Course Properties
    
    @Published var name: String
    @Published var location: String
    @Published var daysSelected: Set<Weekday>
    
    @Published var isAutoscheduling: Bool
    @Published var totalAutoscheduleLengthMinutes: Int

    @Published var startTime: Time
    @Published var endTime: Time
    @Published var notificationSelections: [AlertOption]
    
    @Published var icon: StudiumIcon
    @Published var color: UIColor?
    
    @Published var additionalDetails: String
    
    var constructedAutoschedulingConfig: AutoschedulingConfig? {
        return self.isAutoscheduling ?
        AutoschedulingConfig(autoLengthMinutes: self.totalAutoscheduleLengthMinutes, autoscheduleInfinitely: true, useDatesAsBounds: false, autoschedulingDays: self.daysSelected) :
        nil
    }
    
    /// Maintains any form errors that prevent postiive CTA from successfully completing
    @Published private(set) var formErrors: [StudiumFormError] = []
    
    /// Function called when the positive CTA button is tapped (i.e,. "done" or "add")
    /// - Returns: Whether the form completed successfully
    func positiveCTATapped() -> Bool {
        if let constructedHabit = self.constructHabit() {
            if let originalHabit = self.originalHabit {
                // If editing, update old course
                StudiumEventService.shared.updateStudiumEvent(
                    oldEvent: originalHabit,
                    updatedEvent: constructedHabit
                )
            } else {
                // If adding, create new course
                StudiumEventService.shared.saveStudiumEvent(constructedHabit)
            }
            
            self.willComplete()
            return true
        }
        
        return false
    }
    
    /// Creates a habit from the form fields
    /// - Returns: A habit from the form fields
    func constructHabit() -> Habit? {
        self.updateErrors()
        if self.formErrors.isEmpty, let color = self.color {
            return Habit(name: self.name, location: self.location, additionalDetails: self.additionalDetails, startDate: self.startTime.arbitraryDateWithTime, endDate: self.endTime.arbitraryDateWithTime, autoschedulingConfig: self.constructedAutoschedulingConfig, alertTimes: self.notificationSelections, days: self.daysSelected, icon: self.icon, color: color)
        }
        
        return nil
    }
    
    /// Resets the form errors
    func updateErrors() {
        self.formErrors = []
        if self.name.trimmed().isEmpty { self.formErrors.append(.nameNotSpecified) }
        if self.daysSelected.isEmpty { self.formErrors.append(.oneDayNotSpecified) }
        if self.startTime > self.endTime { self.formErrors.append(.endTimeOccursBeforeStartTime) }
        if self.color == nil { self.formErrors.append(.colorNotSpecfied) }
        
        if self.isAutoscheduling {
            if TimeChunk(startDate: self.startTime.arbitraryDateWithTime, endDate: self.endTime.arbitraryDateWithTime).lengthInMinutes > self.totalAutoscheduleLengthMinutes {
                self.formErrors.append(.totalTimeExceedsTimeFrame)
            }
            
            if self.totalAutoscheduleLengthMinutes <= 0 {
                self.formErrors.append(.totalTimeNotSpecified)
            }
        }
    }
    
    /// Initializer for adding a new course (default values represent "Empty Form")
    /// - Parameters:
    ///   - name:                   Course name
    ///   - location:               Course location
    ///   - daysSelected:           Days selected for course
    ///   - startTime:              The time that the course starts
    ///   - endTime:                The time that the course ends
    ///   - notificationSelections: Notification settings for the course
    ///   - icon:                   The custom icon for the course
    ///   - color:                  The color for the course
    ///   - additionalDetails:      Any additional details associated with the course
    internal init(name: String = "", location: String = "", daysSelected: Set<Weekday> = [], isAutoscheduling: Bool = false, totalAutoLengthMinutes: Int = 60, startTime: Time = .now, endTime: Time = .now.adding(hours: 1, minutes: 0), notificationSelections: [AlertOption] = [], icon: StudiumIcon = .book, color: UIColor? = StudiumEventColor.darkRed.uiColor, additionalDetails: String = "", willComplete: @escaping () -> Void) {
        self.name = name
        self.location = location
        self.daysSelected = daysSelected
        self.isAutoscheduling = isAutoscheduling
        self.totalAutoscheduleLengthMinutes = totalAutoLengthMinutes
        self.startTime = startTime
        self.endTime = endTime
        self.notificationSelections = notificationSelections
        self.icon = icon
        self.color = color
        self.additionalDetails = additionalDetails
        self.willComplete = willComplete
    }

    /// Initiailzer intended to be used for editing a course
    /// - Parameter course: The course to be edited
    internal convenience init(habit: Habit, willComplete: @escaping () -> Void) {
        self.init(name: habit.name, location: habit.location, daysSelected: habit.days, isAutoscheduling: habit.autoscheduling, totalAutoLengthMinutes: habit.autoschedulingConfig?.autoLengthMinutes ?? 60, startTime: habit.startDate.time, endTime: habit.endDate.time, notificationSelections: habit.alertTimes, icon: habit.icon, additionalDetails: habit.additionalDetails, willComplete: willComplete)
        self.originalHabit = habit
    }
}

struct HabitFormView: View {
        
    // MARK: - Course Properties
    
    @ObservedObject var viewModel: HabitFormViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("Details")) {
                    StudiumTextField(text: self.$viewModel.name,
                                     placeholderText: "Name",
                                     charLimit: .shortField)
                    StudiumTextField(text: self.$viewModel.location,
                                     placeholderText: "Location",
                                     charLimit: .shortField)
                    WeekdaysSelectorView(selectedDays: self.$viewModel.daysSelected)
                }
                
                Section(header: Text("Start / End Time")) {
                    Toggle(isOn: self.$viewModel.isAutoscheduling, label: {
                        Text("Autoscheduling")
                    })
                    .tint(StudiumColor.secondaryAccent.color)
                    
                    if Flags.allowHabitAutoscheduling.value || self.viewModel.isAutoscheduling {
                        TimePicker(label: "Between", time: self.$viewModel.startTime)
                        TimePicker(label: "And", time: self.$viewModel.endTime)
                        TimeLengthPickerView(totalMinutes: self.$viewModel.totalAutoscheduleLengthMinutes)
                    } else {
                        TimePicker(label: "Starts", time: self.$viewModel.startTime)
                        TimePicker(label: "Ends", time: self.$viewModel.endTime)
                    }
                    
                    
                    ShowNotificationSelectionButton(selectedOptions: self.$viewModel.notificationSelections)
                }
                
                Section(header: Text("Customization")) {
                    ShowIconSelectorButton(icon: self.$viewModel.icon)
                    ColorPickerView(selectedColor: self.$viewModel.color, colors: StudiumEventColor.allCasesUIColors)
                }
                
                Section {
                    StudiumTextField(text: self.$viewModel.additionalDetails,
                                     placeholderText: "Additional Details",
                                     charLimit: .longField)
                }
            }
            
            VStack(alignment: .leading, spacing: Increment.one) {
                ForEach(self.viewModel.formErrors, id: \.self) { error in
                    HStack(alignment: .top) {
                        TinyIcon(color: .red, image: SystemIcon.circleFill.uiImage)
                        Text(error.stringRepresentation)
                    }
                    .foregroundStyle(StudiumColor.failure.color)
                }
            }
            .padding(.horizontal, Increment.three)
        }
    }
}
