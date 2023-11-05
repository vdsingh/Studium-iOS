//
//  OtherEventViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/6/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//


import RealmSwift
import UIKit
import SwiftUI

class OtherEventViewController: UIViewController {
    
    let otherEvent: OtherEvent
    let editButtonPressed: () -> Void
    let deleteButtonPressed: () -> Void
    
    init(
        otherEvent: OtherEvent,
        editButtonPressed: @escaping () -> Void,
        deleteButtonPressed: @escaping () -> Void
    ) {
        self.otherEvent = otherEvent
        self.editButtonPressed = editButtonPressed
        self.deleteButtonPressed = deleteButtonPressed
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = StudiumColor.primaryLabelColor(forBackgroundColor: self.otherEvent.color)
        self.navigationController?.navigationBar.backgroundColor = self.otherEvent.color
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSwiftUI()
        
        let editImage = SystemIcon.pencilCircleFill.createImage()
        let editItem = UIBarButtonItem(image: editImage, style: .done, target: self, action: #selector(self.editAssignment))
        
        let deleteItem = UIBarButtonItem(image: SystemIcon.trashCanCircleFill.createImage(), style: .done, target: self, action: #selector(self.deleteAssignment))
        self.navigationItem.rightBarButtonItems = [
            editItem,
            deleteItem
        ]
    }
    
    private func setupSwiftUI() {
        let assignmentView = OtherEventDetailsView(
            otherEvent: self.otherEvent
        )
        
        let hostingController = UIHostingController(rootView: assignmentView)
        self.addChild(hostingController)
        
        self.view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    func openPDFViewController(url: URL) {
        let pdfViewController = PDFViewController(pdfURL: url)
        self.navigationController?.pushViewController(pdfViewController, animated: true)
    }
    
    @objc private func editAssignment() {
        self.editButtonPressed()
    }
    
    @objc private func deleteAssignment() {
        self.deleteButtonPressed()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//struct ContentView_Previews: PreviewProvider {
//    
//    static var weekdays: Set<Weekday> {
//        var set = Set<Weekday>()
//        set.insert(.wednesday)
//        set.insert(.monday)
//        return set
//    }
//    
//    static let mockOtherEvent = OtherEvent(name: "To Do Event", location: "Some Place", additionalDetails: "Some additional details", startDate: Date(), endDate: Date() + 100000, color: .green, icon: .atom, alertTimes: [])
//    
//    static var previews: some View {
//        OtherEventView(otherEvent: mockOtherEvent)
//    }
//}
