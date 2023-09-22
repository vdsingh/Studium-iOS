//
//  EditCourseViewController.swift
//  Studium
//
//  Created by Vikram Singh on 9/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct EditCourseForm: View {
    let navigationController: UINavigationController?
    let course: Course
    var body: some View {
        CourseFormView(course: course, navigationController: self.navigationController)
    }
}
