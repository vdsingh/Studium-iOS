//
//  EditOtherEventViewController.swift
//  Studium
//
//  Created by Vikram Singh on 9/28/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

class OtherEventFormViewController: SwiftUIViewController<OtherEventFormView> {
    
    var addOtherEventView: OtherEventFormView? = nil
    
    override func loadView() {
        super.loadView()
        if let addOtherEventView = self.addOtherEventView {
            self.setupSwiftUI(withView: addOtherEventView)
        }
        
        self.setStudiumFormNavigationStyle()
    }
    
    /// OtherEventFormViewController
    /// - Parameter otherEventToEdit: OtherEvent that we want to edit. Nil if we want to add
    init(otherEventToEdit: OtherEvent? = nil, refreshCallback: @escaping () -> Void) {
        super.init()

        if let otherEventToEdit {
            let viewModel = OtherEventFormViewModel(
                otherEvent: otherEventToEdit) {
                    refreshCallback()
                    self.dismiss(animated: true)
                }
            self.addOtherEventView = OtherEventFormView(viewModel: viewModel)
        } else {
            let viewModel = OtherEventFormViewModel() {
                refreshCallback()
                self.dismiss(animated: true)
            }
            self.addOtherEventView = OtherEventFormView(viewModel: viewModel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
