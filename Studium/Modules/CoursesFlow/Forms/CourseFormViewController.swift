//
//  EditCourseViewController.swift
//  Studium
//
//  Created by Vikram Singh on 9/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

class CourseFormViewController: SwiftUIViewController<CourseFormView> {
    
//    var refreshCallback: () -> Void
    
    let viewModel: CourseFormViewModel
    lazy var editCourseForm = CourseFormView(viewModel: self.viewModel)
    
    override func loadView() {
        super.loadView()
        self.setupSwiftUI(withView: self.editCourseForm)
        self.setStudiumFormNavigationStyle()
    }
    
    init(course: Course? = nil, refreshCallback: @escaping () -> Void) {
        if let course {
            self.viewModel = CourseFormViewModel(course: course, willComplete: refreshCallback)
        } else {
            self.viewModel = CourseFormViewModel(willComplete: refreshCallback)
        }
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
