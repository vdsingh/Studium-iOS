//
//  HabitFormView.swift
//  Studium
//
//  Created by Vikram Singh on 9/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct HabitFormView: View {
    
    @Binding var formErrors: [StudiumFormError]
    
    // MARK: - Course Properties
    
    @Binding var name: String
    @Binding var location: String
    @Binding var daysSelected: Set<Weekday>
    
    @Binding var isAutoscheduling: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var totalAutoscheduleLengthMinutes: Int
    
    @Binding var notificationSelections: [AlertOption]
    
    @Binding var icon: StudiumIcon
    @Binding var color: UIColor?
    
    @Binding var additionalDetails: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("Details")) {
                    StudiumTextField(text: self.$name,
                                     placeholderText: "Name",
                                     charLimit: .shortField)
                    StudiumTextField(text: self.$location,
                                     placeholderText: "Location",
                                     charLimit: .shortField)
                    WeekdaysSelectorView(selectedDays: self.$daysSelected)
                }
                
                Section(header: Text("Start / End Time")) {
                    Toggle(isOn: self.$isAutoscheduling, label: {
                        Text("Autoscheduling")
                    })
                    .tint(StudiumColor.secondaryAccent.color)
                    
                    if self.isAutoscheduling {
                        DatePicker("Between", selection: self.$startDate, displayedComponents: [.hourAndMinute]).tint(StudiumColor.primaryAccent.color)
                        DatePicker("And", selection: self.$endDate, displayedComponents: [.hourAndMinute]).tint(StudiumColor.primaryAccent.color)
                        TimeLengthPickerView(totalMinutes: self.$totalAutoscheduleLengthMinutes)
                    } else {
                        DatePicker("Starts", selection: self.$startDate, displayedComponents: [.hourAndMinute]).tint(StudiumColor.primaryAccent.color)
                        DatePicker("Ends", selection: self.$endDate, displayedComponents: [.hourAndMinute]).tint(StudiumColor.primaryAccent.color)
                    }
                    
                    ShowNotificationSelectionButton(selectedOptions: self.$notificationSelections)
                }
                
                Section(header: Text("Customization")) {
                    ShowIconSelectorButton(icon: self.$icon)
                    ColorPickerView(selectedColor: self.$color, colors: StudiumEventColor.allCasesUIColors)
                }
                
                Section {
                    StudiumTextField(text: self.$additionalDetails,
                                     placeholderText: "Additional Details",
                                     charLimit: .longField)
                }
            }
            
            VStack(alignment: .leading, spacing: Increment.one) {
                ForEach(self.formErrors, id: \.self) { error in
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
    
    func createdHabit() -> Habit? {
        self.updateErrors()
        if self.formErrors.isEmpty, let color = self.color {
            // Create the AutoschedulingConfig if isAutoscheduling is true
            let autoschedulingConfig: AutoschedulingConfig? = self.isAutoscheduling ?
            AutoschedulingConfig(autoLengthMinutes: self.totalAutoscheduleLengthMinutes, autoscheduleInfinitely: true, useDatesAsBounds: true, autoschedulingDays: self.daysSelected)
            : nil

            return Habit(name: self.name, location: self.location, additionalDetails: self.additionalDetails, startDate: self.startDate, endDate: self.endDate, autoschedulingConfig: autoschedulingConfig, alertTimes: self.notificationSelections, days: self.daysSelected, icon: self.icon, color: color)
        }
        
        return nil
    }
    
    /// Resets the form errors
    private func updateErrors() {
        self.formErrors = []
        
        if self.name.trimmed().isEmpty{
            self.formErrors.append(.nameNotSpecified)
        }
        
        if self.daysSelected.isEmpty {
            self.formErrors.append(.oneDayNotSpecified)
        }
        
        if self.startDate > self.endDate {
            self.formErrors.append(.endTimeOccursBeforeStartTime)
        }
        
        let timeChunk = TimeChunk(startDate: self.startDate, endDate: self.endDate)
        if self.isAutoscheduling, timeChunk.lengthInMinutes > self.totalAutoscheduleLengthMinutes {
            self.formErrors.append(.totalTimeExceedsTimeFrame)
        }
        
        if self.color == nil {
            self.formErrors.append(.colorNotSpecfied)
        }
    }
}
