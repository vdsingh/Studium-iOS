//
//  AssignmentFormViewController.swift
//  Studium
//
//  Created by Vikram Singh on 10/4/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

class AssignmentFormViewController: SwiftUIViewController<AssignmentFormView> {

    let viewModel: AssignmentFormViewModel
    lazy var assignmentForm = AssignmentFormView(viewModel: self.viewModel)

    override func loadView() {
        super.loadView()
        self.setupSwiftUI(withView: self.assignmentForm)
        self.setStudiumFormNavigationStyle()
    }

    init(course: Course, assignment: Assignment? = nil, refreshCallback: @escaping () -> Void) {
        if let assignment {
            self.viewModel = AssignmentFormViewModel(assignment: assignment,
                                                     willComplete: refreshCallback)
        } else {
            self.viewModel = AssignmentFormViewModel(course: course,
                                                     willComplete: refreshCallback)
        }

        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct AssignmentFormPreview: PreviewProvider {
    static let controller = AssignmentFormViewController(course: .mock(), refreshCallback: {})
    static var previews: some View {
        self.controller.assignmentForm
    }
}
