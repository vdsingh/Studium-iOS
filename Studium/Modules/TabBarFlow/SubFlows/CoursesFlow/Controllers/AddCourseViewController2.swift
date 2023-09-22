//
//  AddCourseViewController2.swift
//  Studium
//
//  Created by Vikram Singh on 9/16/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct AddCourseForm: View {
    let navigationController: UINavigationController?

    var body: some View {
        CourseFormView(navigationController: self.navigationController)
    }
}

class AddCourseViewController2: SwiftUIViewController<AddCourseForm> {
    
    lazy var addCourseView = AddCourseForm(navigationController: self.navigationController)
    
    override func loadView() {
        super.loadView()
        self.setupSwiftUI(withView: self.addCourseView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backgroundColor = StudiumColor.primaryAccent.uiColor
        self.navigationController?.navigationBar.tintColor = StudiumColor.primaryLabel.uiColor
                
        let addImage = SystemIcon.plus.uiImage
        let addItem = UIBarButtonItem(image: addImage, style: .done, target: self, action: #selector(self.doneWasPressed))
        
        let cancelItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancelWasPressed))

        self.navigationItem.rightBarButtonItem = addItem
        self.navigationItem.leftBarButtonItem = cancelItem
        
        self.title = "Add Course"
    }
    
    @objc private func doneWasPressed() {
        self.dismiss(animated: true)
    }
    
    @objc private func cancelWasPressed() {
        self.dismiss(animated: true)
    }
}

struct AddCoursePreview: PreviewProvider {
    static let addCourseViewController = AddCourseViewController2()
    static let mockCourse = MockStudiumEventService.getMockCourse()
    static var previews: some View {
        self.addCourseViewController.addCourseView
            .background(StudiumColor.background.color)
    }
}
