//
//  AssignmentFormView.swift
//  Studium
//
//  Created by Vikram Singh on 10/4/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

// FIXME: snapshot and unit tests for this

/// ViewModel to enable AssignmentFormView
class AssignmentFormViewModel: ObservableObject, FormViewModel {

    let course: Course
    var originalAssignment: Assignment?
    private var willComplete: () -> Void

    // MARK: - Computed Properties

    private var isEditing: Bool {
        self.originalAssignment != nil
    }

    var titleText: String {
        self.isEditing ? "Edit Assignment" : "Add Assignment"
    }

    var positiveCTAButtonText: String {
        self.isEditing ? "Done" : "Add"
    }

    var titleDisplayMode: NavigationBarItem.TitleDisplayMode {
        return .inline
    }

    var showAutoschedulingFields: Bool {
        if let originalAssignment = self.originalAssignment, originalAssignment.autoscheduling {
            // Show if original habit is autoscheduling, we have to show fields
            return true
        }

        return ServerFlags.allowAssignmentAutoscheduling.value
    }

    /// Autoscheduling Config constructed from the form
    var constructedAutoschedulingConfig: AutoschedulingConfig? {
        // FIXME: fix start time bound and end time bound
        return self.isAutoscheduling ?
        AutoschedulingConfig(autoLengthMinutes: self.totalAutoscheduleLengthMinutes,
                             startDateBound: Date(),
                             endDateBound: nil,
                             startTimeBound: Time.startOfDay,
                             endTimeBound: Time.endOfDay,
                             autoschedulingDays: self.autoscheduleDays)
        :
        nil
    }

    // MARK: - Assignment Properties

    @Published var name: String
    @Published var location: String

    @Published var isAutoscheduling: Bool
    @Published var totalAutoscheduleLengthMinutes: Int
    @Published var autoscheduleDays: Set<Weekday>

    @Published var startDate: Date
    @Published var endDate: Date
    @Published var notificationSelections: Set<AlertOption>

    @Published var additionalDetails: String

    /// Maintains any form errors that prevent postiive CTA from successfully completing
    @Published private(set) var formErrors: [StudiumFormError] = []

    /// Function called when the positive CTA button is tapped (i.e,. "done" or "add")
    /// - Returns: Whether the form completed successfully
    func positiveCTATapped() -> Bool {
        if let constructedAssignment = self.constructAssignment() {
            if let originalAssignment = self.originalAssignment {
                // If editing, update old assignment
                StudiumEventService.shared.updateStudiumEvent(
                    oldEvent: originalAssignment,
                    updatedEvent: constructedAssignment
                )
            } else {
                // If adding, create new assignment
                StudiumEventService.shared.saveStudiumEvent(constructedAssignment)
            }

            self.willComplete()
            return true
        }

        return false
    }

    /// Creates an assignment from the form fields
    /// - Returns: An assignment from the form fields
    func constructAssignment() -> Assignment? {
        self.updateErrors()
        if self.formErrors.isEmpty {
            return Assignment(
                name: self.name,
                additionalDetails: self.additionalDetails,
                complete: false,
                startDate: self.startDate,
                endDate: self.endDate,
                notificationAlertTimes: self.notificationSelections,
                autoschedulingConfig: self.constructedAutoschedulingConfig,
                parentCourse: self.course
            )
        }

        return nil
    }

    /// Resets the form errors
    func updateErrors() {
        Log.d("Update Errors called. self name: \(self.name)")
        self.formErrors = []
        if self.name.trimmed().isEmpty { self.formErrors.append(.nameNotSpecified) }
        if self.startDate > self.endDate { self.formErrors.append(.endDateOccursBeforeStartDate) }
        if self.isAutoscheduling {
            if self.autoscheduleDays.isEmpty {
                self.formErrors.append(.oneDayNotSpecified)
            }

            if self.totalAutoscheduleLengthMinutes <= 0 {
                self.formErrors.append(.totalTimeNotSpecified)
            }
        }
    }

    internal init(course: Course,
                  name: String = "",
                  location: String = "",
                  isAutoscheduling: Bool = ServerFlags.enableAssignmentAutoschedulingByDefault.value,
                  totalAutoLengthMinutes: Int = 60,
                  autoscheduleDays: Set<Weekday> = [],
                  startDate: Date = Date(),
                  endDate: Date = Date().add(hours: 1),
                  notificationSelections: Set<AlertOption> = UserDefaultsService.defaultNotificationPreferences,
                  additionalDetails: String = "",
                  willComplete: @escaping () -> Void) {

        self.course = course
        self.name = name
        self.location = location

        self.isAutoscheduling = isAutoscheduling
        self.totalAutoscheduleLengthMinutes = totalAutoLengthMinutes
        self.autoscheduleDays = autoscheduleDays

        self.startDate = startDate
        self.endDate = endDate
        self.notificationSelections = notificationSelections

        self.additionalDetails = additionalDetails
        self.willComplete = willComplete
    }

