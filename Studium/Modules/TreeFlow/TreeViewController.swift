//
//  TreeViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/13/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

enum TreeStatus {
    case healthy
    case surviving
    case wilting
    
    var uiImage: UIImage {
        switch self {
        case .healthy:
            return UIImage(named: "healthyTree") ?? .actions

        case .surviving:
            return UIImage(named: "survivingTree") ?? .actions

        case .wilting:
            return UIImage(named: "witheringTree") ?? .actions

        }
    }
}

struct TreeImage: View {
    @Binding var treeStatus: TreeStatus
    
    var body: some View {
        Image(uiImage: self.treeStatus.uiImage)
            .resizable()
            .foregroundStyle(.cyan)
            .scaledToFit()
            .frame(width: 200, height: 200)
    }
}

struct TreeView: View {
    @State var treeStatus: TreeStatus = .healthy
    var body: some View {
        VStack {
            TreeImage(treeStatus: self.$treeStatus)
            HStack {
                Button {
                    self.treeStatus = .healthy
                } label: {
                    Text("Healthy")
                }
                .buttonStyle(StudiumButtonStyle(disabled: false))

                Button {
                    self.treeStatus = .surviving
                } label: {
                    Text("okay")
                }
                .buttonStyle(StudiumButtonStyle(disabled: false))

                
                Button {
                    self.treeStatus = .wilting
                } label: {
                    Text("wilting")
                }
                .buttonStyle(StudiumButtonStyle(disabled: false))

            }
        }
    }
}

class TreeViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSwiftUI()
        self.navigationController?.navigationBar.prefersLargeTitles = false
//        self.navigationController?.navigationBar.tintColor = StudiumColor.primaryLabelColor(forBackgroundColor: self.assignment.color)
        
//        let editImage = SystemIcon.pencilCircleFill.createImage()
//        let editItem = UIBarButtonItem(image: editImage, style: .done, target: self, action: #selector(self.editAssignment))
//    
//        let deleteItem = UIBarButtonItem(image: SystemIcon.trashCanCircleFill.createImage(), style: .done, target: self, action: #selector(self.deleteAssignment))
//        
//        self.navigationItem.rightBarButtonItems = [
//            editItem,
//            deleteItem
//        ]
    }
    
    private func setupSwiftUI() {
        let treeView = TreeView()
        
        let hostingController = UIHostingController(rootView: treeView)
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
}
