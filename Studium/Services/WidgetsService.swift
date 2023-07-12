//
//  WidgetsService.swift
//  Studium
//
//  Created by Vikram Singh on 7/5/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import WidgetKit

enum WidgetKind: String {
    case AssignmentsWidget
}

class WidgetsService {
        
    static let shared = WidgetsService()
    
    private init () { }
    
    let widgetCenter = WidgetCenter.shared
    
    func reloadAssignmentsWidget() {
        self.widgetCenter.reloadTimelines(ofKind: WidgetKind.AssignmentsWidget.rawValue)
    }
}