    /// Initiailzer intended to be used for editing an assignment
    /// - Parameter assignment: The assignment to be edited
    /// - Parameter willComplete: closure called right before positive CTA tap action will finish
    internal convenience init(assignment: Assignment, willComplete: @escaping () -> Void) {
        self.init(course: assignment.parentCourse,
                  name: assignment.name,
                  location: assignment.location,
                  isAutoscheduling: assignment.autoscheduling,
                  totalAutoLengthMinutes: assignment.autoschedulingConfig?.autoLengthMinutes ?? 60,
                  autoscheduleDays: assignment.autoschedulingConfig?.autoschedulingDays ?? [],
                  startDate: assignment.startDate,
                  endDate: assignment.endDate,
                  notificationSelections: assignment.alertTimes,
                  additionalDetails: assignment.additionalDetails,
                  willComplete: willComplete)
        self.originalAssignment = assignment
    }
}

struct AssignmentFormView: View {

    @ObservedObject var viewModel: AssignmentFormViewModel

    var body: some View {
        VStack {
            FormContainer(formViewModel: self.viewModel) {
                self.formView
            }

            // Displays Errors
            VStack(alignment: .leading, spacing: Increment.one) {
                ForEach(self.viewModel.formErrors, id: \.self) { error in
                    HStack(alignment: .top) {
                        TinyIcon(color: .red, image: SystemIcon.circleFill.uiImage)
                        Text(error.stringRepresentation)
                    }.foregroundStyle(StudiumColor.failure.color)
                }
            }
            .padding(.horizontal, Increment.three)
        }
    }

    private var formView: some View {
        Form {
            Section(header: Text("Details").foregroundStyle(StudiumColor.placeholderLabel.color)) {
                StudiumTextField(text: self.$viewModel.name,
                                 placeholderText: "Name",
                                 charLimit: .shortField)
                StudiumTextField(text: self.$viewModel.location,
                                 placeholderText: "Location",
                                 charLimit: .shortField)
//                WeekdaysSelectorView(selectedDays: self.$viewModel.daysSelected)
            }.listRowBackground(StudiumColor.tertiaryBackground.color)

//            Section(header: Text("Start / End Time")) {
//                if self.viewModel.showAutoschedulingFields {
//                    Toggle(isOn: self.$viewModel.isAutoscheduling, label: {
//                        Text("Autoschedule")
//                    })
//                    .tint(StudiumColor.secondaryAccent.color)
//                }
//                
//                
//                if self.viewModel.showAutoschedulingFields {
//                    TimePicker(label: "Between", time: self.$viewModel.startTime)
//                    TimePicker(label: "And", time: self.$viewModel.endTime)
//                    TimeLengthPickerView(totalMinutes: self.$viewModel.totalAutoscheduleLengthMinutes)
//                } else {
//                    TimePicker(label: "Starts", time: self.$viewModel.startTime)
//                    TimePicker(label: "Ends", time: self.$viewModel.endTime)
//                }
//                
//                
//                ShowNotificationSelectionButton(selectedOptions: self.$viewModel.notificationSelections)
//            }
            Section(header: Text("Start / End Date").foregroundStyle(StudiumColor.placeholderLabel.color)) {
                if self.viewModel.showAutoschedulingFields {
                    Toggle(isOn: self.$viewModel.isAutoscheduling, label: {
                        Text("Autoschedule")
                    })
                    .tint(StudiumColor.secondaryAccent.color)

                    WeekdaysSelectorView(selectedDays: self.$viewModel.autoscheduleDays)
                    TimeLengthPickerView(totalMinutes: self.$viewModel.totalAutoscheduleLengthMinutes)
                    //                TimePicker(label: "Starts", time: self.$viewModel.startTime)
                    //                TimePicker(label: "Ends", time: self.$viewModel.endTime)
                    ShowNotificationSelectionButton(selectedOptions: self.$viewModel.notificationSelections)
                }
            }.listRowBackground(StudiumColor.tertiaryBackground.color)

//            Section(header: Text("Customization").foregroundStyle(StudiumColor.placeholderLabel.color)) {
//                ShowIconSelectorButton(icon: self.$viewModel.icon)
//                ColorPickerView(selectedColor: self.$viewModel.color, colors: StudiumEventColor.allCasesUIColors)
//            }.listRowBackground(StudiumColor.tertiaryBackground.color)

            Section {
                StudiumTextField(text: self.$viewModel.additionalDetails,
                                 placeholderText: "Additional Details",
                                 charLimit: .longField)
            }.listRowBackground(StudiumColor.tertiaryBackground.color)
        }
    }
}
