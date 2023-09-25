//
//  AddCourseViewController2.swift
//  Studium
//
//  Created by Vikram Singh on 9/16/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct StudiumFormNavigationConstants {
    static let navBarBackgroundColor: Color = StudiumColor.primaryAccent.color
    static let navBarForegroundColor: Color = StudiumColor.primaryLabelColor(forBackgroundColor: StudiumFormNavigationConstants.navBarBackgroundColor)
}

struct PlusNavigationButton: View {
    let onClick: () -> Void
    var body: some View {
        Button() {
            self.onClick()
        } label: {
            MiniIcon(color: StudiumFormNavigationConstants.navBarForegroundColor, image: SystemIcon.plus.createImage())
        }
    }
}

struct AddCourseForm: View {
    
    let refreshCallback: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @State var formErrors: [StudiumFormError] = []
    
    @State var name: String = ""
    @State var location: String = ""
    @State var daysSelected: Set<Weekday> = []
    
    @State var startDate: Date = Date()
    @State var endDate: Date = Date().add(hours: 1)
    @State var notificationSelections: [AlertOption] = UserDefaultsService.defaultNotificationPreferences
    
    @State var icon: StudiumIcon = .book
    @State var color: UIColor? = StudiumEventColor.blue.uiColor
    
    @State var additionalDetails: String = ""
    
    
    var courseFormView: CourseFormView {
        CourseFormView(formErrors: self.$formErrors, name: self.$name, location: self.$location, daysSelected: self.$daysSelected, startDate: self.$startDate, endDate: self.$endDate, notificationSelections: self.$notificationSelections, icon: self.$icon, color: self.$color, additionalDetails: self.$additionalDetails)
    }
    
    var body: some View {
        NavigationView {
            self.courseFormView
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Add Course")
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
                            if let createdCourse = self.courseFormView.createdCourse() {
                                StudiumEventService.shared.saveStudiumEvent(createdCourse)
                                self.refreshCallback()
                                self.dismiss()
                            }
                        }
                    }
                }
        }
        .accentColor(StudiumFormNavigationConstants.navBarForegroundColor)
    }
    
    func saveCourse(_ course: Course) {
        StudiumEventService.shared.saveStudiumEvent(course)
    }
}

class AddCourseViewController: SwiftUIViewController<AddCourseForm> {
    
    let refreshCallback: () -> Void
    lazy var addCourseView = AddCourseForm(refreshCallback: self.refreshCallback)
    
    override func loadView() {
        super.loadView()
        self.setupSwiftUI(withView: self.addCourseView)
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

struct AddCoursePreview: PreviewProvider {
    static let addCourseViewController = AddCourseViewController(refreshCallback: {})
    static let mockCourse = MockStudiumEventService.getMockCourse()
    static var previews: some View {
        self.addCourseViewController.addCourseView
            .background(StudiumColor.background.color)
    }
}

extension UIViewController {
    func setStudiumFormNavigationStyle() {
        let navBarBackgroundColor = StudiumFormNavigationConstants.navBarBackgroundColor
        UINavigationBar.appearance().backgroundColor = navBarBackgroundColor.uiColor
        UINavigationBar.appearance().barTintColor = navBarBackgroundColor.uiColor
        UINavigationBar.appearance().tintColor = navBarBackgroundColor.uiColor
    }
}

