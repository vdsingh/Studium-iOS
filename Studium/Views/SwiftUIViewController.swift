//
//  SwiftUIViewController.swift
//  Studium
//
//  Created by Vikram Singh on 9/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

class SwiftUIViewController<Content>: UIViewController where Content: View {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    func setupSwiftUI(withView view: Content) {
//        let addCourseView = AddCourseForm(presentingViewController: self)
        let hostingController = UIHostingController(rootView: view)
        self.addChild(hostingController)
        
        self.view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
//        self.title = "Add Course"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
