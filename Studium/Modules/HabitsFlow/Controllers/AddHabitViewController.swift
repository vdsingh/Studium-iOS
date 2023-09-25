//
//  AddHabitViewController2.swift
//  Studium
//
//  Created by Vikram Singh on 9/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct AddHabitForm: View {
    
    let refreshCallback: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @State var formErrors: [StudiumFormError] = []
    
    @State var name: String = ""
    @State var location: String = ""
    @State var daysSelected: Set<Weekday> = []
    
    @State var startDate: Date = Date()
    @State var endDate: Date = Date().add(hours: 1)
    @State var isAutoscheduling: Bool = false
    @State var totalAutoscheduleLengthMinutes: Int = 60
    @State var notificationSelections: [AlertOption] = UserDefaultsService.defaultNotificationPreferences
    
    @State var icon: StudiumIcon = .book
    @State var color: UIColor? = StudiumEventColor.blue.uiColor
    
    @State var additionalDetails: String = ""
    
    var habitFormView: HabitFormView {
        HabitFormView(formErrors: self.$formErrors, name: self.$name,
                      location: self.$location, daysSelected: self.$daysSelected, 
                      isAutoscheduling: self.$isAutoscheduling,
                      startDate: self.$startDate, endDate: self.$endDate,
                      totalAutoscheduleLengthMinutes: self.$totalAutoscheduleLengthMinutes,
                      notificationSelections: self.$notificationSelections,
                      icon: self.$icon, color: self.$color,
                      additionalDetails: self.$additionalDetails)
    }
    
    var body: some View {
        NavigationView {
            self.habitFormView
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Add Habit")
                            .foregroundColor(StudiumFormNavigationConstants.navBarForegroundColor)
                            .font(StudiumFont.bodySemibold.font)
                    }
                    
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button("Cancel") {
                            self.dismiss()
                        }.foregroundStyle(StudiumFormNavigationConstants.navBarForegroundColor)
                    }
                    
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        PlusNavigationButton() {
                            if let createdHabit = self.habitFormView.createdHabit() {
                                StudiumEventService.shared.saveStudiumEvent(createdHabit)
                                self.refreshCallback()
                                self.dismiss()
                            }
                        }
                    }
                }
        }
        .accentColor(StudiumFormNavigationConstants.navBarForegroundColor)
    }
    
    func saveHabit(_ habit: Habit) {
        StudiumEventService.shared.saveStudiumEvent(habit)
    }
}

class AddHabitViewController: SwiftUIViewController<AddHabitForm> {
    
    let refreshCallback: () -> Void
    lazy var addHabitView = AddHabitForm(refreshCallback: self.refreshCallback)
    
    override func loadView() {
        super.loadView()
        self.setupSwiftUI(withView: self.addHabitView)
        self.setStudiumFormNavigationStyle()
    }
    
    init(refreshCallback: @escaping () -> Void) {
        self.refreshCallback = refreshCallback
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//struct AddCoursePreview: PreviewProvider {
//    static let addCourseViewController = AddCourseViewController(refreshCallback: {})
//    static let mockCourse = MockStudiumEventService.getMockCourse()
//    static var previews: some View {
//        self.addCourseViewController.addCourseView
//            .background(StudiumColor.background.color)
//    }
//}
