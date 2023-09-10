//
//  TimePickerCellV2.swift
//  
//
//  Created by Vikram Singh on 8/6/23.
//

import Foundation
import UIKit
import SwiftUI

struct DatePickerCellView: View {
    @State private var date = Date()
    var body: some View {
        DatePicker("Start Date", selection: self.$date, displayedComponents: [.date])
            .datePickerStyle(.graphical)
    }
}


class DatePickerCell: UITableViewCell {
    static let id = "DatePickerCell"
    
    private weak var controller: UIHostingController<DatePickerCellView>?
    
    func host(parent: UIViewController) {
        let view = DatePickerCellView()
        if let controller = self.controller {
            controller.rootView = view
            controller.view.layoutIfNeeded()
        } else {
            let swiftUICellViewController = UIHostingController(rootView: view)
            self.controller = swiftUICellViewController
            
            parent.addChild(swiftUICellViewController)
            self.contentView.addSubview(swiftUICellViewController.view)
            swiftUICellViewController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.contentView.leadingAnchor.constraint(equalTo: swiftUICellViewController.view.leadingAnchor),
                self.contentView.trailingAnchor.constraint(equalTo: swiftUICellViewController.view.trailingAnchor),
                self.contentView.topAnchor.constraint(equalTo: swiftUICellViewController.view.topAnchor),
                self.contentView.bottomAnchor.constraint(equalTo: swiftUICellViewController.view.bottomAnchor)
            ])

            swiftUICellViewController.didMove(toParent: parent)
            swiftUICellViewController.view.layoutIfNeeded()
        }
    }
    
//    func colorWasSelected(_ color: Color) {
//        self.colorWasSelected(color)
//    }
}
